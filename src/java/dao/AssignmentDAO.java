package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;
import model.StorageUnit;

public class AssignmentDAO extends DBContext {

    // ==========================================
    // CÁC HÀM TIỆN ÍCH CHUNG
    // ==========================================

    public int getStaffIdByCheckRequest(int checkRequestId) {
    String sql = "SELECT assigned_to FROM Staff_assignment WHERE check_request_id = ? LIMIT 1";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, checkRequestId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt("assigned_to");
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}
    
    public List<StorageUnit> getUnitsByWarehouse(int warehouseId) {
        List<StorageUnit> list = new ArrayList<>();
        String sql = "SELECT unit_id, unit_code, description FROM Storage_unit WHERE warehouse_id = ? AND status = 1";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StorageUnit u = new StorageUnit();
                    u.setUnitId(rs.getInt("unit_id"));
                    u.setUnitCode(rs.getString("unit_code"));
                    u.setDescription(rs.getString("description"));
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }    
    
    public int getOptimalStaffId(int warehouseId) {
        int staffId = -1;
        System.out.println("   [SYSTEM] Đang tìm nhân viên cho Kho ID: " + warehouseId);
        
        // ĐÃ SỬA: Đếm số lượng task đang làm bằng cách kiểm tra completed_at IS NULL
        String sql = "SELECT u.internal_user_id, COUNT(sa.assignment_id) as active_tasks " +
                     "FROM Internal_user u " +
                     "JOIN Warehouse w ON w.warehouse_id = ? AND TRIM(u.address) = TRIM(w.address) " + 
                     "LEFT JOIN Staff_assignment sa " +
                     "    ON u.internal_user_id = sa.assigned_to " +
                     "    AND sa.completed_at IS NULL " + 
                     "WHERE u.role_id = 3 " +
                     "  AND u.status = 1 " +    
                     "GROUP BY u.internal_user_id " +
                     "ORDER BY active_tasks ASC, u.internal_user_id ASC " +
                     "LIMIT 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staffId = rs.getInt("internal_user_id");
                    System.out.println("   [SYSTEM] Đã tìm thấy Staff phù hợp. ID: " + staffId);
                } else {
                    System.out.println("   [SYSTEM] LỖI: Không tìm thấy Staff nào ở CÙNG ĐỊA CHỈ với kho này!");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffId;
    }

    // ==========================================
    // LUỒNG 1: CHECK-IN KHI DUYỆT HỢP ĐỒNG (TỪ BẢNG CONTRACT)
    // ==========================================

    // ĐÃ BỎ: Tham số systemAssignedBy
    public boolean createCheckTaskFromPayment(int contractId) {
        boolean isTaskAssignedSuccessfully = false;
        System.out.println("========== BẮT ĐẦU LUỒNG TẠO TASK CHECK-IN (TỪ HỢP ĐỒNG) ==========");

        String contractQuery = "SELECT c.warehouse_id, DATE(c.start_date) AS start_date, DATE(DATE_ADD(c.start_date, INTERVAL 3 DAY)) AS task_due_date, c.request_id " +
                               "FROM Contract c WHERE c.contract_id = ?";
                               
        try (PreparedStatement psContract = connection.prepareStatement(contractQuery)) {
            psContract.setInt(1, contractId);
            
            try (ResultSet rsContract = psContract.executeQuery()) {
                if (rsContract.next()) {
                    int warehouseId = rsContract.getInt("warehouse_id");
                    String startedDate = rsContract.getString("start_date"); 
                    String dueDate = rsContract.getString("task_due_date"); 
                    int assignmentType = 1; // 1 là Check-in

                    int assignedTo = getOptimalStaffId(warehouseId);
                    if (assignedTo == -1) return false; 

                    List<Integer> unitIds = new ArrayList<>();
                    String unitQuery = "SELECT unit_id FROM Contract_Storage_unit WHERE contract_id = ?";
                    try (PreparedStatement psUnits = connection.prepareStatement(unitQuery)) {
                        psUnits.setInt(1, contractId);
                        try (ResultSet rsUnits = psUnits.executeQuery()) {
                            while (rsUnits.next()) { unitIds.add(rsUnits.getInt("unit_id")); }
                        }
                    }

                    if (unitIds.isEmpty()) { unitIds.add(null); }

                    for (Integer currentUnitId : unitIds) {
                        String description = "[HỆ THỐNG TỰ ĐỘNG] Hỗ trợ Check-in. Hợp đồng #" + contractId;
                        
                        // ĐÃ SỬA: Loại bỏ assigned_by, status, is_overdue khỏi INSERT
                        String insertAssignmentSQL = "INSERT INTO Staff_assignment " +
                                "(assigned_to, warehouse_id, unit_id, " +
                                "assignment_type, check_request_id, description, started_date, due_date) " +
                                "VALUES (?, ?, ?, ?, NULL, ?, ?, ?)";
                                
                        try (PreparedStatement psInsertAssignment = connection.prepareStatement(insertAssignmentSQL)) {
                            psInsertAssignment.setInt(1, assignedTo);
                            psInsertAssignment.setInt(2, warehouseId);
                            
                            if (currentUnitId != null) psInsertAssignment.setInt(3, currentUnitId);
                            else psInsertAssignment.setNull(3, Types.INTEGER); 
                            
                            psInsertAssignment.setInt(4, assignmentType);
                            psInsertAssignment.setString(5, description);
                            psInsertAssignment.setString(6, startedDate);
                            psInsertAssignment.setString(7, dueDate);
                            
                            int rowsAffected = psInsertAssignment.executeUpdate();
                            if (rowsAffected > 0) {
                                isTaskAssignedSuccessfully = true; 
                                System.out.println("   -> Đã tạo Task thành công từ Hợp đồng #" + contractId);
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return isTaskAssignedSuccessfully;
    }

    // ==========================================
    // LUỒNG 2: GOM CHUNG CHECK-IN / CHECK-OUT (TỪ BẢNG CHECK_REQUEST)
    // ==========================================

    // ĐÃ BỎ: Tham số systemAssignedBy
    public boolean createTaskFromCheckRequest(int checkRequestId) {
        boolean isTaskAssignedSuccessfully = false;
        System.out.println("========== BẮT ĐẦU TẠO TASK (TỪ YÊU CẦU CHECK-IN/OUT) ==========");

        String requestQuery = "SELECT warehouse_id, unit_id, request_type, DATE(request_date) AS request_date, DATE(DATE_ADD(request_date, INTERVAL 2 DAY)) AS task_due_date " +
                              "FROM check_request WHERE id = ?";

        try (PreparedStatement psReq = connection.prepareStatement(requestQuery)) {
            psReq.setInt(1, checkRequestId);

            try (ResultSet rsReq = psReq.executeQuery()) {
                if (rsReq.next()) {
                    int warehouseId = rsReq.getInt("warehouse_id");
                    String requestType = rsReq.getString("request_type");
                    String startedDate = rsReq.getString("request_date"); 
                    String dueDate = rsReq.getString("task_due_date");
                    
                    Integer unitId = rsReq.getInt("unit_id");
                    if (rsReq.wasNull()) { unitId = null; }

                    int assignmentType = requestType.equalsIgnoreCase("CHECK_OUT") ? 2 : 1; 
                    String actionName = requestType.equalsIgnoreCase("CHECK_OUT") ? "Xuất kho" : "Nhập kho";
                    String description = "Hỗ trợ khách hàng " + actionName + " (Đơn #" + checkRequestId + ")";

                    int assignedTo = getOptimalStaffId(warehouseId);
                    if (assignedTo == -1) {
                        System.out.println("-> THẤT BẠI: Không có nhân viên.");
                        return false;
                    }

                    // ĐÃ SỬA: Loại bỏ assigned_by, status, is_overdue khỏi INSERT
                    String insertAssignmentSQL = "INSERT INTO Staff_assignment " +
                            "(assigned_to, warehouse_id, unit_id, " +
                            "assignment_type, check_request_id, description, started_date, due_date) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                    try (PreparedStatement psInsertAssignment = connection.prepareStatement(insertAssignmentSQL)) {
                        psInsertAssignment.setInt(1, assignedTo);
                        psInsertAssignment.setInt(2, warehouseId);

                        if (unitId != null) psInsertAssignment.setInt(3, unitId);
                        else psInsertAssignment.setNull(3, Types.INTEGER);

                        psInsertAssignment.setInt(4, assignmentType);
                        psInsertAssignment.setInt(5, checkRequestId);
                        psInsertAssignment.setString(6, description);
                        psInsertAssignment.setString(7, startedDate);
                        psInsertAssignment.setString(8, dueDate);

                        int rowsAffected = psInsertAssignment.executeUpdate();

                        if (rowsAffected > 0) {
                            isTaskAssignedSuccessfully = true;
                            System.out.println("   -> Đã tạo Task thành công. Liên kết trực tiếp với Check Request ID: " + checkRequestId);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return isTaskAssignedSuccessfully;
    }
}
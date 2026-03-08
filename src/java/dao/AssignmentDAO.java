package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Warehouse;
import java.sql.Types;
import model.StorageUnit;

public class AssignmentDAO extends DBContext {

    // ==========================================
    // CÁC HÀM TIỆN ÍCH CHUNG
    // ==========================================

    public List<StorageUnit> getUnitsByWarehouse(int warehouseId) {
        List<StorageUnit> list = new ArrayList<>();
        String sql = "SELECT unit_id, unit_code, description FROM Storage_unit WHERE warehouse_id = ? AND status = 1";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, warehouseId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                StorageUnit u = new StorageUnit();
                u.setUnitId(rs.getInt("unit_id"));
                u.setUnitCode(rs.getString("unit_code"));
                u.setDescription(rs.getString("description"));
                list.add(u);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }    
    
    public int getOptimalStaffId(int warehouseId) {
        int staffId = -1;
        System.out.println("   [SYSTEM] Đang tìm nhân viên cho Kho ID: " + warehouseId);
        
        String sql = "SELECT u.internal_user_id, COUNT(sa.assignment_id) as active_tasks " +
                     "FROM Internal_user u " +
                     "JOIN Warehouse w ON w.warehouse_id = ? AND TRIM(u.address) = TRIM(w.address) " + 
                     "LEFT JOIN Staff_assignment sa " +
                     "    ON u.internal_user_id = sa.assigned_to " +
                     "    AND sa.status = 1 " + 
                     "WHERE u.role_id = 3 " +
                     "  AND u.status = 1 " +    
                     "GROUP BY u.internal_user_id " +
                     "ORDER BY active_tasks ASC, u.internal_user_id ASC " +
                     "LIMIT 1";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, warehouseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                staffId = rs.getInt("internal_user_id");
                System.out.println("   [SYSTEM] Đã tìm thấy Staff phù hợp. ID: " + staffId + " (Đang có " + rs.getInt("active_tasks") + " task)");
            } else {
                System.out.println("   [SYSTEM] LỖI: Không tìm thấy Staff nào ở CÙNG ĐỊA CHỈ với kho này!");
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffId;
    }

    // ==========================================
    // LUỒNG 1: CHECK-IN KHI DUYỆT HỢP ĐỒNG (TỪ BẢNG CONTRACT)
    // (Đã cập nhật theo schema mới: Bỏ assigned_at, thêm started_date)
    // ==========================================

    public boolean createCheckTaskFromPayment(int contractId, int systemAssignedBy) {
        boolean isTaskAssignedSuccessfully = false;
        System.out.println("========== BẮT ĐẦU LUỒNG TẠO TASK CHECK-IN (TỪ HỢP ĐỒNG) ==========");

        String contractQuery = "SELECT c.warehouse_id, c.start_date, DATE_ADD(c.start_date, INTERVAL 2 DAY) AS task_due_date, c.request_id " +
                               "FROM Contract c WHERE c.contract_id = ?";
                               
        try (PreparedStatement psContract = connection.prepareStatement(contractQuery)) {
            psContract.setInt(1, contractId);
            
            try (ResultSet rsContract = psContract.executeQuery()) {
                if (rsContract.next()) {
                    int warehouseId = rsContract.getInt("warehouse_id");
                    String startedDate = rsContract.getString("start_date"); // Lấy ngày bắt đầu HĐ làm started_date
                    String dueDate = rsContract.getString("task_due_date"); 
                    int requestId = rsContract.getInt("request_id");
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
                        
                        // Câu lệnh Insert đã sửa theo DB mới
                        String insertAssignmentSQL = "INSERT INTO Staff_assignment " +
                                "(assigned_to, warehouse_id, unit_id, assigned_by, " +
                                "assignment_type, description, started_date, due_date, status, is_overdue) " +
                                "VALUES (?, ?, ?, ?, ?, ?, DATE(?), ?, 1, 0)";
                                
                        try (PreparedStatement psInsertAssignment = connection.prepareStatement(insertAssignmentSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                            psInsertAssignment.setInt(1, assignedTo);
                            psInsertAssignment.setInt(2, warehouseId);
                            
                            if (currentUnitId != null) psInsertAssignment.setInt(3, currentUnitId);
                            else psInsertAssignment.setNull(3, Types.INTEGER); 
                            
                            psInsertAssignment.setInt(4, systemAssignedBy);
                            psInsertAssignment.setInt(5, assignmentType);
                            psInsertAssignment.setString(6, description);
                            psInsertAssignment.setString(7, startedDate); // Chuyển thành started_date (DATE)
                            psInsertAssignment.setString(8, dueDate);
                            
                            int rowsAffected = psInsertAssignment.executeUpdate();
                            if (rowsAffected > 0) {
                                isTaskAssignedSuccessfully = true; 
                                try (ResultSet generatedKeys = psInsertAssignment.getGeneratedKeys()) {
                                    if (generatedKeys.next()) {
                                        fillItemsFromRentRequest(generatedKeys.getInt(1), requestId);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isTaskAssignedSuccessfully;
    }

    private void fillItemsFromRentRequest(int newAssignmentId, int requestId) {
         String itemQuery = "SELECT rri.item_id, i.item_name FROM rent_request_item rri JOIN Item i ON rri.item_id = i.item_id WHERE rri.request_id = ?";
         try (PreparedStatement psItems = connection.prepareStatement(itemQuery)) {
             psItems.setInt(1, requestId);
             try (ResultSet rsItems = psItems.executeQuery()) {
                 String insertItemSQL = "INSERT INTO Staff_assignment_item (assignment_id, item_id, item_name, quantity, note) VALUES (?, ?, ?, ?, ?)";
                 try (PreparedStatement psInsertItem = connection.prepareStatement(insertItemSQL)) {
                     while (rsItems.next()) {
                         psInsertItem.setInt(1, newAssignmentId);
                         psInsertItem.setInt(2, rsItems.getInt("item_id"));
                         psInsertItem.setString(3, rsItems.getString("item_name"));
                         psInsertItem.setInt(4, 1); 
                         psInsertItem.setString(5, "Từ Đơn thuê #" + requestId);
                         psInsertItem.addBatch();
                     }
                     psInsertItem.executeBatch();
                 }
             }
         } catch (SQLException e) { e.printStackTrace(); }
    }

    // ==========================================
    // LUỒNG 2: GOM CHUNG CHECK-IN / CHECK-OUT (TỪ BẢNG CHECK_REQUEST)
    // ==========================================

    /**
     * Hàm đa năng xử lý cả Nhập và Xuất kho dựa vào bảng check_request
     */
    public boolean createTaskFromCheckRequest(int checkRequestId, int systemAssignedBy) {
        boolean isTaskAssignedSuccessfully = false;
        System.out.println("========== BẮT ĐẦU TẠO TASK (GOM CHUNG IN/OUT) ==========");

        // Lấy ngày tạo đơn làm started_date. Hạn chót là ngày tạo đơn + 2 ngày
        String requestQuery = "SELECT warehouse_id, unit_id, request_type, request_date, DATE_ADD(request_date, INTERVAL 2 DAY) AS task_due_date " +
                              "FROM check_request WHERE id = ?";

        try (PreparedStatement psReq = connection.prepareStatement(requestQuery)) {
            psReq.setInt(1, checkRequestId);

            try (ResultSet rsReq = psReq.executeQuery()) {
                if (rsReq.next()) {
                    int warehouseId = rsReq.getInt("warehouse_id");
                    String requestType = rsReq.getString("request_type");
                    String startedDate = rsReq.getString("request_date"); // Lấy request_date
                    String dueDate = rsReq.getString("task_due_date");
                    
                    Integer unitId = rsReq.getInt("unit_id");
                    if (rsReq.wasNull()) { unitId = null; }

                    // Phân loại task và nội dung
                    int assignmentType = requestType.equalsIgnoreCase("CHECK_OUT") ? 2 : 1; 
                    String actionName = requestType.equalsIgnoreCase("CHECK_OUT") ? "Xuất kho" : "Nhập kho";
                    String description = "Hỗ trợ khách hàng " + actionName + " (Đơn #" + checkRequestId + ")";

                    int assignedTo = getOptimalStaffId(warehouseId);
                    if (assignedTo == -1) {
                        System.out.println("-> THẤT BẠI: Không có nhân viên.");
                        return false;
                    }

                    // Câu lệnh Insert theo Database mới (không có assigned_at)
                    String insertAssignmentSQL = "INSERT INTO Staff_assignment " +
                            "(assigned_to, warehouse_id, unit_id, assigned_by, " +
                            "assignment_type, description, started_date, due_date, status, is_overdue) " +
                            "VALUES (?, ?, ?, ?, ?, ?, DATE(?), ?, 1, 0)";

                    try (PreparedStatement psInsertAssignment = connection.prepareStatement(insertAssignmentSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                        psInsertAssignment.setInt(1, assignedTo);
                        psInsertAssignment.setInt(2, warehouseId);

                        if (unitId != null) psInsertAssignment.setInt(3, unitId);
                        else psInsertAssignment.setNull(3, Types.INTEGER);

                        psInsertAssignment.setInt(4, systemAssignedBy);
                        psInsertAssignment.setInt(5, assignmentType);
                        psInsertAssignment.setString(6, description);
                        psInsertAssignment.setString(7, startedDate); // Ép DATE() trong SQL
                        psInsertAssignment.setString(8, dueDate);

                        int rowsAffected = psInsertAssignment.executeUpdate();

                        if (rowsAffected > 0) {
                            isTaskAssignedSuccessfully = true;
                            try (ResultSet generatedKeys = psInsertAssignment.getGeneratedKeys()) {
                                if (generatedKeys.next()) {
                                    int newAssignmentId = generatedKeys.getInt(1);
                                    fillItemsFromCheckRequest(newAssignmentId, checkRequestId, actionName);
                                }
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isTaskAssignedSuccessfully;
    }

    /**
     * Hàm bổ trợ gom chung cho cả IN và OUT
     */
    private void fillItemsFromCheckRequest(int newAssignmentId, int checkRequestId, String actionName) {
        String itemQuery = "SELECT cri.item_id, i.item_name, cri.quantity " +
                           "FROM check_request_item cri JOIN Item i ON cri.item_id = i.item_id " +
                           "WHERE cri.check_request_id = ?";

        try (PreparedStatement psItems = connection.prepareStatement(itemQuery)) {
            psItems.setInt(1, checkRequestId);

            try (ResultSet rsItems = psItems.executeQuery()) {
                String insertItemSQL = "INSERT INTO Staff_assignment_item " +
                                       "(assignment_id, item_id, item_name, quantity, note) VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement psInsertItem = connection.prepareStatement(insertItemSQL)) {
                    while (rsItems.next()) {
                        psInsertItem.setInt(1, newAssignmentId);
                        psInsertItem.setInt(2, rsItems.getInt("item_id"));
                        psInsertItem.setString(3, rsItems.getString("item_name"));
                        psInsertItem.setInt(4, rsItems.getInt("quantity")); 
                        psInsertItem.setString(5, "Yêu cầu " + actionName + " #" + checkRequestId);
                        psInsertItem.addBatch();
                    }
                    psInsertItem.executeBatch();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
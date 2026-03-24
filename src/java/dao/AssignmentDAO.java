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

    /**
     * Tìm nhân viên (Role=3) thuộc đúng Kho (Warehouse) chỉ định
     * và có số lượng task đang làm (completed_at IS NULL) ít nhất.
     */
    public int getOptimalStaffId(int warehouseId) {
        int staffId = -1;
        System.out.println("   [SYSTEM] Đang tìm nhân viên rảnh nhất cho Kho ID: " + warehouseId);
        
        // LOGIC MỚI: JOIN trực tiếp qua warehouse_id của bảng Internal_user
        String sql = "SELECT u.internal_user_id, COUNT(sa.assignment_id) as active_tasks " +
                     "FROM Internal_user u " +
                     "LEFT JOIN Staff_assignment sa " +
                     "    ON u.internal_user_id = sa.assigned_to " +
                     "    AND sa.completed_at IS NULL " + 
                     "WHERE u.role_id = 3 " + // Chỉ lấy Staff
                     "  AND u.status = 1 " + // Nhân viên đang làm việc
                     "  AND u.warehouse_id = ? " + // ĐÚNG KHO CHỈ ĐỊNH
                     "GROUP BY u.internal_user_id " +
                     "ORDER BY active_tasks ASC, u.internal_user_id ASC " +
                     "LIMIT 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staffId = rs.getInt("internal_user_id");
                    System.out.println("   [SYSTEM] Đã tìm thấy Staff rảnh nhất. ID: " + staffId + " (Đang có " + rs.getInt("active_tasks") + " task)");
                } else {
                    System.out.println("   [SYSTEM] LỖI: Không có nhân viên nào được gán cho Kho ID: " + warehouseId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffId;
    }

    // ==========================================
    // LUỒNG 1: CHECK-IN KHI DUYỆT HỢP ĐỒNG (TỪ CONTRACT)
    // ==========================================
    public boolean createCheckTaskFromPayment(int contractId) {
        boolean isTaskAssignedSuccessfully = false;
        System.out.println("========== BẮT ĐẦU TẠO TASK CHECK-IN (TỪ HỢP ĐỒNG) ==========");

        String contractQuery = "SELECT c.warehouse_id, DATE(c.start_date) AS start_date, " +
                               "DATE(DATE_ADD(c.start_date, INTERVAL 3 DAY)) AS task_due_date " +
                               "FROM Contract c WHERE c.contract_id = ?";
                               
        try (PreparedStatement psContract = connection.prepareStatement(contractQuery)) {
            psContract.setInt(1, contractId);
            try (ResultSet rsContract = psContract.executeQuery()) {
                if (rsContract.next()) {
                    int warehouseId = rsContract.getInt("warehouse_id");
                    String startedDate = rsContract.getString("start_date"); 
                    String dueDate = rsContract.getString("task_due_date"); 

                    // Tìm nhân viên thuộc kho này
                    int assignedTo = getOptimalStaffId(warehouseId);
                    if (assignedTo == -1) return false; 

                    // Lấy danh sách Unit của hợp đồng
                    List<Integer> unitIds = new ArrayList<>();
                    String unitQuery = "SELECT unit_id FROM Contract_Storage_unit WHERE contract_id = ?";
                    try (PreparedStatement psUnits = connection.prepareStatement(unitQuery)) {
                        psUnits.setInt(1, contractId);
                        try (ResultSet rsUnits = psUnits.executeQuery()) {
                            while (rsUnits.next()) { unitIds.add(rsUnits.getInt("unit_id")); }
                        }
                    }
                    if (unitIds.isEmpty()) unitIds.add(null);

                    for (Integer currentUnitId : unitIds) {
                        String insertAssignmentSQL = "INSERT INTO Staff_assignment " +
                                "(assigned_to, warehouse_id, unit_id, " +
                                "assignment_type, check_request_id, description, started_date, due_date) " +
                                "VALUES (?, ?, ?, 1, NULL, ?, ?, ?)";
                                
                        try (PreparedStatement psInsertAssignment = connection.prepareStatement(insertAssignmentSQL)) {
                            psInsertAssignment.setInt(1, assignedTo);
                            psInsertAssignment.setInt(2, warehouseId);
                            if (currentUnitId != null) psInsertAssignment.setInt(3, currentUnitId);
                            else psInsertAssignment.setNull(3, Types.INTEGER); 
                            
                            psInsertAssignment.setString(4, "[HỆ THỐNG] Check-in tự động cho HĐ #" + contractId);
                            psInsertAssignment.setString(5, startedDate);
                            psInsertAssignment.setString(6, dueDate);
                            
                            if (psInsertAssignment.executeUpdate() > 0) isTaskAssignedSuccessfully = true;
                        }
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return isTaskAssignedSuccessfully;
    }

    // ==========================================
    // LUỒNG 2: CHECK-IN / CHECK-OUT TỪ YÊU CẦU CỦA KHÁCH
    // ==========================================
    public boolean createTaskFromCheckRequest(int checkRequestId) {
        boolean isTaskAssignedSuccessfully = false;
        System.out.println("========== BẮT ĐẦU TẠO TASK (TỪ YÊU CẦU KHÁCH) ==========");

        String requestQuery = "SELECT warehouse_id, unit_id, request_type, DATE(request_date) AS request_date, " +
                              "DATE(DATE_ADD(request_date, INTERVAL 2 DAY)) AS task_due_date " +
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
                    if (rsReq.wasNull()) unitId = null;

                    int assignmentType = requestType.equalsIgnoreCase("CHECK_OUT") ? 2 : 1; 
                    String actionName = requestType.equalsIgnoreCase("CHECK_OUT") ? "Xuất kho" : "Nhập kho";

                    int assignedTo = getOptimalStaffId(warehouseId);
                    if (assignedTo == -1) return false;

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
                        psInsertAssignment.setString(6, "Hỗ trợ khách hàng " + actionName + " (Đơn #" + checkRequestId + ")");
                        psInsertAssignment.setString(7, startedDate);
                        psInsertAssignment.setString(8, dueDate);

                        if (psInsertAssignment.executeUpdate() > 0) isTaskAssignedSuccessfully = true;
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return isTaskAssignedSuccessfully;
    }
}
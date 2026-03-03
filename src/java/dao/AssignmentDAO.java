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

    // --- (Các hàm cũ getActiveWarehouses, getUnitsByWarehouse, createAutoAssignment giữ nguyên) ---
public List<StorageUnit> getUnitsByWarehouse(int warehouseId) {
        List<StorageUnit> list = new ArrayList<>();
        // Giả sử bảng Storage_unit có cột unit_id, unit_code, description, status
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
                System.out.println("   [SYSTEM] LỖI: Không tìm thấy Staff nào có role_id=3, status=1 và ở CÙNG ĐỊA CHỈ với kho này!");
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffId;
    }

    /**
     * Kích hoạt giao việc Check-in tự động khi duyệt đơn
     */
    public boolean createCheckOutTaskFromRequest(int contractId, int systemAssignedBy) {
        boolean isTaskAssignedSuccessfully = false;
        System.out.println("========== BẮT ĐẦU LUỒNG TẠO TASK TỰ ĐỘNG ==========");
        System.out.println("1. Đang xử lý Contract ID: " + contractId);

        String contractQuery = "SELECT c.warehouse_id, c.start_date, c.request_id " +
                               "FROM Contract c " +
                               "WHERE c.contract_id = ?";
                               
        try (PreparedStatement psContract = connection.prepareStatement(contractQuery)) {
            psContract.setInt(1, contractId);
            
            try (ResultSet rsContract = psContract.executeQuery()) {
                if (rsContract.next()) {
                    int warehouseId = rsContract.getInt("warehouse_id");
                    String startDate = rsContract.getString("start_date"); 
                    int requestId = rsContract.getInt("request_id");
                    int assignmentType = 1; // 1 là Check-in
                    System.out.println("2. Đã tìm thấy Contract. Warehouse ID: " + warehouseId + ", Request ID: " + requestId);

                    // Tìm staff phù hợp
                    int assignedTo = getOptimalStaffId(warehouseId);
                    if (assignedTo == -1) {
                        System.out.println("-> THẤT BẠI: Hủy quá trình vì không có Staff nhận việc.");
                        return false; // Dừng lại vì không có người làm
                    }

                    // Tìm Unit (Các khoang chứa trong hợp đồng)
                    List<Integer> unitIds = new ArrayList<>();
                    String unitQuery = "SELECT unit_id FROM Contract_Storage_unit WHERE contract_id = ?";
                    try (PreparedStatement psUnits = connection.prepareStatement(unitQuery)) {
                        psUnits.setInt(1, contractId);
                        try (ResultSet rsUnits = psUnits.executeQuery()) {
                            while (rsUnits.next()) {
                                unitIds.add(rsUnits.getInt("unit_id"));
                            }
                        }
                    }
                    System.out.println("3. Số lượng Unit thuộc hợp đồng này là: " + unitIds.size());

                    // NẾU CÚ PHÁP CỦA BẠN CHƯA THÊM UNIT VÀO HỢP ĐỒNG -> TẠO TASK CHO TOÀN BỘ KHO (unit_id = null)
                    if (unitIds.isEmpty()) {
                        System.out.println("   [CẢNH BÁO] Hợp đồng này chưa liên kết với Storage Unit nào. Vẫn sẽ tạo task với unit_id = NULL.");
                        unitIds.add(null); 
                    }

                    for (Integer currentUnitId : unitIds) {
                        String description = "[HỆ THỐNG TỰ ĐỘNG] Hỗ trợ Check-in.";
                        String insertAssignmentSQL = "INSERT INTO Staff_assignment " +
                                "(assigned_date, assigned_to, warehouse_id, unit_id, assigned_by, " +
                                "assignment_type, description, assigned_at, due_date, status, is_overdue) " +
                                "VALUES (CURDATE(), ?, ?, ?, ?, ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), 1, 0)";
                                
                        try (PreparedStatement psInsertAssignment = connection.prepareStatement(insertAssignmentSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                            psInsertAssignment.setInt(1, assignedTo);
                            psInsertAssignment.setInt(2, warehouseId);
                            
                            if (currentUnitId != null) {
                                psInsertAssignment.setInt(3, currentUnitId);
                            } else {
                                psInsertAssignment.setNull(3, Types.INTEGER); // Gán NULL nếu không có unit
                            }
                            
                            psInsertAssignment.setInt(4, systemAssignedBy);
                            psInsertAssignment.setInt(5, assignmentType);
                            psInsertAssignment.setString(6, description);
                           
                            
                            System.out.println("4. Đang thực thi Insert vào Staff_assignment...");
                            int rowsAffected = psInsertAssignment.executeUpdate();
                            System.out.println("   -> Kết quả Insert: " + rowsAffected + " dòng thành công.");
                            
                            if (rowsAffected > 0) {
                                isTaskAssignedSuccessfully = true; 
                                try (ResultSet generatedKeys = psInsertAssignment.getGeneratedKeys()) {
                                    if (generatedKeys.next()) {
                                        int newAssignmentId = generatedKeys.getInt(1);
                                        System.out.println("5. Đã tạo xong Task ID: " + newAssignmentId + ". Bắt đầu copy Item...");
                                        fillAssignmentItems(newAssignmentId, requestId);
                                    }
                                }
                            }
                        }
                    }
                } else {
                    System.out.println("-> THẤT BẠI: Không tìm thấy Contract ID " + contractId + " (Bảng Contract đang rỗng hoặc sai ID).");
                }
            }
        } catch (SQLException e) {
            System.err.println("-> CÓ LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("========== KẾT THÚC LUỒNG ==========");
        return isTaskAssignedSuccessfully;
    }

    private void fillAssignmentItems(int newAssignmentId, int requestId) {
         String itemQuery = "SELECT rri.item_id, i.item_name " +
                            "FROM rent_request_item rri " +
                            "JOIN Item i ON rri.item_id = i.item_id " +
                            "WHERE rri.request_id = ?";
         try (PreparedStatement psItems = connection.prepareStatement(itemQuery)) {
             psItems.setInt(1, requestId);
             try (ResultSet rsItems = psItems.executeQuery()) {
                 String insertItemSQL = "INSERT INTO Staff_assignment_item " +
                                        "(assignment_id, item_id, item_name, quantity, note) " +
                                        "VALUES (?, ?, ?, ?, ?)";
                 try (PreparedStatement psInsertItem = connection.prepareStatement(insertItemSQL)) {
                     int count = 0;
                     while (rsItems.next()) {
                         psInsertItem.setInt(1, newAssignmentId);
                         psInsertItem.setInt(2, rsItems.getInt("item_id"));
                         psInsertItem.setString(3, rsItems.getString("item_name"));
                         psInsertItem.setInt(4, 1); 
                         psInsertItem.setString(5, "Từ Request #" + requestId);
                         psInsertItem.addBatch();
                         count++;
                     }
                     psInsertItem.executeBatch();
                     System.out.println("   -> Đã copy thành công " + count + " mặt hàng vào Task.");
                 }
             }
         } catch (SQLException e) {
             e.printStackTrace();
         }
    }
    // ==========================================
    // HÀM XỬ LÝ LUỒNG CHECK-OUT (XUẤT KHO)
    // ==========================================

    /**
     * Kích hoạt giao việc Check-out tự động khi Quản lý duyệt đơn xin Xuất Kho.
     * Hạn chót (Due date) được set là 2 ngày tính từ thời điểm duyệt.
     */
  // ==========================================
    // HÀM XỬ LÝ LUỒNG CHECK-IN (NHẬP KHO) TỪ REQUEST
    // ==========================================

    /**
     * Kích hoạt giao việc Check-in tự động khi Renter tạo đơn xin Nhập Kho.
     */
    public boolean createCheckInTaskFromRequest(int checkRequestId, int systemAssignedBy) {
        boolean isTaskAssignedSuccessfully = false;
        System.out.println("========== BẮT ĐẦU LUỒNG TẠO TASK CHECK-IN TỰ ĐỘNG ==========");
        System.out.println("1. Đang xử lý Check Request ID: " + checkRequestId);

        // Lấy thông tin từ bảng check_request với type là CHECK_IN. Set hạn chót là 2 ngày.
        String requestQuery = "SELECT warehouse_id, unit_id, DATE_ADD(CURDATE(), INTERVAL 2 DAY) AS task_due_date " +
                              "FROM check_request " +
                              "WHERE id = ? AND request_type = 'CHECK_IN'";

        try (PreparedStatement psReq = connection.prepareStatement(requestQuery)) {
            psReq.setInt(1, checkRequestId);

            try (ResultSet rsReq = psReq.executeQuery()) {
                if (rsReq.next()) {
                    int warehouseId = rsReq.getInt("warehouse_id");
                    
                    Integer unitId = rsReq.getInt("unit_id");
                    if (rsReq.wasNull()) { unitId = null; }
                    
                    String dueDate = rsReq.getString("task_due_date");
                    int assignmentType = 3; // Loại 3: Hỗ trợ Check-in / Check-out

                    System.out.println("2. Tìm thấy Đơn nhập kho. Warehouse ID: " + warehouseId + ", Unit ID: " + unitId);

                    int assignedTo = getOptimalStaffId(warehouseId);
                    if (assignedTo == -1) {
                        System.out.println("-> THẤT BẠI: Hủy quá trình do không tìm thấy nhân viên nào ở kho này.");
                        return false;
                    }

                    // Đổi mô tả thành Nhập Kho
                    String description = "[HỆ THỐNG TỰ ĐỘNG] Hỗ trợ Check-in (Nhập kho) cho Đơn #" + checkRequestId;
                    String insertAssignmentSQL = "INSERT INTO Staff_assignment " +
                            "(assigned_date, assigned_to, warehouse_id, unit_id, assigned_by, " +
                            "assignment_type, description, assigned_at, due_date, status, is_overdue) " +
                            "VALUES (CURDATE(), ?, ?, ?, ?, ?, ?, NOW(), ?, 1, 0)";

                    try (PreparedStatement psInsertAssignment = connection.prepareStatement(insertAssignmentSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                        psInsertAssignment.setInt(1, assignedTo);
                        psInsertAssignment.setInt(2, warehouseId);

                        if (unitId != null) {
                            psInsertAssignment.setInt(3, unitId);
                        } else {
                            psInsertAssignment.setNull(3, Types.INTEGER);
                        }

                        psInsertAssignment.setInt(4, systemAssignedBy);
                        psInsertAssignment.setInt(5, assignmentType);
                        psInsertAssignment.setString(6, description);
                        psInsertAssignment.setString(7, dueDate);

                        System.out.println("3. Đang tạo Task Nhập kho cho nhân viên...");
                        int rowsAffected = psInsertAssignment.executeUpdate();

                        if (rowsAffected > 0) {
                            isTaskAssignedSuccessfully = true;
                            try (ResultSet generatedKeys = psInsertAssignment.getGeneratedKeys()) {
                                if (generatedKeys.next()) {
                                    int newAssignmentId = generatedKeys.getInt(1);
                                    System.out.println("4. Đã tạo Task ID: " + newAssignmentId + ". Đang copy mặt hàng nhập kho...");
                                    
                                    fillCheckInAssignmentItems(newAssignmentId, checkRequestId);
                                }
                            }
                        }
                    }
                } else {
                    System.out.println("-> THẤT BẠI: Không tìm thấy Đơn Check-in ID " + checkRequestId);
                }
            }
        } catch (SQLException e) {
            System.err.println("-> LỖI SQL TẠO TASK CHECK-IN: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("========== KẾT THÚC LUỒNG CHECK-IN ==========");
        return isTaskAssignedSuccessfully;
    }

    /**
     * Hàm nội bộ bổ trợ cho Check-in: Copy danh sách Item kèm theo số lượng
     */
    private void fillCheckInAssignmentItems(int newAssignmentId, int checkRequestId) {
        String itemQuery = "SELECT cri.item_id, i.item_name, cri.quantity " +
                           "FROM check_request_item cri " +
                           "JOIN Item i ON cri.item_id = i.item_id " +
                           "WHERE cri.check_request_id = ?";

        try (PreparedStatement psItems = connection.prepareStatement(itemQuery)) {
            psItems.setInt(1, checkRequestId);

            try (ResultSet rsItems = psItems.executeQuery()) {
                String insertItemSQL = "INSERT INTO Staff_assignment_item " +
                                       "(assignment_id, item_id, item_name, quantity, note) " +
                                       "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement psInsertItem = connection.prepareStatement(insertItemSQL)) {
                    int count = 0;
                    while (rsItems.next()) {
                        psInsertItem.setInt(1, newAssignmentId);
                        psInsertItem.setInt(2, rsItems.getInt("item_id"));
                        psInsertItem.setString(3, rsItems.getString("item_name"));
                        psInsertItem.setInt(4, rsItems.getInt("quantity")); 
                        psInsertItem.setString(5, "Yêu cầu nhập kho #" + checkRequestId);

                        psInsertItem.addBatch();
                        count++;
                    }
                    psInsertItem.executeBatch();
                    System.out.println("   -> Thành công! Đã đẩy " + count + " loại mặt hàng vào lệnh Nhập kho.");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi insert Items cho Check-in: " + e.getMessage());
            e.printStackTrace();
        }
    }
    /**
     * Hàm nội bộ bổ trợ cho Check-out: Copy danh sách Item kèm theo số lượng (Quantity)
     */
    private void fillCheckOutAssignmentItems(int newAssignmentId, int checkRequestId) {
        // Lấy item_id, item_name và đặc biệt là QUANTITY từ bảng check_request_item
        String itemQuery = "SELECT cri.item_id, i.item_name, cri.quantity " +
                           "FROM check_request_item cri " +
                           "JOIN Item i ON cri.item_id = i.item_id " +
                           "WHERE cri.check_request_id = ?";

        try (PreparedStatement psItems = connection.prepareStatement(itemQuery)) {
            psItems.setInt(1, checkRequestId);

            try (ResultSet rsItems = psItems.executeQuery()) {
                String insertItemSQL = "INSERT INTO Staff_assignment_item " +
                                       "(assignment_id, item_id, item_name, quantity, note) " +
                                       "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement psInsertItem = connection.prepareStatement(insertItemSQL)) {
                    int count = 0;
                    while (rsItems.next()) {
                        psInsertItem.setInt(1, newAssignmentId);
                        psInsertItem.setInt(2, rsItems.getInt("item_id"));
                        psInsertItem.setString(3, rsItems.getString("item_name"));
                        
                        // Lấy chính xác số lượng khách yêu cầu xuất kho
                        psInsertItem.setInt(4, rsItems.getInt("quantity")); 
                        psInsertItem.setString(5, "Yêu cầu xuất kho #" + checkRequestId);

                        psInsertItem.addBatch();
                        count++;
                    }
                    psInsertItem.executeBatch();
                    System.out.println("   -> Thành công! Đã đẩy " + count + " loại mặt hàng vào lệnh Xuất kho.");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi insert Items cho Check-out: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
}
package dao; // Hãy đảm bảo package name khớp với project của bạn

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Warehouse;
import java.sql.Types;
import model.StorageUnit;

// Kế thừa DBContext để sử dụng biến 'connection'
public class AssignmentDAO extends DBContext {

    /**
     * Thuật toán tìm nhân viên (Staff) tối ưu nhất:
     * 1. Là Staff (role_id = 3)
     * 2. Đang hoạt động, chưa thôi việc (status = 1)
     * 3. Có địa chỉ (address) trùng với địa chỉ của Kho (Warehouse)
     * 4. Số task ĐANG LÀM (status = 1 trong Staff_assignment) là ít nhất
     */
    public int getOptimalStaffId(int warehouseId) {
        int staffId = -1;
        
        String sql = "SELECT u.internal_user_id, COUNT(sa.assignment_id) as active_tasks " +
                     "FROM Internal_user u " +
                     "JOIN Warehouse w ON w.warehouse_id = ? AND u.address = w.address " + 
                     "LEFT JOIN Staff_assignment sa " +
                     "    ON u.internal_user_id = sa.assigned_to " +
                     "    AND sa.status = 1 " + // Chỉ đếm các task đang xử lý
                     "WHERE u.role_id = 3 " +
                     "  AND u.status = 1 " +    // Loại trừ nhân viên đã nghỉ việc
                     "GROUP BY u.internal_user_id " +
                     "ORDER BY active_tasks ASC, u.internal_user_id ASC " +
                     "LIMIT 1";

        try {
            // Sử dụng trực tiếp 'connection' từ lớp cha DBContext
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, warehouseId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                staffId = rs.getInt("internal_user_id");
            }
            
            // Đóng ResultSet và PreparedStatement sau khi dùng xong
            rs.close();
            ps.close();
            
        } catch (SQLException e) {
            System.out.println("Lỗi khi tìm Staff theo khu vực: " + e.getMessage());
            e.printStackTrace();
        }
        return staffId;
    }

    /**
     * Tạo mới nhiệm vụ và tự động gán cho nhân viên rảnh nhất cùng khu vực.
     */
   public boolean createAutoAssignment(int warehouseId, Integer unitId, int assignedBy, int assignmentType, String description, int dueDays) {
        
        int assignedTo = getOptimalStaffId(warehouseId);
        
        if (assignedTo == -1) {
            return false; 
        }

        // Đã thêm unit_id vào câu lệnh INSERT
        String sql = "INSERT INTO Staff_assignment " +
                     "(assigned_date, assigned_to, warehouse_id, unit_id, assigned_by, assignment_type, description, assigned_at, due_date, status, is_overdue) " +
                     "VALUES (CURDATE(), ?, ?, ?, ?, ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? DAY), 1, 0)";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, assignedTo);
            ps.setInt(2, warehouseId);
            
            // Xử lý unitId (Nếu có chọn thì setInt, nếu không chọn thì setNull)
            if (unitId != null) {
                ps.setInt(3, unitId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            
            ps.setInt(4, assignedBy);
            ps.setInt(5, assignmentType);
            ps.setString(6, description);
            ps.setInt(7, dueDays);
            
            int rowsAffected = ps.executeUpdate();
            ps.close();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Lỗi tạo Assignment vào DB: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
   public List<Warehouse> getActiveWarehouses() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT warehouse_id, name, address FROM Warehouse WHERE status = 1";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                list.add(w);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
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
   
}
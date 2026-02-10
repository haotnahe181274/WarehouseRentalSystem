package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.UserView;

public class IncidentReportDAO extends DBContext {

    // Lấy ID và Tên kho mà nhân viên đang làm việc (từ bảng Staff_assignment)
    public Object[] getAssignedWarehouse(int staffId) {
        String sql = """
            SELECT w.warehouse_id, w.name 
            FROM Staff_assignment sa
            JOIN Warehouse w ON sa.warehouse_id = w.warehouse_id
            WHERE sa.assigned_to = ? AND sa.status = 1 
            LIMIT 1
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Object[]{rs.getInt("warehouse_id"), rs.getString("name")};
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // Insert báo cáo vào Database
    public boolean insert(String type, String description, int warehouseId, int staffId) {
        String sql = """
            INSERT INTO Incident_report 
            (type, description, report_date, status, warehouse_id, internal_user_id) 
            VALUES (?, ?, NOW(), 1, ?, ?)
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setString(2, description);
            ps.setInt(3, warehouseId);
            ps.setInt(4, staffId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
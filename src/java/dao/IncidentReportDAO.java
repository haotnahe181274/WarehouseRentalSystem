package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.IncidentReport;


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
    
    public List<IncidentReport> getAllIncidentReports() {
        List<IncidentReport> list = new ArrayList<>();

        String sql = """
            SELECT 
                ir.report_id,
                ir.type,
                ir.description,
                ir.report_date,
                ir.status,
                w.name AS warehouse_name,
                iu.full_name AS staff_name
            FROM Incident_report ir
            JOIN Warehouse w 
                ON ir.warehouse_id = w.warehouse_id
            JOIN Internal_user iu 
                ON ir.internal_user_id = iu.internal_user_id
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                IncidentReport dto = new IncidentReport();
                dto.setReportId(rs.getInt("report_id"));
                dto.setType(rs.getString("type"));
                dto.setDescription(rs.getString("description"));
                dto.setReportDate(rs.getTimestamp("report_date"));
                dto.setStatus(rs.getInt("status"));
                dto.setWarehouseName(rs.getString("warehouse_name"));
                dto.setStaffName(rs.getString("staff_name"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }return list;
    }
}
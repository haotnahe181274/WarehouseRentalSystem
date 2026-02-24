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
            WHERE sa.assigned_to = ? 
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
    
     public List<IncidentReport> getAll() {
        List<IncidentReport> list = new ArrayList<>();
        String sql = """
            SELECT ir.report_id, ir.type, ir.description, ir.report_date, ir.status,
                   w.name AS warehouse_name,
                   iu.full_name AS staff_name
            FROM Incident_report ir
            JOIN Warehouse w ON ir.warehouse_id = w.warehouse_id
            JOIN Internal_user iu ON ir.internal_user_id = iu.internal_user_id
            ORDER BY ir.report_date DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                IncidentReport r = new IncidentReport();
                r.setReportId(rs.getInt("report_id"));
                r.setType(rs.getString("type"));
                r.setDescription(rs.getString("description"));
                r.setReportDate(rs.getTimestamp("report_date"));
                r.setStatus(rs.getInt("status"));
                r.setWarehouseName(rs.getString("warehouse_name"));
                r.setStaffName(rs.getString("staff_name"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Staff: chỉ xem report của mình
    public List<IncidentReport> getByStaff(int staffId) {
        List<IncidentReport> list = new ArrayList<>();
        String sql = """
            SELECT ir.report_id, ir.type, ir.description, ir.report_date, ir.status,
                   w.name AS warehouse_name,
                   iu.full_name AS staff_name
            FROM Incident_report ir
            JOIN Warehouse w ON ir.warehouse_id = w.warehouse_id
            JOIN Internal_user iu ON ir.internal_user_id = iu.internal_user_id
            WHERE ir.internal_user_id = ?
            ORDER BY ir.report_date DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                IncidentReport r = new IncidentReport();
                r.setReportId(rs.getInt("report_id"));
                r.setType(rs.getString("type"));
                r.setDescription(rs.getString("description"));
                r.setReportDate(rs.getTimestamp("report_date"));
                r.setStatus(rs.getInt("status"));
                r.setWarehouseName(rs.getString("warehouse_name"));
                r.setStaffName(rs.getString("staff_name"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
   public IncidentReport getById(int reportId) {
    // SQL cần SELECT cả warehouse_id và internal_user_id
        String sql = "SELECT ir.*, w.name AS warehouse_name, iu.full_name AS staff_name " +
                     "FROM Incident_report ir " +
                     "JOIN Warehouse w ON ir.warehouse_id = w.warehouse_id " +
                     "JOIN Internal_user iu ON ir.internal_user_id = iu.internal_user_id " +
                     "WHERE ir.report_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                IncidentReport r = new IncidentReport();
                r.setReportId(rs.getInt("report_id"));
                r.setType(rs.getString("type"));
                r.setDescription(rs.getString("description"));
                r.setReportDate(rs.getTimestamp("report_date"));
                r.setStatus(rs.getInt("status"));

                // QUAN TRỌNG: Gán ID để không bị hiện số 0
                r.setWarehouseId(rs.getInt("warehouse_id")); 
                r.setInternalUserId(rs.getInt("internal_user_id"));

                // Gán tên để hiển thị chữ thay vì số
                r.setWarehouseName(rs.getString("warehouse_name"));
                r.setStaffName(rs.getString("staff_name"));

                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean updateStatus(int reportId, int newStatus) {
        String sql = "UPDATE Incident_report SET status = ? WHERE report_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, newStatus);
            ps.setInt(2, reportId);
            return ps.executeUpdate() > 0; // Trả về true nếu update thành công
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
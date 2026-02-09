package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.IncidentReport;

public class IncidentReportDAO extends DBContext {

    // ========================
    // CREATE – STAFF
    // ========================
    public void insertReport(String type, String description,
                             int warehouseId, int internalUserId) {

        String sql = """
            INSERT INTO Incident_report
            (type, description, report_date, status, warehouse_id, internal_user_id)
            VALUES (?, ?, NOW(), 0, ?, ?)
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, type);
            ps.setString(2, description);
            ps.setInt(3, warehouseId);
            ps.setInt(4, internalUserId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ========================
    // READ – STAFF (own reports)
    // ========================
    public List<IncidentReport> getByStaff(int internalUserId) {
        List<IncidentReport> list = new ArrayList<>();

        String sql = """
            SELECT * FROM Incident_report
            WHERE internal_user_id = ?
            ORDER BY report_date DESC
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, internalUserId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ========================
    // READ – ADMIN / MANAGER
    // ========================
    public List<IncidentReport> getAll() {
        List<IncidentReport> list = new ArrayList<>();

        String sql = "SELECT * FROM Incident_report ORDER BY report_date DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ========================
    // READ – BY ID
    // ========================
    public IncidentReport getById(int reportId) {
        String sql = "SELECT * FROM Incident_report WHERE report_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, reportId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ========================
    // UPDATE STATUS – ADMIN / MANAGER
    // ========================
    public void updateStatus(int reportId, int status) {
        String sql = "UPDATE Incident_report SET status = ? WHERE report_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, reportId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ========================
    // DELETE – STAFF (own)
    // ========================
    public void delete(int reportId, int internalUserId) {
        String sql = """
            DELETE FROM Incident_report
            WHERE report_id = ? AND internal_user_id = ?
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, reportId);
            ps.setInt(2, internalUserId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ========================
    // MAP RESULTSET → MODEL
    // ========================
    private IncidentReport map(ResultSet rs) throws Exception {
        IncidentReport r = new IncidentReport();
        r.setReportId(rs.getInt("report_id"));
        r.setType(rs.getString("type"));
        r.setDescription(rs.getString("description"));
        r.setReportDate(rs.getTimestamp("report_date"));
        r.setStatus(rs.getInt("status"));
        r.setWarehouseId(rs.getInt("warehouse_id"));
        r.setInternalUserId(rs.getInt("internal_user_id"));
        return r;
    }
}

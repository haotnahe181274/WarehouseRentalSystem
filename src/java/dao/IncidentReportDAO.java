package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class IncidentReportDAO extends DBContext {

    public boolean insert(String type, String description, int internalUserId) {

    String getWarehouseSql = """
        SELECT warehouse_id
        FROM internal_user
        WHERE internal_user_id = ?
    """;

    String insertSql = """
        INSERT INTO incident_report
        (type, description, status, internal_user_id, warehouse_id, report_date)
        VALUES (?, ?, 1, ?, ?, NOW())
    """;

    try {
        PreparedStatement ps1 = connection.prepareStatement(getWarehouseSql);
        ps1.setInt(1, internalUserId);
        ResultSet rs = ps1.executeQuery();

        if (!rs.next()) {
            return false;
        }

        int warehouseId = rs.getInt("warehouse_id");

        PreparedStatement ps2 = connection.prepareStatement(insertSql);
        ps2.setString(1, type);
        ps2.setString(2, description);
        ps2.setInt(3, internalUserId);
        ps2.setInt(4, warehouseId);

        return ps2.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace(); // 👈 RẤT QUAN TRỌNG
    }
    return false;
}

    public String getWarehouseNameByUser(int internalUserId) {

        String sql = """
            SELECT w.name
            FROM internal_user iu
            JOIN warehouse w ON iu.warehouse_id = w.warehouse_id
            WHERE iu.internal_user_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, internalUserId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
}

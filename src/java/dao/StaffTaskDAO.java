package dao;

import java.sql.*;
import java.util.*;
import model.CheckInTask;

public class StaffTaskDAO extends DBContext {

    // =============================
    // CHECK-IN COLUMN
    // status = 0 : Waiting Check-In
    // status = 1 : Checked-In
    // status = 2 : Completed (Checked-Out)
    // =============================

    public List<CheckInTask> getCheckInList() {
        return getTasksByStatuses(0, 1, 2);
    }

    public List<CheckInTask> getCheckOutList() {
        return getTasksByStatuses(1, 2);
    }

    // =============================
    // CORE QUERY (FIXED)
    // =============================
    private List<CheckInTask> getTasksByStatuses(int... statuses) {
        List<CheckInTask> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT
                csu.id            AS csu_id,
                c.contract_id     AS contract_id,
                r.full_name       AS renter_name,
                su.unit_code      AS unit_code,
                csu.start_date,
                csu.end_date,
                csu.status
            FROM Contract_Storage_unit csu
            JOIN Contract c ON c.contract_id = csu.contract_id
            JOIN Renter r ON r.renter_id = c.renter_id
            JOIN Storage_unit su ON su.unit_id = csu.unit_id
            WHERE csu.status IN (
        """);

        for (int i = 0; i < statuses.length; i++) {
            sql.append("?");
            if (i < statuses.length - 1) {
                sql.append(",");
            }
        }
        sql.append(") ORDER BY csu.start_date");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < statuses.length; i++) {
                ps.setInt(i + 1, statuses[i]);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CheckInTask(
                        rs.getInt("csu_id"),          // 🔥 QUAN TRỌNG
                        rs.getInt("contract_id"),
                        rs.getString("renter_name"),
                        rs.getString("unit_code"),
                        rs.getTimestamp("start_date"),
                        rs.getTimestamp("end_date"),
                        rs.getInt("status")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================
    // CHECK-IN (1 UNIT ONLY)
    // =============================
    public boolean checkIn(int csuId) {
        String sql = """
            UPDATE Contract_Storage_unit
            SET status = 1
            WHERE id = ?
              AND status = 0
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, csuId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =============================
    // CHECK-OUT (1 UNIT ONLY)
    // =============================
    public boolean checkOut(int csuId) {
        String sql = """
            UPDATE Contract_Storage_unit
            SET status = 2
            WHERE id = ?
              AND status = 1
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, csuId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =============================
    // COUNT COMPLETED (UNCHANGED)
    // =============================
    public int countCompleted() {
        String sql = "SELECT COUNT(*) FROM Contract_Storage_unit WHERE status = 2";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}

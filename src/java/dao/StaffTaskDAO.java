package dao;

import java.sql.*;
import java.util.*;
import model.CheckInTask;

public class StaffTaskDAO extends DBContext {

    // =========================
    // CHECK IN TASKS
    // =========================
    public List<CheckInTask> getCheckInTasks() {

    List<CheckInTask> list = new ArrayList<>();

    String sql = """
        SELECT 
            sa.assignment_id,
            sa.status,
            r.full_name,
            csu.start_date,
            csu.end_date,
            su.unit_code
        FROM Staff_assignment sa
        JOIN Storage_unit su 
            ON su.warehouse_id = sa.warehouse_id
        JOIN Contract_Storage_unit csu 
            ON csu.unit_id = su.unit_id
        JOIN Contract c 
            ON c.contract_id = csu.contract_id
        JOIN Renter r 
            ON r.renter_id = c.renter_id
        WHERE sa.status IN (1,2)
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            list.add(new CheckInTask(
                rs.getInt("assignment_id"),
                rs.getString("full_name"),
                rs.getTimestamp("start_date"),
                rs.getTimestamp("end_date"),
                rs.getString("unit_code"),
                rs.getInt("status")
            ));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}



    // =========================
    // CHECK OUT TASKS
    // =========================
    public List<CheckInTask> getCheckOutTasks() {

    List<CheckInTask> list = new ArrayList<>();

    String sql = """
        SELECT 
                    sa.assignment_id,
                    sa.status,
                    r.full_name,
                    csu.start_date,
                    csu.end_date,
                    su.unit_code
                FROM Staff_assignment sa
                JOIN Storage_unit su 
                    ON su.warehouse_id = sa.warehouse_id
                JOIN Contract_Storage_unit csu 
                    ON csu.unit_id = su.unit_id
                JOIN Contract c 
                    ON c.contract_id = csu.contract_id
                JOIN Renter r 
                    ON r.renter_id = c.renter_id
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            list.add(new CheckInTask(
                rs.getInt("assignment_id"),
                rs.getString("full_name"),
                rs.getTimestamp("start_date"),
                rs.getTimestamp("end_date"),
                rs.getString("unit_code"),
                rs.getInt("status")
            ));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}


    // =========================
    // COMPLETED COUNT
    // =========================
    public int countCompleted() {

        String sql = """
            SELECT COUNT(*) 
            FROM Staff_assignment
            WHERE status = 2
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}

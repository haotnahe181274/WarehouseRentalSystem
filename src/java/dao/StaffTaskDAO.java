package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CheckInTask;

public class StaffTaskDAO extends DBContext {

    public List<CheckInTask> getExpectedCheckIns() {
        List<CheckInTask> list = new ArrayList<>();

        String sql = """
            SELECT 
                r.full_name AS renter_name,
                csu.start_date AS rent_start_date,
                csu.end_date AS rent_end_date,
                su.unit_code AS unit_code
            FROM Contract c
            JOIN Renter r ON c.renter_id = r.renter_id
            JOIN Contract_Storage_unit csu ON c.contract_id = csu.contract_id
            JOIN Storage_unit su ON csu.unit_id = su.unit_id
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new CheckInTask(
                        rs.getString("renter_name"),
                        rs.getTimestamp("rent_start_date"),
                        rs.getTimestamp("rent_end_date"),
                        rs.getString("unit_code")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}

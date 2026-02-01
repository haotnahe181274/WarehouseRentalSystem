package dao;

import java.sql.*;
import java.util.*;
import model.UnitContractView;

public class StaffCheckDAO extends DBContext {

    // DETAIL
    public List<UnitContractView> getUnitContractDetailNoNewTable(int csuId) {
    List<UnitContractView> list = new ArrayList<>();

    String sql = """
        SELECT
            csu.id AS csu_id,
            c.contract_id,
            csu.status,
            r.full_name,
            su.unit_code,
            csu.start_date,
            csu.end_date,
            sai.item_name,
            i.description
        FROM Contract_Storage_unit csu
        JOIN Contract c ON c.contract_id = csu.contract_id
        JOIN Renter r ON r.renter_id = c.renter_id
        JOIN Storage_unit su ON su.unit_id = csu.unit_id
        LEFT JOIN Staff_assignment sa ON sa.warehouse_id = c.warehouse_id
        LEFT JOIN Staff_assignment_item sai ON sai.assignment_id = sa.assignment_id
        LEFT JOIN Item i ON i.item_id = sai.item_id
        WHERE csu.id = ?
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, csuId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            UnitContractView u = new UnitContractView();
            u.setCsuId(rs.getInt("csu_id"));
            u.setContractId(rs.getInt("contract_id"));
            u.setStatus(rs.getInt("status"));
            u.setRenterName(rs.getString("full_name"));
            u.setUnitCode(rs.getString("unit_code"));
            u.setCheckInDate(rs.getTimestamp("start_date"));
            u.setCheckOutDate(rs.getTimestamp("end_date"));
            u.setItemName(rs.getString("item_name"));
            u.setDescription(rs.getString("description"));
            list.add(u);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}


    public void checkIn(int contractId) {
        String sql = """
            UPDATE Contract_Storage_unit
            SET status = 1
            WHERE id = ? AND status = 0
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void checkOut(int contractId) {
        String sql = """
            UPDATE Contract_Storage_unit
            SET status = 2
            WHERE id = ? AND status = 1
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

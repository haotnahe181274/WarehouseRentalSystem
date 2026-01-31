package dao;

import java.sql.*;
import java.util.*;
import model.UnitContractView;

public class StaffCheckDAO extends DBContext {

    public List<UnitContractView> getCheckByAssignment(int assignmentId) {

        List<UnitContractView> list = new ArrayList<>();

        String sql = """
        SELECT 
            r.full_name,
            su.unit_code,
            csu.start_date,
            csu.end_date,
            i.item_name,
            i.description
        FROM Staff_assignment sa
        JOIN Warehouse w ON sa.warehouse_id = w.warehouse_id
        JOIN Contract c ON c.warehouse_id = w.warehouse_id
        JOIN Renter r ON c.renter_id = r.renter_id
        JOIN Contract_Storage_unit csu ON c.contract_id = csu.contract_id
        JOIN Storage_unit su ON csu.unit_id = su.unit_id
        LEFT JOIN Inventory_log il ON su.unit_id = il.unit_id
        LEFT JOIN Item i ON il.item_id = i.item_id
        WHERE sa.assignment_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UnitContractView u = new UnitContractView();

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
    
    public void completeAssignment(int id) {
        String sql = "UPDATE Staff_assignment SET status = 2 WHERE staff_assignment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
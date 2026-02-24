/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author ad
 */
public class ItemDAO extends DBContext {

    public int insertItem(String name, String description, int renterId) {

        String sql = "INSERT INTO Item(item_name, description, renter_id) VALUES (?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, name);
            ps.setString(2, description);
            ps.setInt(3, renterId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // item_id vừa insert
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Lấy các item đã khai trong đúng rent request tạo ra contract chứa unit này.
     * Luồng: Contract_Storage_unit (unit_id) → Contract (request_id) → rent_request_item → item.
     */
    public java.util.List<model.Item> getItemsFromRentRequestByUnit(int renterId, int unitId) {
        java.util.List<model.Item> list = new java.util.ArrayList<>();

        String sql = """
            SELECT DISTINCT i.item_id, i.item_name, i.description, i.renter_id
            FROM Contract_Storage_unit csu
            JOIN Contract c ON c.contract_id = csu.contract_id
            JOIN Payment p ON p.contract_id = c.contract_id AND p.status = 1
            JOIN rent_request_item rri ON rri.request_id = c.request_id
            JOIN item i ON i.item_id = rri.item_id
            WHERE csu.unit_id = ?
              AND c.renter_id = ?
              AND c.status = 1
              AND csu.start_date <= NOW() AND csu.end_date >= NOW()
              AND c.start_date <= NOW() AND c.end_date >= NOW()
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, unitId);
            ps.setInt(2, renterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                model.Item i = new model.Item();
                i.setItemId(rs.getInt("item_id"));
                i.setItemName(rs.getString("item_name"));
                i.setDescription(rs.getString("description"));
                i.setRenterId(rs.getInt("renter_id"));
                list.add(i);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}

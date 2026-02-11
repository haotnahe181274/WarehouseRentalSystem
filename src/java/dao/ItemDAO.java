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

        String sql = "INSERT INTO Item(item_name, description, renter_id, unit_id) VALUES (?, ?, ?, NULL)";

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

}

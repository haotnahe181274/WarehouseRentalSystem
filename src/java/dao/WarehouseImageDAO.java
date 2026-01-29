/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import model.WarehouseImage;

public class WarehouseImageDAO extends DBContext {

    // Lấy ảnh chính (is_primary = 1) của một kho bãi
    public String getPrimaryImage(int warehouseId) {
        String sql = "SELECT image_url FROM warehouse_image WHERE warehouse_id = ? AND is_primary = 1 LIMIT 1";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, warehouseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("image_url");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "default-warehouse.jpg"; // Trả về ảnh mặc định nếu không tìm thấy
    }
}
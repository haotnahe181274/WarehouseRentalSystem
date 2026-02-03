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
  public void insertImage(WarehouseImage img) {
        // Lưu ý: Kiểm tra kỹ tên cột trong Database của Hiếu
        // Ví dụ: image_path, image_url, link... phải khớp đúng từng chữ
        String sql = "INSERT INTO Warehouse_Image (warehouse_id, image_url, image_type, is_primary, status) VALUES (?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            
            // 1. Warehouse ID (Lấy từ object cha)
            st.setInt(1, img.getWarehouse().getWarehouseId());
            
            // 2. Tên file ảnh
            st.setString(2, img.getImageUrl());
            
            // 3. Loại ảnh (jpg/png)
            st.setString(3, img.getImageType());
            
            // 4. Có phải ảnh chính không? (boolean -> int)
            st.setBoolean(4, img.isPrimary()); 
            
            // 5. Status
            st.setInt(5, img.getStatus());

            st.executeUpdate();
            
            System.out.println("DEBUG DAO: Đã Insert ảnh " + img.getImageUrl() + " vào DB thành công!");
            
        } catch (SQLException e) {
            System.out.println("LỖI SQL INSERT ẢNH: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Hàm xóa ảnh cũ (Dùng khi Edit)
    public void deleteImagesByWarehouseId(int warehouseId) {
        String sql = "DELETE FROM Warehouse_Image WHERE warehouse_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, warehouseId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

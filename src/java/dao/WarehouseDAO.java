/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.Warehouse;
import model.WarehouseType; // Phải import Model này
import dao.WarehouseTypeDAO; // Import DAO để lấy đối tượng Type

public class WarehouseDAO extends DBContext {

    public List<Warehouse> getFilteredWarehouses(String location, Integer typeId, Double minPrice, Double maxPrice, int offset, int limit) {
        List<Warehouse> list = new ArrayList<>();
        // Khởi tạo DAO hỗ trợ
        WarehouseTypeDAO typeDAO = new WarehouseTypeDAO();
        
        String sql = "SELECT * FROM Warehouse WHERE status = 1 ";
        // ... (Phần nối chuỗi SQL lọc giữ nguyên) ...

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            // ... (Set tham số ps) ...

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setDescription(rs.getString("description"));
                // ĐÂY LÀ DÒNG CODE "CHỒNG" NHƯ BẠN NÓI:
                // Lấy ID từ RS của Warehouse, sau đó dùng DAO của Type để lấy nguyên Object Type
                w.setWarehouseType(typeDAO.getTypeById(rs.getInt("warehouse_type_id")));
                
                list.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    // Đếm tổng số lượng kết quả để tính totalPages
    public int getTotalRecords(String location, Integer typeId) {
        String sql = "SELECT COUNT(*) FROM Warehouse WHERE status = 1 ";
        if (location != null && !location.isEmpty()) sql += "AND address LIKE ? ";
        if (typeId != null && typeId > 0) sql += "AND warehouse_type_id = ? ";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int paramIdx = 1;
            if (location != null && !location.isEmpty()) ps.setString(paramIdx++, "%" + location + "%");
            if (typeId != null && typeId > 0) ps.setInt(paramIdx++, typeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
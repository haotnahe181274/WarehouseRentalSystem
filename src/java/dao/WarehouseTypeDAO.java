/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.WarehouseType;

public class WarehouseTypeDAO extends DBContext {
    
    public List<WarehouseType> getAllTypes() {
        List<WarehouseType> list = new ArrayList<>();
        String sql = "SELECT * FROM warehouse_type";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                WarehouseType t = new WarehouseType();
                t.setWarehouseTypeId(rs.getInt("warehouse_type_id"));
                t.setTypeName(rs.getString("type_name"));
                t.setDescription(rs.getString("description"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public WarehouseType getTypeById(int id) {
    String sql = "SELECT * FROM warehouse_type WHERE warehouse_type_id = ?";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            WarehouseType t = new WarehouseType();
            t.setWarehouseTypeId(rs.getInt("warehouse_type_id"));
            t.setTypeName(rs.getString("type_name"));
            t.setDescription(rs.getString("description"));
            return t;
        }
    } catch (SQLException e) { 
        e.printStackTrace(); 
    }
    return null;
}
    public static void main(String[] args) {
    WarehouseTypeDAO dao = new WarehouseTypeDAO();

    System.out.println("=== TEST GET ALL TYPES ===");
    List<WarehouseType> list = dao.getAllTypes();
    for (WarehouseType t : list) {
        System.out.println(
            t.getWarehouseTypeId() + " | " +
            t.getTypeName() + " | " +
            t.getDescription()
        );
    }

    System.out.println("\n=== TEST GET TYPE BY ID ===");
    WarehouseType type = dao.getTypeById(1);
    if (type != null) {
        System.out.println(type.getTypeName());
    } else {
        System.out.println("KHÔNG TÌM THẤY ID = 1");
    }
}
}
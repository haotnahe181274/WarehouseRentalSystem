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
        String sql = "SELECT * FROM Warehouse_Type";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                WarehouseType t = new WarehouseType();
                t.setWarehouseTypeId(rs.getInt("warehouse_type_id"));
                t.setTypeName(rs.getString("type_name"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public WarehouseType getTypeById(int id) {
    String sql = "SELECT * FROM Warehouse_Type WHERE warehouse_type_id = ?";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            WarehouseType t = new WarehouseType();
            t.setWarehouseTypeId(rs.getInt("warehouse_type_id"));
            t.setTypeName(rs.getString("type_name"));
            return t;
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}
}
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

    public List<Warehouse> getAllWarehouses(String location, Integer typeId, Double minPrice, Double maxPrice, int offset, int limit) {
        List<Warehouse> list = new ArrayList<>();
        // Khởi tạo DAO hỗ trợ
        WarehouseTypeDAO typeDAO = new WarehouseTypeDAO();

        String sql = "SELECT * FROM warehouse WHERE status = 1 ";
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
                w.setStatus(rs.getInt("status"));
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

    public List<String> getAllLocations() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT address FROM Warehouse WHERE status = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("address"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Warehouse> getFilteredWarehouses(String keyword, String location,
        Integer typeId,
        Double minPrice, Double maxPrice,
        Double minArea, Double maxArea,
        int offset, int limit) {

        WarehouseTypeDAO typeDAO = new WarehouseTypeDAO();
        List<Warehouse> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT w.* "
                + "FROM Warehouse w "
                + "LEFT JOIN Storage_unit s ON w.warehouse_id = s.warehouse_id "
                + "WHERE w.status = 1 "
        );
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND w.name LIKE ? ");
        }

        if (location != null && !location.isEmpty()) {
            sql.append("AND w.address LIKE ? ");
        }
        if (typeId != null) {
    sql.append("AND w.warehouse_type_id = ? ");
}

        if (minPrice != null) {
            sql.append("AND s.price_per_unit >= ? ");
        }

        if (maxPrice != null) {
            sql.append("AND s.price_per_unit <= ? ");
        }

        // ✅ thêm area
        if (minArea != null) {
            sql.append("AND s.area >= ? ");
        }

        if (maxArea != null) {
            sql.append("AND s.area <= ? ");
        }

        sql.append("ORDER BY w.warehouse_id DESC LIMIT ? OFFSET ?");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword.trim() + "%");
            }

            if (location != null && !location.isEmpty()) {
                ps.setString(index++, "%" + location + "%");
            }
            
            if (typeId != null) {
    ps.setInt(index++, typeId);
}

            if (minPrice != null) {
                ps.setDouble(index++, minPrice);
            }

            if (maxPrice != null) {
                ps.setDouble(index++, maxPrice);
            }

            // ✅ set area
            if (minArea != null) {
                ps.setDouble(index++, minArea);
            }

            if (maxArea != null) {
                ps.setDouble(index++, maxArea);
            }

            ps.setInt(index++, limit);
            ps.setInt(index, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setDescription(rs.getString("description"));
                w.setStatus(rs.getInt("status"));

                w.setWarehouseType(
                        typeDAO.getTypeById(rs.getInt("warehouse_type_id"))
                );

                list.add(w);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Đếm tổng số lượng kết quả để tính totalPages
    public int getTotalRecords(String keyword, String location,
        Integer typeId,
        Double minPrice, Double maxPrice,
        Double minArea, Double maxArea){

        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT w.warehouse_id) "
                + "FROM Warehouse w "
                + "JOIN Storage_unit s ON w.warehouse_id = s.warehouse_id "
                + "WHERE w.status = 1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND w.name LIKE ? ");
        }

        if (location != null && !location.isEmpty()) {
            sql.append("AND w.address LIKE ? ");
        }
        
        if (typeId != null) {
    sql.append("AND w.warehouse_type_id = ? ");
}

        if (minPrice != null) {
            sql.append("AND s.price_per_unit >= ? ");
        }

        if (maxPrice != null) {
            sql.append("AND s.price_per_unit <= ? ");
        }

        // ✅ thêm area
        if (minArea != null) {
            sql.append("AND s.area >= ? ");
        }

        if (maxArea != null) {
            sql.append("AND s.area <= ? ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            int idx = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            if (location != null && !location.isEmpty()) {
                ps.setString(idx++, "%" + location + "%");
            }
            
            if (typeId != null) {
    ps.setInt(idx++, typeId);
}

            if (minPrice != null) {
                ps.setDouble(idx++, minPrice);
            }

            if (maxPrice != null) {
                ps.setDouble(idx++, maxPrice);
            }

            if (minArea != null) {
                ps.setDouble(idx++, minArea);
            }

            if (maxArea != null) {
                ps.setDouble(idx++, maxArea);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

//    public static void main(String[] args) {
//
//        WarehouseDAO dao = new WarehouseDAO();
//
//        // ====== giả lập dữ liệu filter từ user ======
//        String location = "";        // hoặc "Hà Nội"
//        Integer typeId = null;       // hoặc 1, 2, 3...
//        Double minPrice = null;      // hoặc 100.0
//        Double maxPrice = null;      // hoặc 500.0
//        Double minArea = null;       // hoặc 50.0
//        Double maxArea = null;       // hoặc 200.0
//
//        int page = 1;
//        int pageSize = 6;
//        int offset = (page - 1) * pageSize;
//
//        // ====== TEST GET LIST ======
//        System.out.println("===== TEST getFilteredWarehouses =====");
//
//        List<Warehouse> list = dao.getFilteredWarehouses(
//                location,
//                minPrice, maxPrice,
//                minArea, maxArea,
//                offset, pageSize
//        );
//
//        System.out.println("Số warehouse lấy được: " + list.size());
//
//        for (Warehouse w : list) {
//            System.out.println(
//                    w.getWarehouseId() + " | "
//                    + w.getName() + " | "
//                    + w.getAddress()
//            );
//        }
//
//        // ====== TEST COUNT ======
//        System.out.println("\n===== TEST getTotalRecords =====");
//
//        int total = dao.getTotalRecords(
//                location,
//                minPrice, maxPrice,
//                minArea, maxArea
//        );
//
//        System.out.println("Tổng số warehouse thỏa điều kiện: " + total);
//
//        int totalPages = (int) Math.ceil((double) total / pageSize);
//        System.out.println("Tổng số trang: " + totalPages);
//    }

}

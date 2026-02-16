/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.sql.Timestamp;

import java.util.List;
import java.util.ArrayList;

import model.Warehouse;
import model.WarehouseType;
import dao.WarehouseTypeDAO;

public class WarehouseDAO extends DBContext {

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

    public List<Warehouse> getFilteredWarehouses(
            String keyword, String location,
            Integer typeId,
            Double minPrice, Double maxPrice,
            Double minArea, Double maxArea,
            Date rentStart, Date rentEnd,
            String sort,
            int offset, int limit
    ) {

        WarehouseTypeDAO typeDAO = new WarehouseTypeDAO();
        List<Warehouse> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT w.*, "
                + "MIN(s.price_per_unit) AS min_price, "
                + "MIN(s.area) AS min_area "
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
        if (rentStart != null && rentEnd != null) {
            sql.append(
                    "AND NOT EXISTS ( "
                    + "   SELECT 1 FROM Contract_Storage_unit csu "
                    + "   JOIN Contract c ON csu.contract_id = c.contract_id "
                    + "   WHERE csu.unit_id = s.unit_id "
                    + "   AND c.status IN (1,2) "
                    + "   AND c.start_date <= ? "
                    + "   AND c.end_date >= ? "
                    + ") "
            );
        }

        sql.append("GROUP BY w.warehouse_id ");

        if ("price_asc".equals(sort)) {
            sql.append("ORDER BY min_price ASC ");
        } else if ("price_desc".equals(sort)) {
            sql.append("ORDER BY min_price DESC ");
        } else if ("area_asc".equals(sort)) {
            sql.append("ORDER BY min_area ASC ");
        } else if ("area_desc".equals(sort)) {
            sql.append("ORDER BY min_area DESC ");
        } else if ("name_asc".equals(sort)) {
            sql.append("ORDER BY w.name ASC ");
        } else if ("name_desc".equals(sort)) {
            sql.append("ORDER BY w.name DESC ");
        } else {
            sql.append("ORDER BY w.warehouse_id DESC ");
        }

        sql.append("LIMIT ? OFFSET ?");

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

            if (minArea != null) {
                ps.setDouble(index++, minArea);
            }

            if (maxArea != null) {
                ps.setDouble(index++, maxArea);
            }

            if (rentStart != null && rentEnd != null) {
                ps.setDate(index++, new java.sql.Date(rentEnd.getTime()));
                ps.setDate(index++, new java.sql.Date(rentStart.getTime()));
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
                w.setMinPrice(rs.getDouble("min_price"));
                w.setMinArea(rs.getDouble("min_area"));

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
    public int getTotalRecords(
            Date rentStart, Date rentEnd,
            String keyword, String location,
            Integer typeId,
            Double minPrice, Double maxPrice,
            Double minArea, Double maxArea
    ) {

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

        if (minArea != null) {
            sql.append("AND s.area >= ? ");
        }

        if (maxArea != null) {
            sql.append("AND s.area <= ? ");
        }

        // ✅ PHẢI CÓ date filter giống hệt hàm list
        if (rentStart != null && rentEnd != null) {
            sql.append(
                    "AND NOT EXISTS ( "
                    + "   SELECT 1 FROM Contract_Storage_unit csu "
                    + "   JOIN Contract c ON csu.contract_id = c.contract_id "
                    + "   WHERE csu.unit_id = s.unit_id "
                    + "   AND c.status IN (1,2) "
                    + "   AND c.start_date <= ? "
                    + "   AND c.end_date >= ? "
                    + ") "
            );
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

            if (rentStart != null && rentEnd != null) {
                ps.setDate(idx++, new java.sql.Date(rentEnd.getTime()));
                ps.setDate(idx++, new java.sql.Date(rentStart.getTime()));
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

    public List<Warehouse> getAll() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT * FROM warehouse";

        try {
            System.out.println("=== DAO TEST ===");
            System.out.println("Connection = " + connection);

            if (connection == null) {
                System.out.println("❌ CONNECTION NULL");
                return list;
            }

            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouseId"));
                w.setName(rs.getString("name"));
                list.add(w);
            }

            System.out.println("✅ DAO size = " + list.size());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insert(Warehouse w) {
        String sql = "INSERT INTO warehouse (name, address, description, status) VALUES (?, ?, ?, ?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, w.getName());
            st.setString(2, w.getAddress());
            st.setString(3, w.getDescription());
            st.setInt(4, w.getStatus());
            st.executeUpdate();
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM warehouse WHERE warehouseId = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Double> getAvailableAreasByWarehouse(
            int warehouseId,
            Date rentStart,
            Date rentEnd
    ) {

        List<Double> areaList = new ArrayList<>();

        String sql
                = "SELECT DISTINCT s.area "
                + "FROM Storage_unit s "
                + "JOIN Warehouse w ON w.warehouse_id = s.warehouse_id "
                + "WHERE w.warehouse_id = ? "
                + "AND w.status = 1 "
                + "AND s.status = 1 "
                + "AND NOT EXISTS ( "
                + "   SELECT 1 "
                + "   FROM Contract_Storage_unit csu "
                + "   JOIN Contract c ON csu.contract_id = c.contract_id "
                + "   WHERE csu.unit_id = s.unit_id "
                + "   AND c.status =1 "
                + "   AND c.start_date <= ? "
                + "   AND c.end_date >= ? "
                + ") "
                + "ORDER BY s.area ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, warehouseId);
            ps.setDate(2, new java.sql.Date(rentEnd.getTime()));
            ps.setDate(3, new java.sql.Date(rentStart.getTime()));

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                areaList.add(rs.getDouble("area"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return areaList;
    }

    public double getPriceByArea(int warehouseId, double area) {

        String sql = "SELECT price_per_unit "
                + "FROM Storage_unit "
                + "WHERE warehouse_id = ? "
                + "AND area = ? "
                + "AND status = 1 "
                + "LIMIT 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, warehouseId);
            ps.setDouble(2, area);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("price_per_unit");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public Warehouse findById(int id) {

        String sql = "SELECT w.*, wt.warehouse_type_id, wt.type_name, wt.description AS type_description "
                + "FROM Warehouse w "
                + "JOIN Warehouse_type wt ON w.warehouse_type_id = wt.warehouse_type_id "
                + "WHERE w.warehouse_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                // Tạo WarehouseType trước
                WarehouseType type = new WarehouseType(
                        rs.getInt("warehouse_type_id"),
                        rs.getString("type_name"),
                        rs.getString("type_description")
                );

                // Tạo Warehouse
                Warehouse warehouse = new Warehouse();
                warehouse.setWarehouseId(rs.getInt("warehouse_id"));
                warehouse.setName(rs.getString("name"));
                warehouse.setAddress(rs.getString("address"));
                warehouse.setDescription(rs.getString("description"));
                warehouse.setWarehouseType(type);

                return warehouse;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.Warehouse;
import model.WarehouseType; 
import dao.WarehouseTypeDAO; 

public class WarehouseManagementDAO extends DBContext {

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
                "SELECT w.*, "
                + "MIN(s.price_per_unit) AS min_price, "
                + "MIN(s.area) AS min_area "
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

        sql.append("GROUP BY w.warehouse_id ");
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
    public int getTotalRecords(String keyword, String location,
            Integer typeId,
            Double minPrice, Double maxPrice,
            Double minArea, Double maxArea) {

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
    
   public List<Warehouse> getAll() {
        List<Warehouse> list = new ArrayList<>();
        // Câu lệnh SQL Join 2 bảng
       String sql = "SELECT w.warehouse_id, w.name, w.address, w.description, w.status, " +
             "wt.warehouse_type_id, wt.type_name " +
             "FROM Warehouse w " +
             "LEFT JOIN Warehouse_Type wt ON w.warehouse_type_id = wt.warehouse_type_id"; // Sửa JOIN thành LEFT JOIN
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                // 1. Tạo đối tượng WarehouseType trước
                WarehouseType wt = new WarehouseType();
                wt.setWarehouseTypeId(rs.getInt("warehouse_type_id"));
                wt.setTypeName(rs.getString("type_name"));

                // 2. Tạo đối tượng Warehouse
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setDescription(rs.getString("description"));
                w.setStatus(rs.getInt("status"));
                
                // 3. Gắn Type vào Warehouse
                w.setWarehouseType(wt);

                list.add(w);
            }
        } catch (Exception e) {
            System.out.println("Lỗi lấy danh sách kho: " + e.getMessage());
        }
        return list;
    }
    
    // Hàm xóa cần cập nhật tên cột ID
    public void delete(int id) {
        String sql = "DELETE FROM Warehouse WHERE warehouse_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
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

        public int insertReturnId(Warehouse w) {
    String sql = "INSERT INTO Warehouse (name, address, description, status) VALUES (?, ?, ?, ?)";
    int generatedId = 0;
    
    try {
        // Thêm tham số RETURN_GENERATED_KEYS
        PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        st.setString(1, w.getName());
        st.setString(2, w.getAddress());
        st.setString(3, w.getDescription());
        st.setInt(4, w.getStatus());
        
        int affectedRows = st.executeUpdate();
        
        if (affectedRows > 0) {
            // Lấy ID vừa sinh ra
            ResultSet rs = st.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return generatedId; // Trả về ID (hoặc 0 nếu lỗi)
    
}
    // Lấy thông tin chi tiết 1 Warehouse theo ID
    public Warehouse getWarehouseById(int id) {
        String sql = "SELECT * FROM Warehouse WHERE warehouse_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setDescription(rs.getString("description"));
                w.setStatus(rs.getInt("status"));
                // Các thuộc tính khác nếu có (ví dụ warehouse_type_id)
                
                return w;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Không tìm thấy
    }

    public void update(Warehouse w) {
    String sql = "UPDATE Warehouse SET name=?, address=?, description=?, status=? WHERE warehouse_id=?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, w.getName());
        st.setString(2, w.getAddress());
        st.setString(3, w.getDescription());
        st.setInt(4, w.getStatus());
        st.setInt(5, w.getWarehouseId()); // ID để biết sửa kho nào
        
        st.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
}

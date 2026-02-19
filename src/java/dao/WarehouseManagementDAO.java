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
import model.StorageUnit;
import model.WarehouseImage;

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

    // 1. Thêm mới một Ô chứa (Storage Unit / Zone)
    public boolean insertStorageUnit(StorageUnit unit) {
        String sql = "INSERT INTO Storage_unit (unit_code, status, area, price_per_unit, description, warehouse_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, unit.getUnitCode());
            st.setInt(2, unit.getStatus()); // 1: Trống (Available), 2: Đã thuê
            st.setDouble(3, unit.getArea());
            st.setDouble(4, unit.getPrice()); // Lưu ý: Tên getPrice() phải khớp với model của Hiếu
            st.setString(5, unit.getDescription());
            st.setInt(6, unit.getWarehouse().getWarehouseId());
            
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            System.out.println("Lỗi insertStorageUnit: " + e.getMessage());
        }
        return false;
    }

    // 2. Cập nhật Ô chứa
    public boolean updateStorageUnit(StorageUnit unit) {
        String sql = "UPDATE Storage_unit SET unit_code=?, status=?, area=?, price_per_unit=?, description=? " +
                     "WHERE unit_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, unit.getUnitCode());
            st.setInt(2, unit.getStatus());
            st.setDouble(3, unit.getArea());
            st.setDouble(4, unit.getPrice());
            st.setString(5, unit.getDescription());
            st.setInt(6, unit.getUnitId());
            
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateStorageUnit: " + e.getMessage());
        }
        return false;
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
        public Warehouse getWarehouseById(int id) {
        // SQL: Join bảng Type + Subquery tính giá thấp nhất + diện tích nhỏ nhất
        String sql = "SELECT w.*, wt.type_name, " +
                     "(SELECT MIN(price_per_unit) FROM Storage_unit WHERE warehouse_id = w.warehouse_id) AS min_price, " +
                     "(SELECT MIN(area) FROM Storage_unit WHERE warehouse_id = w.warehouse_id) AS min_area " +
                     "FROM Warehouse w " +
                     "JOIN Warehouse_Type wt ON w.warehouse_type_id = wt.warehouse_type_id " +
                     "WHERE w.warehouse_id = ?";
        
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
                
                // Set Min Price & Min Area (Cho hiển thị đẹp)
                w.setMinPrice(rs.getDouble("min_price"));
                w.setMinArea(rs.getDouble("min_area"));

                // Tạo đối tượng WarehouseType và gán vào
                WarehouseType wt = new WarehouseType();
                wt.setWarehouseTypeId(rs.getInt("warehouse_type_id"));
                wt.setTypeName(rs.getString("type_name"));
                w.setWarehouseType(wt);
                
                return w;
            }
        } catch (Exception e) {
            System.out.println("Error getWarehouseById: " + e.getMessage());
        }
        return null;
    }

    // 2. Lấy danh sách các ô chứa (Storage Units / Zones)
    public List<StorageUnit> getStorageUnits(int warehouseId) {
        List<StorageUnit> list = new ArrayList<>();
        String sql = "SELECT * FROM Storage_unit WHERE warehouse_id = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, warehouseId);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                // Tạo một đối tượng Warehouse "giả" chỉ chứa ID để thỏa mãn Constructor
                Warehouse w = new Warehouse();
                w.setWarehouseId(warehouseId);

                // Lấy dữ liệu từ DB
                int unitId = rs.getInt("unit_id");
                String code = rs.getString("unit_code");
                int status = rs.getInt("status");
                double area = rs.getDouble("area");
                // Chú ý: Tên cột DB là price_per_unit
                double price = rs.getDouble("price_per_unit"); 
                String desc = rs.getString("description");

                // Gọi Constructor (Thứ tự tham số phải khớp với Model StorageUnit của bạn)
                StorageUnit u = new StorageUnit(unitId, code, status, area, price, desc, w);
                
                list.add(u);
            }
        } catch (Exception e) {
            System.out.println("Error getStorageUnits: " + e.getMessage());
        }
        return list;
    }

    // 3. Lấy danh sách ảnh của kho (Cần hàm này để sửa lỗi trong Servlet)
    public List<WarehouseImage> getWarehouseImages(int warehouseId) {
        List<WarehouseImage> list = new ArrayList<>();
        String sql = "SELECT * FROM Warehouse_image WHERE warehouse_id = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, warehouseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                WarehouseImage img = new WarehouseImage();
                img.setImageId(rs.getInt("image_id"));
                img.setImageUrl(rs.getString("image_url"));
                img.setImageType(rs.getString("image_type"));
                img.setPrimary(rs.getBoolean("is_primary"));
                img.setStatus(rs.getInt("status"));
                // Không cần set Warehouse object ngược lại để tránh loop, hoặc chỉ set ID
                list.add(img);
            }
        } catch (Exception e) {
            System.out.println("Error getWarehouseImages: " + e.getMessage());
        }
        return list;
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
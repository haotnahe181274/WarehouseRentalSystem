package dao;

import java.sql.*;
import java.util.*;
import model.Warehouse;
import model.WarehouseType;
import model.StorageUnit;
import model.WarehouseImage;

public class WarehouseManagementDAO extends DBContext {

    public List<String> getAllLocations() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT address FROM Warehouse WHERE status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(rs.getString("address"));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Warehouse> getFilteredWarehouses(String keyword, String location,
            Integer typeId, Double minPrice, Double maxPrice,
            Double minArea, Double maxArea, int offset, int limit) {

        WarehouseTypeDAO typeDAO = new WarehouseTypeDAO();
        List<Warehouse> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT w.*, MIN(s.price_per_unit) AS min_price, MIN(s.area) AS min_area "
            + "FROM Warehouse w LEFT JOIN Storage_unit s ON w.warehouse_id = s.warehouse_id "
            + "WHERE w.status = 1 ");
        if (keyword != null && !keyword.trim().isEmpty()) sql.append("AND w.name LIKE ? ");
        if (location != null && !location.isEmpty())     sql.append("AND w.address LIKE ? ");
        if (typeId  != null)  sql.append("AND w.warehouse_type_id = ? ");
        if (minPrice != null) sql.append("AND s.price_per_unit >= ? ");
        if (maxPrice != null) sql.append("AND s.price_per_unit <= ? ");
        if (minArea  != null) sql.append("AND s.area >= ? ");
        if (maxArea  != null) sql.append("AND s.area <= ? ");
        sql.append("GROUP BY w.warehouse_id ORDER BY w.warehouse_id DESC LIMIT ? OFFSET ?");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int i = 1;
            if (keyword  != null && !keyword.trim().isEmpty()) ps.setString(i++, "%" + keyword.trim() + "%");
            if (location != null && !location.isEmpty())       ps.setString(i++, "%" + location + "%");
            if (typeId   != null) ps.setInt(i++, typeId);
            if (minPrice != null) ps.setDouble(i++, minPrice);
            if (maxPrice != null) ps.setDouble(i++, maxPrice);
            if (minArea  != null) ps.setDouble(i++, minArea);
            if (maxArea  != null) ps.setDouble(i++, maxArea);
            ps.setInt(i++, limit);
            ps.setInt(i,   offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setDescription(rs.getString("description"));
                w.setStatus(rs.getInt("status"));
                w.setTotalArea(rs.getDouble("total_area"));
                w.setMinPrice(rs.getDouble("min_price"));
                w.setMinArea(rs.getDouble("min_area"));
                w.setWarehouseType(typeDAO.getTypeById(rs.getInt("warehouse_type_id")));
                list.add(w);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalRecords(String keyword, String location,
            Integer typeId, Double minPrice, Double maxPrice,
            Double minArea, Double maxArea) {

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(DISTINCT w.warehouse_id) FROM Warehouse w "
            + "JOIN Storage_unit s ON w.warehouse_id = s.warehouse_id WHERE w.status = 1 ");
        if (keyword  != null && !keyword.trim().isEmpty()) sql.append("AND w.name LIKE ? ");
        if (location != null && !location.isEmpty())       sql.append("AND w.address LIKE ? ");
        if (typeId   != null) sql.append("AND w.warehouse_type_id = ? ");
        if (minPrice != null) sql.append("AND s.price_per_unit >= ? ");
        if (maxPrice != null) sql.append("AND s.price_per_unit <= ? ");
        if (minArea  != null) sql.append("AND s.area >= ? ");
        if (maxArea  != null) sql.append("AND s.area <= ? ");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword  != null && !keyword.trim().isEmpty()) ps.setString(idx++, "%" + keyword.trim() + "%");
            if (location != null && !location.isEmpty())       ps.setString(idx++, "%" + location + "%");
            if (typeId   != null) ps.setInt(idx++, typeId);
            if (minPrice != null) ps.setDouble(idx++, minPrice);
            if (maxPrice != null) ps.setDouble(idx++, maxPrice);
            if (minArea  != null) ps.setDouble(idx++, minArea);
            if (maxArea  != null) ps.setDouble(idx++, maxArea);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Warehouse> getAll() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT * FROM Warehouse w";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setDescription(rs.getString("description"));
                w.setStatus(rs.getInt("status"));
                w.setTotalArea(rs.getDouble("total_area")); // ← THÊM

                int typeId = rs.getInt("warehouse_type_id");
                WarehouseType type = new WarehouseType();
                type.setWarehouseTypeId(typeId);
                switch (typeId) {
                    case 1 -> type.setTypeName("Cold Storage");
                    case 2 -> type.setTypeName("Normal Storage");
                    case 3 -> type.setTypeName("High Security");
                }
                w.setWarehouseType(type);
                list.add(w);
            }
        } catch (SQLException e) {
            System.out.println("====== LỖI SQL Ở HÀM getAll() WAREHOUSE ======");
            e.printStackTrace();
        }
        return list;
    }

    public void delete(int id) {
        String sql = "DELETE FROM Warehouse WHERE warehouse_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── INSERT có total_area ──────────────────────────────────────────────
    public int insertReturnId(Warehouse w) {
        String sql = "INSERT INTO Warehouse (name, address, description, status, warehouse_type_id, total_area) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        int generatedId = 0;
        try {
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, w.getName());
            st.setString(2, w.getAddress());
            st.setString(3, w.getDescription());
            st.setInt(4, w.getStatus());
            st.setInt(5, w.getWarehouseType() != null ? w.getWarehouseType().getWarehouseTypeId() : 1);
            st.setDouble(6, w.getTotalArea()); // ← THÊM
            int rows = st.executeUpdate();
            if (rows > 0) {
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) generatedId = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("====== LỖI INSERT WAREHOUSE ======");
            e.printStackTrace();
        }
        return generatedId;
    }

    // ── UPDATE có total_area ──────────────────────────────────────────────
    public void update(Warehouse w) {
        String sql = "UPDATE Warehouse SET name=?, address=?, description=?, status=?, warehouse_type_id=?, total_area=? "
                   + "WHERE warehouse_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, w.getName());
            st.setString(2, w.getAddress());
            st.setString(3, w.getDescription());
            st.setInt(4, w.getStatus());
            st.setInt(5, w.getWarehouseType() != null ? w.getWarehouseType().getWarehouseTypeId() : 1);
            st.setDouble(6, w.getTotalArea()); // ← THÊM
            st.setInt(7, w.getWarehouseId());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("====== LỖI UPDATE WAREHOUSE ======");
            e.printStackTrace();
        }
    }

    // ── GET BY ID có total_area ───────────────────────────────────────────
    public Warehouse getWarehouseById(int id) {
        String sql = "SELECT w.*, wt.type_name, "
                + "(SELECT MIN(price_per_unit) FROM Storage_unit WHERE warehouse_id = w.warehouse_id) AS min_price, "
                + "(SELECT MIN(area)           FROM Storage_unit WHERE warehouse_id = w.warehouse_id) AS min_area "
                + "FROM Warehouse w "
                + "JOIN Warehouse_Type wt ON w.warehouse_type_id = wt.warehouse_type_id "
                + "WHERE w.warehouse_id = ?";
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
                w.setTotalArea(rs.getDouble("total_area")); // ← THÊM
                w.setMinPrice(rs.getDouble("min_price"));
                w.setMinArea(rs.getDouble("min_area"));
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

    public List<StorageUnit> getStorageUnits(int warehouseId) {
        List<StorageUnit> list = new ArrayList<>();
        String sql = "SELECT * FROM Storage_unit WHERE warehouse_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, warehouseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(warehouseId);
                StorageUnit u = new StorageUnit(
                    rs.getInt("unit_id"),
                    rs.getString("unit_code"),
                    rs.getInt("status"),
                    rs.getDouble("area"),
                    rs.getDouble("price_per_unit"),
                    rs.getString("description"),
                    w
                );
                list.add(u);
            }
        } catch (Exception e) {
            System.out.println("Error getStorageUnits: " + e.getMessage());
        }
        return list;
    }

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
                list.add(img);
            }
        } catch (Exception e) {
            System.out.println("Error getWarehouseImages: " + e.getMessage());
        }
        return list;
    }

    public Map<Integer, List<String[]>> getUnitBookedDates(int warehouseId) {
        Map<Integer, List<String[]>> map = new HashMap<>();
        // Chỉ tô đỏ khi contract có payment đã thanh toán (payment.status = 1)
        String sql = "SELECT csu.unit_id, csu.start_date, csu.end_date "
                + "FROM Contract_Storage_unit csu "
                + "JOIN Storage_unit su      ON csu.unit_id     = su.unit_id "
                + "JOIN Contract c           ON csu.contract_id = c.contract_id "
                + "JOIN Payment p            ON p.contract_id   = c.contract_id "
                + "WHERE su.warehouse_id = ? "
                + "  AND csu.status = 1 "
                + "  AND c.status   = 1 "
                + "  AND p.status   = 1";   // ← chỉ tô khi đã thanh toán
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, warehouseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int unitId   = rs.getInt("unit_id");
                String start = rs.getDate("start_date").toString();
                String end   = rs.getDate("end_date").toString();
                map.putIfAbsent(unitId, new ArrayList<>());
                map.get(unitId).add(new String[]{start, end});
            }
        } catch (Exception e) {
            System.out.println("Lỗi getUnitBookedDates: " + e.getMessage());
        }
        return map;
    }

    public boolean insertStorageUnit(StorageUnit unit) {
        String sql = "INSERT INTO Storage_unit (unit_code, status, area, price_per_unit, description, warehouse_id) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, unit.getUnitCode());
            st.setInt(2, unit.getStatus());
            st.setDouble(3, unit.getArea());
            st.setDouble(4, unit.getPricePerUnit());
            st.setString(5, unit.getDescription());
            st.setInt(6, unit.getWarehouse().getWarehouseId());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi insertStorageUnit: " + e.getMessage());
        }
        return false;
    }

    public boolean updateStorageUnit(StorageUnit unit) {
        String sql = "UPDATE Storage_unit SET unit_code=?, status=?, area=?, price_per_unit=?, description=? "
                + "WHERE unit_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, unit.getUnitCode());
            st.setInt(2, unit.getStatus());
            st.setDouble(3, unit.getArea());
            st.setDouble(4, unit.getPricePerUnit());
            st.setString(5, unit.getDescription());
            st.setInt(6, unit.getUnitId());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateStorageUnit: " + e.getMessage());
        }
        return false;
    }

    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM Warehouse";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countByStatus(int status) {
        String sql = "SELECT COUNT(*) FROM Warehouse WHERE status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}

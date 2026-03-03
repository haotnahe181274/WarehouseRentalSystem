package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.StorageUnit;
import model.Warehouse;

public class StorageUnitDAO extends DBContext {
    
    /**
     * Các unit mà renter đang thuê hợp lệ (Contract + Payment status = 1, ngày trong hạn).
     */
    public List<StorageUnit> getActiveUnitsForRenter(int renterId) {

        List<StorageUnit> list = new ArrayList<>();

        String sql = """
            SELECT DISTINCT su.unit_id, su.unit_code, su.status, su.area, su.price_per_unit,
                            su.description AS unit_description,
                            w.warehouse_id, w.name AS warehouse_name, w.address, w.description AS warehouse_description
            FROM Contract_Storage_unit csu
            JOIN Contract c ON c.contract_id = csu.contract_id
            JOIN Payment p ON p.contract_id = c.contract_id AND p.status = 1
            JOIN Storage_unit su ON su.unit_id = csu.unit_id
            JOIN Warehouse w ON w.warehouse_id = su.warehouse_id
            WHERE c.renter_id = ?
              AND c.status = 1
              AND csu.status = 1
              AND csu.start_date <= NOW() AND csu.end_date >= NOW()
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, renterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse warehouse = new Warehouse();
                warehouse.setWarehouseId(rs.getInt("warehouse_id"));
                warehouse.setName(rs.getString("warehouse_name"));
                warehouse.setAddress(rs.getString("address"));
                warehouse.setDescription(rs.getString("warehouse_description"));

                StorageUnit unit = new StorageUnit();
                unit.setUnitId(rs.getInt("unit_id"));
                unit.setUnitCode(rs.getString("unit_code"));
                unit.setStatus(rs.getInt("status"));
                unit.setArea(rs.getDouble("area"));
                unit.setPricePerUnit(rs.getDouble("price_per_unit"));
                unit.setDescription(rs.getString("unit_description"));
                unit.setWarehouse(warehouse);

                list.add(unit);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Tìm các Storage Unit CÒN TRỐNG trong một Kho dựa theo khoảng thời gian khách chọn.
     * @param warehouseId ID của kho hiện tại
     * @param startDate Ngày bắt đầu khách muốn thuê (Format: YYYY-MM-DD)
     * @param endDate Ngày kết thúc khách muốn thuê (Format: YYYY-MM-DD)
     * @return Danh sách các Unit KHÔNG BỊ TRÙNG LỊCH
     */
    public List<StorageUnit> searchAvailableUnits(int warehouseId, String startDate, String endDate) {
        List<StorageUnit> list = new ArrayList<>();

        String sql = """
            SELECT su.* FROM Storage_unit su
            WHERE su.warehouse_id = ?
              AND su.unit_id NOT IN (
                  SELECT csu.unit_id 
                  FROM Contract_Storage_unit csu
                  JOIN Contract c ON csu.contract_id = c.contract_id
                  WHERE c.status = 1 AND csu.status = 1
                    AND csu.start_date <= ?  
                    AND csu.end_date >= ?    
              )
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            ps.setDate(2, java.sql.Date.valueOf(endDate));
            ps.setDate(3, java.sql.Date.valueOf(startDate));
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(warehouseId);

                StorageUnit unit = new StorageUnit();
                unit.setUnitId(rs.getInt("unit_id"));
                unit.setUnitCode(rs.getString("unit_code"));
                unit.setStatus(rs.getInt("status"));
                unit.setArea(rs.getDouble("area"));
                unit.setPricePerUnit(rs.getDouble("price_per_unit"));
                unit.setDescription(rs.getString("description"));
                unit.setWarehouse(w);

                list.add(unit);
            }
        } catch (Exception e) {
            System.out.println("Lỗi searchAvailableUnits: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }
    
    // =========================================================================
    // 2 HÀM MỚI ĐỂ UPDATE VÀ DELETE STORAGE UNIT
    // =========================================================================

    /**
     * Cập nhật thông tin của một Storage Unit
     */
    public boolean updateStorageUnit(int unitId, String unitCode, double area, double price, int status, String description) {
        String sql = "UPDATE Storage_unit SET unit_code = ?, area = ?, price_per_unit = ?, status = ?, description = ? WHERE unit_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, unitCode);
            ps.setDouble(2, area);
            ps.setDouble(3, price);
            ps.setInt(4, status);
            ps.setString(5, description);
            ps.setInt(6, unitId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateStorageUnit: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa một Storage Unit khỏi cơ sở dữ liệu
     */
  public boolean changeStorageUnit(int unitId, int status) {
        String sql = "UPDATE Storage_unit SET status = ? WHERE unit_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, unitId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Lỗi disableStorageUnit: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
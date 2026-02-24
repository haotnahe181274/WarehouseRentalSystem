/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.StorageUnit;
import model.Warehouse;

/**
 *
 * @author ad
 */
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

    
}

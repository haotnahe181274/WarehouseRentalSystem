/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;
import model.Item;
import model.StorageUnit;
import model.StorageUnitItem;
import model.Warehouse;

/**
 *
 * @author ad
 */
public class StorageUnitItemDAO extends DBContext {

    public List<StorageUnitItem> getItemsByRenter(int renterId) {

        List<StorageUnitItem> list = new ArrayList<>();

        String sql = "SELECT "
                + "sui.id, sui.quantity, "
                + "i.item_id, i.item_name, i.description AS item_description, i.renter_id, "
                + "su.unit_id, su.unit_code, su.status, su.area, su.price_per_unit, su.description AS unit_description, "
                + "w.warehouse_id, w.name AS warehouse_name, w.address, w.description AS warehouse_description "
                + "FROM item i "
                + "INNER JOIN storage_unit_item sui ON i.item_id = sui.item_id "
                + "INNER JOIN storage_unit su ON sui.unit_id = su.unit_id "
                + "INNER JOIN warehouse w ON su.warehouse_id = w.warehouse_id "
                + "WHERE i.renter_id = ? "
                + "ORDER BY i.item_name";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, renterId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                // ===== Item =====
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setDescription(rs.getString("item_description"));
                item.setRenterId(rs.getInt("renter_id"));

                // ===== Warehouse =====
                Warehouse warehouse = new Warehouse();
                warehouse.setWarehouseId(rs.getInt("warehouse_id"));
                warehouse.setName(rs.getString("warehouse_name"));
                warehouse.setAddress(rs.getString("address"));
                warehouse.setDescription(rs.getString("warehouse_description"));

                // ===== Storage Unit =====
                StorageUnit unit = new StorageUnit();
                unit.setUnitId(rs.getInt("unit_id"));
                unit.setUnitCode(rs.getString("unit_code"));
                unit.setStatus(rs.getInt("status"));
                unit.setArea(rs.getDouble("area"));
                unit.setPricePerUnit(rs.getDouble("price_per_unit"));
                unit.setDescription(rs.getString("unit_description"));
                unit.setWarehouse(warehouse);

                // ===== StorageUnitItem =====
                StorageUnitItem sui = new StorageUnitItem();
                sui.setId(rs.getInt("id"));
                sui.setQuantity(rs.getInt("quantity"));
                sui.setItem(item);
                sui.setUnit(unit);

                list.add(sui);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}

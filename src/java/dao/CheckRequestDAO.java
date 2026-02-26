package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.CheckRequest;
import model.CheckRequestItem;
import model.Item;
import model.StorageUnit;
import model.Warehouse;

/** DAO cho check_request và check_request_item. */
public class CheckRequestDAO extends DBContext {

    /** Tạo đơn check in/out, trả về id mới hoặc -1. */
    public int insertCheckRequest(int renterId, int warehouseId, int unitId, String requestType) {
        String sql = "INSERT INTO check_request (request_date, request_type, renter_id, warehouse_id, unit_id, internal_user_id, processed_date) VALUES (NOW(), ?, ?, ?, ?, NULL, NULL)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, requestType);
            ps.setInt(2, renterId);
            ps.setInt(3, warehouseId);
            ps.setInt(4, unitId);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** Thêm một dòng item vào đơn check: quantity, processed_quantity = NULL, status = 'processing'. */
    public void insertCheckRequestItem(int checkRequestId, int itemId, int quantity) {
        String sql = "INSERT INTO check_request_item (check_request_id, item_id, quantity, processed_quantity, status) VALUES (?, ?, ?, NULL, 'processing')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, checkRequestId);
            ps.setInt(2, itemId);
            ps.setInt(3, quantity);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Lấy danh sách đơn check của 1 renter kèm trạng thái tổng (suy ra từ các item). */
    public List<CheckRequest> getCheckRequestsByRenter(int renterId) {
        List<CheckRequest> list = new ArrayList<>();
        String sql = """
            SELECT cr.id,
                   cr.request_date,
                   cr.request_type,
                   cr.warehouse_id,
                   w.name AS warehouse_name,
                   cr.unit_id,
                   su.unit_code,
                   SUM(CASE WHEN ci.status = 'processing' THEN 1 ELSE 0 END) AS cnt_processing,
                   SUM(CASE WHEN ci.status = 'fail' THEN 1 ELSE 0 END) AS cnt_fail
            FROM check_request cr
            JOIN warehouse w ON cr.warehouse_id = w.warehouse_id
            JOIN Storage_unit su ON su.unit_id = cr.unit_id
            LEFT JOIN check_request_item ci ON ci.check_request_id = cr.id
            WHERE cr.renter_id = ?
            GROUP BY cr.id, cr.request_date, cr.request_type,
                     cr.warehouse_id, w.name, cr.unit_id, su.unit_code
            ORDER BY cr.request_date DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, renterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CheckRequest cr = new CheckRequest();
                cr.setId(rs.getInt("id"));
                cr.setRequestDate(rs.getTimestamp("request_date"));
                cr.setRequestType(rs.getString("request_type"));

                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("warehouse_name"));
                cr.setWarehouse(w);

                StorageUnit u = new StorageUnit();
                u.setUnitId(rs.getInt("unit_id"));
                u.setUnitCode(rs.getString("unit_code"));
                cr.setUnit(u);

                int cntProcessing = rs.getInt("cnt_processing");
                int cntFail = rs.getInt("cnt_fail");
                String overall;
                if (cntProcessing > 0) {
                    overall = "processing";
                } else if (cntFail > 0) {
                    overall = "fail";
                } else {
                    overall = "done";
                }
                cr.setOverallStatus(overall);

                list.add(cr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Lấy chi tiết 1 đơn check + danh sách item (chỉ cho renter sở hữu đơn). */
    public CheckRequest getCheckRequestWithItems(int id, int renterId) {
        CheckRequest cr = null;
        String sql = """
            SELECT cr.id, cr.request_date, cr.request_type,
                   cr.renter_id, cr.warehouse_id, cr.unit_id,
                   w.name AS warehouse_name, w.address,
                   su.unit_code
            FROM check_request cr
            JOIN warehouse w ON cr.warehouse_id = w.warehouse_id
            JOIN Storage_unit su ON su.unit_id = cr.unit_id
            WHERE cr.id = ? AND cr.renter_id = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, renterId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                cr = new CheckRequest();
                cr.setId(rs.getInt("id"));
                cr.setRequestDate(rs.getTimestamp("request_date"));
                cr.setRequestType(rs.getString("request_type"));
                cr.setRenterId(rs.getInt("renter_id"));
                cr.setWarehouseId(rs.getInt("warehouse_id"));
                cr.setUnitId(rs.getInt("unit_id"));

                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("warehouse_name"));
                w.setAddress(rs.getString("address"));
                cr.setWarehouse(w);

                StorageUnit u = new StorageUnit();
                u.setUnitId(rs.getInt("unit_id"));
                u.setUnitCode(rs.getString("unit_code"));
                cr.setUnit(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (cr != null) {
            cr.setItems(getCheckRequestItemsByCheckRequestId(cr.getId()));
        }
        return cr;
    }

    /** Lấy danh sách item theo check_request_id. */
    public List<CheckRequestItem> getCheckRequestItemsByCheckRequestId(int checkRequestId) {
        List<CheckRequestItem> list = new ArrayList<>();
        String sql = """
            SELECT ci.id, ci.check_request_id, ci.item_id, ci.quantity, ci.processed_quantity, ci.status,
                   i.item_name, i.description
            FROM check_request_item ci
            JOIN item i ON i.item_id = ci.item_id
            WHERE ci.check_request_id = ?
            ORDER BY ci.id
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, checkRequestId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CheckRequestItem ci = new CheckRequestItem();
                ci.setId(rs.getInt("id"));
                ci.setCheckRequestId(rs.getInt("check_request_id"));
                ci.setItemId(rs.getInt("item_id"));
                ci.setQuantity(rs.getInt("quantity"));
                int pq = rs.getInt("processed_quantity");
                ci.setProcessedQuantity(rs.wasNull() ? null : pq);
                ci.setStatus(rs.getString("status"));

                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setDescription(rs.getString("description"));
                ci.setItem(item);

                list.add(ci);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

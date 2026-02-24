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

    
}

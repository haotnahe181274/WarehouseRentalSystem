package dao;

import java.sql.*;
import java.util.*;
import model.CheckRequest;
import model.CheckRequestItem;
import model.Item;
import model.StaffTask;


public class StaffTaskDAO extends DBContext {
    
    public List<StaffTask> getTasksByStaff(int staffId) {

        List<StaffTask> list = new ArrayList<>();

        String sql = """
            SELECT 
                sa.assignment_id,
                cr.id AS request_id,
                cr.request_type,
                cr.request_date,
                w.name AS warehouse_name,
                su.unit_code AS unit_name,
                sa.due_date

            FROM Staff_assignment sa

            JOIN check_request cr 
            ON sa.check_request_id = cr.id

            JOIN Warehouse w 
            ON sa.warehouse_id = w.warehouse_id

            LEFT JOIN Storage_unit su 
            ON sa.unit_id = su.unit_id

            WHERE sa.assigned_to = ?
            AND sa.completed_at IS NULL

            ORDER BY cr.request_date DESC
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, staffId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                StaffTask t = new StaffTask();

                t.setAssignmentId(rs.getInt("assignment_id"));
                t.setRequestId(rs.getInt("request_id"));
                t.setRequestType(rs.getString("request_type"));
                t.setWarehouseName(rs.getString("warehouse_name"));
                t.setUnitName(rs.getString("unit_name"));
                t.setRequestDate(rs.getDate("request_date"));
                t.setDueDate(rs.getDate("due_date"));

                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
   
    public int getRequestIdByAssignment(int assignmentId) {

        String sql = """
            SELECT check_request_id
            FROM Staff_assignment
            WHERE assignment_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, assignmentId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("check_request_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }
    
    public CheckRequest getCheckRequestById(int requestId) {

        CheckRequest request = null;

        String sql = """
            SELECT *
            FROM check_request
            WHERE id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, requestId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                request = new CheckRequest();

                request.setId(rs.getInt("id"));
                request.setRequestDate(rs.getTimestamp("request_date"));
                request.setRequestType(rs.getString("request_type"));
                request.setRenterId(rs.getInt("renter_id"));
                request.setWarehouseId(rs.getInt("warehouse_id"));
                request.setUnitId(rs.getInt("unit_id"));
                request.setInternalUserId(rs.getInt("internal_user_id"));
                request.setProcessedDate(rs.getTimestamp("processed_date"));

                request.setItems(getItemsByRequest(requestId));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return request;
    }
    
    public List<CheckRequestItem> getItemsByRequest(int requestId) {

        List<CheckRequestItem> list = new ArrayList<>();

        String sql = """
            SELECT 
                cri.*,
                i.item_id,
                i.item_name
            FROM check_request_item cri
            JOIN Item i ON cri.item_id = i.item_id
            WHERE cri.check_request_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, requestId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                CheckRequestItem item = new CheckRequestItem();

                item.setId(rs.getInt("id"));
                item.setCheckRequestId(rs.getInt("check_request_id"));
                item.setItemId(rs.getInt("item_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setProcessedQuantity((Integer) rs.getObject("processed_quantity"));
                item.setStatus(rs.getString("status"));

                Item i = new Item();
                i.setItemId(rs.getInt("item_id"));
                i.setItemName(rs.getString("item_name"));

                item.setItem(i);

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
   
    public void updateCheckRequestItem(int id, int processedQty, String status) {

        String sql = """
            UPDATE check_request_item
            SET processed_quantity = ?, status = ?
            WHERE id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, processedQty);
            ps.setString(2, status);
            ps.setInt(3, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
     
    public void addInventory(int unitId, int itemId, int quantity) {

        String sql = """
            UPDATE storage_unit_item
            SET quantity = quantity + ?
            WHERE unit_id = ? AND item_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, quantity);
            ps.setInt(2, unitId);
            ps.setInt(3, itemId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void removeInventory(int unitId, int itemId, int quantity) {

        String sql = """
            UPDATE storage_unit_item
            SET quantity = quantity - ?
            WHERE unit_id = ? AND item_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, quantity);
            ps.setInt(2, unitId);
            ps.setInt(3, itemId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void insertInventoryLog(int action, int quantity, int itemId, int unitId, int userId, int checkRequestId) {
        String sql = """
            INSERT INTO Inventory_log
            (action, quantity, action_date, item_id, unit_id, internal_user_id, check_request_id)
            VALUES (?, ?, NOW(), ?, ?, ?, ?)
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, action);
            ps.setInt(2, quantity);
            ps.setInt(3, itemId);
            ps.setInt(4, unitId);
            ps.setInt(5, userId);
            ps.setInt(6, checkRequestId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void completeAssignment(int assignmentId) {

        String sql = """
            UPDATE Staff_assignment
            SET completed_at = NOW()
            WHERE assignment_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, assignmentId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void updateCheckRequestInternal(int requestId, int assignmentId) {
        String sql = """
            UPDATE check_request 
            SET internal_user_id = (
                SELECT assigned_to 
                FROM staff_assignment 
                WHERE assignment_id = ?
            ),
            processed_date = NOW()
            WHERE id = ?
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, assignmentId);
            ps.setInt(2, requestId);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
public int getTotalInventoryLogQty(int checkRequestItemId, int checkRequestId) {
    String sql = """
        SELECT SUM(quantity) AS total
        FROM Inventory_log
        WHERE check_request_id = ? AND item_id = (
            SELECT item_id FROM check_request_item WHERE id = ?
        )
    """;
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, checkRequestId);
        ps.setInt(2, checkRequestItemId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt("total");
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}
public int getTotalProcessedQty(int itemId, int checkRequestId) {
    String sql = "SELECT SUM(quantity) AS total FROM Inventory_log WHERE item_id = ? AND check_request_id = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, itemId);
        ps.setInt(2, checkRequestId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt("total");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}
}

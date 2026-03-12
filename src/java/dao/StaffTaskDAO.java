package dao;

import java.sql.*;
import java.util.*;
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
   
}

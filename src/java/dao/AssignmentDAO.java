package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;
import model.StaffAssignment;
import model.StorageUnit;

public class AssignmentDAO extends DBContext {

    // ==========================================
    // FIND OPTIMAL STAFF FOR A WAREHOUSE
    // ==========================================

    /**
     * Finds the active staff member (role_id=3) assigned to the given warehouse
     * with the fewest pending tasks (completed_at IS NULL).
     */
    public int getOptimalStaffId(int warehouseId) {
        int staffId = -1;
        System.out.println("[SYSTEM] Looking for available staff for warehouse ID: " + warehouseId);

        String sql = "SELECT u.internal_user_id, COUNT(sa.assignment_id) AS active_tasks " +
                     "FROM Internal_user u " +
                     "LEFT JOIN Staff_assignment sa " +
                     "    ON u.internal_user_id = sa.assigned_to AND sa.completed_at IS NULL " +
                     "WHERE u.role_id = 3 " +
                     "  AND u.status = 1 " +
                     "  AND u.warehouse_id = ? " +
                     "GROUP BY u.internal_user_id " +
                     "ORDER BY active_tasks ASC, u.internal_user_id ASC " +
                     "LIMIT 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staffId = rs.getInt("internal_user_id");
                    System.out.println("[SYSTEM] Found staff ID: " + staffId
                            + " (active tasks: " + rs.getInt("active_tasks") + ")");
                } else {
                    System.out.println("[SYSTEM] No staff found for warehouse ID: " + warehouseId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffId;
    }

    // ==========================================
    // FLOW 1: AUTO CHECK-IN TASK FROM CONTRACT
    // ==========================================

    /**
     * Creates a check-in task automatically when a contract is approved/paid.
     */
    public boolean createCheckTaskFromPayment(int contractId) {
        boolean success = false;
        System.out.println("=== Creating check-in task from contract #" + contractId + " ===");

        String contractQuery =
            "SELECT c.warehouse_id, DATE(c.start_date) AS start_date, " +
            "DATE(DATE_ADD(c.start_date, INTERVAL 3 DAY)) AS task_due_date " +
            "FROM Contract c WHERE c.contract_id = ?";

        try (PreparedStatement psContract = connection.prepareStatement(contractQuery)) {
            psContract.setInt(1, contractId);
            try (ResultSet rsContract = psContract.executeQuery()) {
                if (rsContract.next()) {
                    int warehouseId  = rsContract.getInt("warehouse_id");
                    String startDate = rsContract.getString("start_date");
                    String dueDate   = rsContract.getString("task_due_date");

                    int assignedTo = getOptimalStaffId(warehouseId);
                    if (assignedTo == -1) return false;

                    // Collect all unit IDs in this contract
                    List<Integer> unitIds = new ArrayList<>();
                    String unitQuery = "SELECT unit_id FROM Contract_Storage_unit WHERE contract_id = ?";
                    try (PreparedStatement psUnits = connection.prepareStatement(unitQuery)) {
                        psUnits.setInt(1, contractId);
                        try (ResultSet rsUnits = psUnits.executeQuery()) {
                            while (rsUnits.next()) unitIds.add(rsUnits.getInt("unit_id"));
                        }
                    }
                    if (unitIds.isEmpty()) unitIds.add(null);

                    String insertSQL =
                        "INSERT INTO Staff_assignment " +
                        "(assigned_to, warehouse_id, unit_id, assignment_type, " +
                        " check_request_id, description, started_date, due_date) " +
                        "VALUES (?, ?, ?, 1, NULL, ?, ?, ?)";

                    for (Integer unitId : unitIds) {
                        try (PreparedStatement ps = connection.prepareStatement(insertSQL)) {
                            ps.setInt(1, assignedTo);
                            ps.setInt(2, warehouseId);
                            if (unitId != null) ps.setInt(3, unitId);
                            else ps.setNull(3, Types.INTEGER);
                            ps.setString(4, "[AUTO] Check-in for contract #" + contractId);
                            ps.setString(5, startDate);
                            ps.setString(6, dueDate);
                            if (ps.executeUpdate() > 0) success = true;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // ==========================================
    // FLOW 2: CHECK-IN / CHECK-OUT FROM RENTER REQUEST
    // ==========================================

    /**
     * Creates a check-in or check-out task from a renter's check request.
     */
    public boolean createTaskFromCheckRequest(int checkRequestId) {
        boolean success = false;
        System.out.println("=== Creating task from check request #" + checkRequestId + " ===");

        String requestQuery =
            "SELECT warehouse_id, unit_id, request_type, " +
            "DATE(request_date) AS request_date, " +
            "DATE(DATE_ADD(request_date, INTERVAL 2 DAY)) AS task_due_date " +
            "FROM check_request WHERE id = ?";

        try (PreparedStatement psReq = connection.prepareStatement(requestQuery)) {
            psReq.setInt(1, checkRequestId);
            try (ResultSet rsReq = psReq.executeQuery()) {
                if (rsReq.next()) {
                    int warehouseId     = rsReq.getInt("warehouse_id");
                    String requestType  = rsReq.getString("request_type");
                    String startedDate  = rsReq.getString("request_date");
                    String dueDate      = rsReq.getString("task_due_date");
                    Integer unitId      = rsReq.getInt("unit_id");
                    if (rsReq.wasNull()) unitId = null;

                    int assignmentType  = "CHECK_OUT".equalsIgnoreCase(requestType) ? 2 : 1;
                    String actionLabel  = "CHECK_OUT".equalsIgnoreCase(requestType) ? "Check-out" : "Check-in";

                    int assignedTo = getOptimalStaffId(warehouseId);
                    if (assignedTo == -1) return false;

                    String insertSQL =
                        "INSERT INTO Staff_assignment " +
                        "(assigned_to, warehouse_id, unit_id, assignment_type, " +
                        " check_request_id, description, started_date, due_date) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                    try (PreparedStatement ps = connection.prepareStatement(insertSQL)) {
                        ps.setInt(1, assignedTo);
                        ps.setInt(2, warehouseId);
                        if (unitId != null) ps.setInt(3, unitId);
                        else ps.setNull(3, Types.INTEGER);
                        ps.setInt(4, assignmentType);
                        ps.setInt(5, checkRequestId);
                        ps.setString(6, actionLabel + " request #" + checkRequestId);
                        ps.setString(7, startedDate);
                        ps.setString(8, dueDate);
                        if (ps.executeUpdate() > 0) success = true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // ==========================================
    // FLOW 3: GET STAFF ID BY CHECK REQUEST
    // ==========================================

    /**
     * Returns the staff ID assigned to the most recent assignment for a check request.
     * Used by CreateCheckRequest servlet to send notifications.
     */
    public int getStaffIdByCheckRequest(int checkRequestId) {
        String sql = "SELECT assigned_to FROM Staff_assignment " +
                     "WHERE check_request_id = ? ORDER BY assignment_id DESC LIMIT 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, checkRequestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("assigned_to");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ==========================================
    // FLOW 4: GET ALL ASSIGNMENTS (for Admin/Manager board)
    // ==========================================

    /**
     * Returns all assignments joined with staff name, warehouse name, and unit code.
     * Only uses columns that actually exist in the Staff_assignment table.
     */
    public List<StaffAssignment> getAllAssignments() {
        List<StaffAssignment> list = new ArrayList<>();

        String sql =
            "SELECT sa.assignment_id, sa.assigned_to, sa.warehouse_id, sa.unit_id, " +
            "       sa.assignment_type, sa.check_request_id, sa.description, " +
            "       sa.started_date, sa.due_date, sa.completed_at, " +
            "       u.full_name  AS staff_name, " +
            "       w.name       AS warehouse_name, " +
            "       su.unit_code AS unit_code " +
            "FROM Staff_assignment sa " +
            "LEFT JOIN Internal_user u  ON sa.assigned_to  = u.internal_user_id " +
            "LEFT JOIN Warehouse w      ON sa.warehouse_id = w.warehouse_id " +
            "LEFT JOIN Storage_unit su  ON sa.unit_id      = su.unit_id " +
            "ORDER BY sa.assignment_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffAssignment t = new StaffAssignment();
                t.setAssignmentId(rs.getInt("assignment_id"));
                t.setAssignedTo(rs.getInt("assigned_to"));
                t.setWarehouseId(rs.getInt("warehouse_id"));

                int unitId = rs.getInt("unit_id");
                t.setUnitId(rs.wasNull() ? null : unitId);

                t.setAssignmentType(rs.getInt("assignment_type"));

                int crId = rs.getInt("check_request_id");
                t.setCheckRequestId(rs.wasNull() ? null : crId);

                t.setDescription(rs.getString("description"));
                t.setStartedDate(rs.getDate("started_date"));
                t.setDueDate(rs.getDate("due_date"));
                t.setCompletedAt(rs.getTimestamp("completed_at"));

                // Joined display fields
                t.setStaffName(rs.getString("staff_name"));
                t.setWarehouseName(rs.getString("warehouse_name"));
                t.setUnitCode(rs.getString("unit_code"));

                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==========================================
    // UTILITY: GET UNITS BY WAREHOUSE
    // ==========================================

    public List<StorageUnit> getUnitsByWarehouse(int warehouseId) {
        List<StorageUnit> list = new ArrayList<>();
        String sql = "SELECT unit_id, unit_code, description " +
                     "FROM Storage_unit WHERE warehouse_id = ? AND status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StorageUnit u = new StorageUnit();
                    u.setUnitId(rs.getInt("unit_id"));
                    u.setUnitCode(rs.getString("unit_code"));
                    u.setDescription(rs.getString("description"));
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
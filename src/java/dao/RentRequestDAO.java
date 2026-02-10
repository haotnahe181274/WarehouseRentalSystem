/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Date;
import java.util.List;
import model.InternalUser;
import model.RentRequest;
import model.Renter;
import model.Warehouse;

/**
 *
 * @author ad
 */
public class RentRequestDAO extends DBContext {

    public List<RentRequest> getAllRentRequests() {
        List<RentRequest> list = new ArrayList<>();

        String sql = """
    SELECT rr.*,
           r.renter_id,
           w.warehouse_id,
           iu.internal_user_id, iu.full_name,iu.user_name
                    
    FROM rent_request rr
    JOIN renter r ON rr.renter_id = r.renter_id
    JOIN warehouse w ON rr.warehouse_id = w.warehouse_id
    LEFT JOIN internal_user iu ON rr.internal_user_id = iu.internal_user_id
    WHERE rr.request_type = 'RENT'
    ORDER BY rr.request_date DESC
""";

        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                RentRequest rr = new RentRequest();

                // ===== BASIC INFO =====
                rr.setRequestId(rs.getInt("request_id"));
                rr.setStatus(rs.getInt("status"));
                rr.setRequestType(rs.getString("request_type"));

                // ===== DATETIME -> java.util.Date =====
                rr.setRequestDate(rs.getTimestamp("request_date")); // có giờ
                rr.setProcessedDate(rs.getTimestamp("processed_date")); // có thể null

                // ===== DATE -> LocalDate =====
                Date startSqlDate = rs.getDate("start_date");
                if (startSqlDate != null) {
                    rr.setStartDate(startSqlDate.toLocalDate());
                }

                Date endSqlDate = rs.getDate("end_date");
                if (endSqlDate != null) {
                    rr.setEndDate(endSqlDate.toLocalDate());
                }

                // ===== RENTER =====
                Renter renter = new Renter();
                renter.setRenterId(rs.getInt("renter_id"));
                rr.setRenter(renter);

                // ===== WAREHOUSE =====
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                rr.setWarehouse(w);

                // ===== INTERNAL USER (nullable) =====
                int internalUserId = rs.getInt("internal_user_id");
                if (!rs.wasNull()) {
                    InternalUser iu = new InternalUser();
                    iu.setInternalUserId(internalUserId);
                    iu.setName(rs.getString("user_name"));
                    iu.setFullName(rs.getString("full_name"));
                    rr.setProcessedBy(iu);
                }

                list.add(rr);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<RentRequest> getRentRequestsByRenterId(int renterId) {
        List<RentRequest> list = new ArrayList<>();

        String sql = """
        SELECT rr.*,
               r.renter_id,
               w.warehouse_id,
               iu.internal_user_id
        FROM rent_request rr
        JOIN renter r ON rr.renter_id = r.renter_id
        JOIN warehouse w ON rr.warehouse_id = w.warehouse_id
        LEFT JOIN internal_user iu ON rr.internal_user_id = iu.internal_user_id
        WHERE rr.request_type = 'RENT'
          AND rr.renter_id = ?
        ORDER BY rr.request_date DESC
    """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, renterId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    RentRequest rr = new RentRequest();

                    // ===== BASIC INFO =====
                    rr.setRequestId(rs.getInt("request_id"));
                    rr.setStatus(rs.getInt("status"));
                    rr.setRequestType(rs.getString("request_type"));

                    // ===== DATETIME -> java.util.Date =====
                    rr.setRequestDate(rs.getTimestamp("request_date"));
                    rr.setProcessedDate(rs.getTimestamp("processed_date"));

                    // ===== DATE -> LocalDate =====
                    Date startSqlDate = rs.getDate("start_date");
                    if (startSqlDate != null) {
                        rr.setStartDate(startSqlDate.toLocalDate());
                    }

                    Date endSqlDate = rs.getDate("end_date");
                    if (endSqlDate != null) {
                        rr.setEndDate(endSqlDate.toLocalDate());
                    }

                    // ===== RENTER =====
                    Renter renter = new Renter();
                    renter.setRenterId(rs.getInt("renter_id"));
                    rr.setRenter(renter);

                    // ===== WAREHOUSE =====
                    Warehouse w = new Warehouse();
                    w.setWarehouseId(rs.getInt("warehouse_id"));
                    rr.setWarehouse(w);

                    // ===== INTERNAL USER (nullable) =====
                    int internalUserId = rs.getInt("internal_user_id");
                    if (!rs.wasNull()) {
                        InternalUser iu = new InternalUser();
                        iu.setInternalUserId(internalUserId);
                        rr.setProcessedBy(iu);
                    }

                    list.add(rr);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void cancelByRenter(int requestId, int renterId) {
        String sql = """
        UPDATE rent_request
        SET status = ?
        WHERE request_id = ?
          AND renter_id = ?
          AND status = 0
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, 3); // 3 = Cancelled
            ps.setInt(2, requestId);
            ps.setInt(3, renterId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStatusByManager(int requestId, int status, int managerId) {
        String sql = """
        UPDATE rent_request
        SET status = ?,
            processed_date = NOW(),
            internal_user_id = ?
        WHERE request_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, managerId);
            ps.setInt(3, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {

        RentRequestDAO dao = new RentRequestDAO();

        System.out.println("===== TEST GET ALL RENT REQUESTS =====");

        List<RentRequest> list = dao.getAllRentRequests();

        if (list == null || list.isEmpty()) {
            System.out.println("❌ Không lấy được rent request nào!");
            return;
        }

        System.out.println("✅ Tổng số rent request: " + list.size());
        System.out.println("--------------------------------------");

        for (RentRequest rr : list) {
            System.out.println("Request ID     : " + rr.getRequestId());
            System.out.println("Status         : " + rr.getStatus());
            System.out.println("Type           : " + rr.getRequestType());

            System.out.println("Request Date   : " + rr.getRequestDate());
            System.out.println("Processed Date : " + rr.getProcessedDate());

            System.out.println("Start Date     : " + rr.getStartDate());
            System.out.println("End Date       : " + rr.getEndDate());

            if (rr.getRenter() != null) {
                System.out.println("Renter ID      : " + rr.getRenter().getRenterId());
            }

            if (rr.getWarehouse() != null) {
                System.out.println("Warehouse ID   : " + rr.getWarehouse().getWarehouseId());
            }

            if (rr.getProcessedBy() != null) {
                System.out.println("Processed By   : " + rr.getProcessedBy().getInternalUserId());
            } else {
                System.out.println("Processed By   : NULL");
            }

            System.out.println("--------------------------------------");
        }
    }

}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.InternalUser;
import model.Item;
import model.RentRequest;
import model.RentRequestItem;
import model.RentRequestUnit;
import model.Renter;
import model.Warehouse;
import model.WarehouseType;

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
           r.full_name AS renter_name,
           w.warehouse_id,
           w.name AS warehouse_name,
           iu.internal_user_id, iu.full_name, iu.user_name
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
                rr.setRequestId(rs.getInt("request_id"));
                rr.setStatus(rs.getInt("status"));
                rr.setRequestType(rs.getString("request_type"));
                rr.setRequestDate(rs.getTimestamp("request_date"));
                rr.setProcessedDate(rs.getTimestamp("processed_date"));

                Renter renter = new Renter();
                renter.setRenterId(rs.getInt("renter_id"));
                renter.setFullName(rs.getString("renter_name"));
                rr.setRenter(renter);

                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("warehouse_name"));
                rr.setWarehouse(w);

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
               r.full_name AS renter_name,
               w.warehouse_id,
               w.name AS warehouse_name,
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
                    rr.setRequestId(rs.getInt("request_id"));
                    rr.setStatus(rs.getInt("status"));
                    rr.setRequestType(rs.getString("request_type"));
                    rr.setRequestDate(rs.getTimestamp("request_date"));
                    rr.setProcessedDate(rs.getTimestamp("processed_date"));

                    Renter renter = new Renter();
                    renter.setRenterId(rs.getInt("renter_id"));
                    renter.setFullName(rs.getString("renter_name"));
                    rr.setRenter(renter);

                    Warehouse w = new Warehouse();
                    w.setWarehouseId(rs.getInt("warehouse_id"));
                    w.setName(rs.getString("warehouse_name"));
                    rr.setWarehouse(w);

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

    public RentRequest getRentRequestDetailById(int requestId) {

        String sql = """
        SELECT rr.*,

               -- renter
               r.renter_id,
               r.user_name AS renter_username,
               r.full_name AS renter_name,
               r.email,
               r.phone,
               r.image,

               -- internal user
               iu.internal_user_id,
               iu.internal_user_code,
               iu.full_name AS internal_name,
               iu.user_name AS internal_username,

               -- warehouse
               w.warehouse_id,
               w.name AS warehouse_name,
               w.address,
               w.warehouse_type_id,

               -- request item
               rri.id AS rri_id,
               rri.quantity,
               i.item_id,
               i.item_name AS item_name,
               i.description AS item_description

        FROM rent_request rr
        JOIN renter r ON rr.renter_id = r.renter_id
        JOIN warehouse w ON rr.warehouse_id = w.warehouse_id
        LEFT JOIN internal_user iu ON rr.internal_user_id = iu.internal_user_id
        LEFT JOIN rent_request_item rri ON rr.request_id = rri.request_id
        LEFT JOIN item i ON rri.item_id = i.item_id

        WHERE rr.request_type = 'RENT'
          AND rr.request_id = ?
    """;

        RentRequest rr = null;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                // ===== INIT RENT REQUEST (chỉ làm 1 lần) =====
                if (rr == null) {
                    rr = new RentRequest();

                    rr.setRequestId(rs.getInt("request_id"));
                    rr.setRequestDate(rs.getTimestamp("request_date"));
                    rr.setStatus(rs.getInt("status"));
                    rr.setRequestType(rs.getString("request_type"));
                    rr.setProcessedDate(rs.getTimestamp("processed_date"));
                    // start_date, end_date, area chỉ lấy từ rent_request_unit (set ở dưới)

                    // ===== RENTER =====
                    Renter renter = new Renter();
                    renter.setRenterId(rs.getInt("renter_id"));
                    renter.setUsername(rs.getString("renter_username"));
                    renter.setFullName(rs.getString("renter_name"));
                    renter.setEmail(rs.getString("email"));
                    renter.setPhone(rs.getString("phone"));
                    renter.setImage(rs.getString("image"));
                    rr.setRenter(renter);

                    // ===== WAREHOUSE =====
                    Warehouse w = new Warehouse();
                    w.setWarehouseId(rs.getInt("warehouse_id"));
                    w.setName(rs.getString("warehouse_name"));
                    w.setAddress(rs.getString("address"));
                    int typeId = rs.getInt("warehouse_type_id");
                    WarehouseTypeDAO typeDAO = new WarehouseTypeDAO();
                    WarehouseType wt = typeDAO.getTypeById(typeId);

                    w.setWarehouseType(wt);

                    w.setWarehouseType(wt);
                    rr.setWarehouse(w);

                    // ===== INTERNAL USER (nullable) =====
                    int internalId = rs.getInt("internal_user_id");
                    if (!rs.wasNull()) {
                        InternalUser iu = new InternalUser();
                        iu.setInternalUserId(internalId);
                        iu.setInternalUserCode(rs.getString("internal_user_code"));
                        iu.setFullName(rs.getString("internal_name"));
                        iu.setName(rs.getString("internal_username"));
                        rr.setProcessedBy(iu);
                    }
                }

                // ===== RENT REQUEST ITEM (nhiều dòng) =====
                int rriId = rs.getInt("rri_id");
                if (!rs.wasNull()) {
                    RentRequestItem rri = new RentRequestItem();
                    rri.setId(rriId);
                    rri.setQuantity(rs.getInt("quantity"));

                    Item item = new Item();
                    item.setItemId(rs.getInt("item_id"));
                    item.setItemName(rs.getString("item_name"));
                    item.setDescription(rs.getString("item_description"));

                    rri.setItem(item);
                    rr.getItems().add(rri);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (rr != null) {
            List<RentRequestUnit> units = getUnitsByRequestId(rr.getRequestId());
            rr.setUnits(units);
        }

        return rr;
    }

    public List<RentRequestUnit> getUnitsByRequestId(int requestId) {
        List<RentRequestUnit> list = new ArrayList<>();
        String sql = "SELECT id, request_id, area, start_date, end_date, rent_price FROM rent_request_unit WHERE request_id = ? ORDER BY id";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentRequestUnit u = new RentRequestUnit();
                u.setId(rs.getInt("id"));
                u.setRequestId(rs.getInt("request_id"));
                u.setArea(rs.getDouble("area"));
                Date start = rs.getDate("start_date");
                if (start != null) u.setStartDate(start);
                Date end = rs.getDate("end_date");
                if (end != null) u.setEndDate(end);
                u.setRentPrice(rs.getDouble("rent_price"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteUnitsByRequestId(int requestId) {
        String sql = "DELETE FROM rent_request_unit WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void insertRentRequestUnit(int requestId, Date startDate, Date endDate, double area, double rentPrice) {
        String sql = "INSERT INTO rent_request_unit (request_id, area, start_date, end_date, rent_price) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.setDouble(2, area);
            ps.setDate(3, new java.sql.Date(startDate.getTime()));
            ps.setDate(4, new java.sql.Date(endDate.getTime()));
            ps.setDouble(5, rentPrice);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Inserts a new rent request (chỉ header; ngày/diện tích/giá lưu ở rent_request_unit).
     * Returns the new request_id, or -1 on failure.
     */
    public int insertRentRequest(int renterId, int warehouseId) {
        String sql = "INSERT INTO rent_request (request_date, status, request_type, renter_id, warehouse_id, internal_user_id, processed_date) VALUES (NOW(), 0, 'RENT', ?, ?, NULL, NULL)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, renterId);
            ps.setInt(2, warehouseId);
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
    
    public void deleteItemsByRequestId(int requestId) {
    String sql = "DELETE FROM rent_request_item WHERE request_id = ?";

    try (PreparedStatement st = connection.prepareStatement(sql)) {

        st.setInt(1, requestId);
        st.executeUpdate();

    } catch (SQLException e) {
        e.printStackTrace();
    }
}

    public void insertRentRequestItem(int requestId, int itemId) {
    String sql = "INSERT INTO rent_request_item(quantity, item_id, request_id) VALUES (0, ?, ?)";

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, itemId);
        ps.setInt(2, requestId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
    

}

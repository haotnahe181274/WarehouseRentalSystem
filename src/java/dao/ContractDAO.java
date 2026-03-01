package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Contract;
import model.ContractDetail;
import model.InternalUser;
import model.Renter;
import model.Warehouse;

public class ContractDAO extends DBContext {

    // =====================================================
    // CREATE CONTRACT FROM REQUEST
    // =====================================================
    public int createContracts(int requestId) {

        String sql = """
            INSERT INTO Contract
            (start_date, end_date, status, renter_id, warehouse_id, request_id, price)
            SELECT
                MIN(ru.start_date),
                MAX(ru.end_date),
                0,
                rr.renter_id,
                rr.warehouse_id,
                rr.request_id,
                SUM(ru.rent_price)
            FROM Rent_request rr
            JOIN rent_request_unit ru
                ON rr.request_id = ru.request_id
            WHERE rr.status = 1
            GROUP BY rr.request_id, rr.renter_id, rr.warehouse_id
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int rows = ps.executeUpdate();
            System.out.println(">>> Đã insert thành công " + rows + " hợp đồng từ các request có status = 1");
            return rows;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // =====================================================
    // GET ALL CONTRACTS
    // =====================================================
    public List<ContractDetail> getAllContracts() {

        List<ContractDetail> list = new ArrayList<>();

        String sql = """
            SELECT
                c.contract_id,
                c.start_date,
                c.end_date,
                c.status,
                c.price,
                r.full_name AS renter_name,
                w.name AS warehouse_name,
                iu.full_name AS manager_name
            FROM Contract c
            JOIN Renter r ON c.renter_id = r.renter_id
            JOIN Warehouse w ON c.warehouse_id = w.warehouse_id
            LEFT JOIN Rent_request rr ON c.request_id = rr.request_id
            LEFT JOIN Internal_user iu ON rr.internal_user_id = iu.internal_user_id
            ORDER BY c.contract_id DESC
        """;

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            ContractDetail c = new ContractDetail();

                ContractDetail c = new ContractDetail();

                c.setContractId(rs.getInt("contract_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setStatus(rs.getInt("status"));
                c.setPrice(rs.getDouble("price"));
                c.setRenterName(rs.getString("renter_name"));
                c.setWarehouseName(rs.getString("warehouse_name"));
                c.setManagerName(rs.getString("manager_name"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // GET CONTRACTS BY RENTER
    // =====================================================
    public List<ContractDetail> getContractsByRenter(int renterId) {

        List<ContractDetail> list = new ArrayList<>();

        String sql = """
            SELECT
                c.contract_id,
                c.start_date,
                c.end_date,
                c.price,
                c.status,
                r.full_name AS renter_name,
                r.email AS renter_email,
                r.phone AS renter_phone,
                w.name AS warehouse_name,
                w.address AS warehouse_address,
                u.full_name AS manager_name
            FROM Contract c
            LEFT JOIN Renter r ON c.renter_id = r.renter_id
            LEFT JOIN Warehouse w ON c.warehouse_id = w.warehouse_id
            LEFT JOIN Rent_request rr ON c.request_id = rr.request_id
            LEFT JOIN Internal_user u ON rr.internal_user_id = u.internal_user_id
            WHERE c.renter_id = ?
            ORDER BY c.contract_id DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, renterId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ContractDetail cd = new ContractDetail();

                // CONTRACT
                cd.setContractId(rs.getInt("contract_id"));
                cd.setStartDate(rs.getDate("start_date"));
                cd.setEndDate(rs.getDate("end_date"));
                cd.setPrice(rs.getDouble("price"));
                cd.setStatus(rs.getInt("status"));

                // RENTER
                cd.setRenterName(rs.getString("renter_name"));
                cd.setRenterEmail(rs.getString("renter_email"));
                cd.setRenterPhone(rs.getString("renter_phone"));

                // WAREHOUSE
                cd.setWarehouseName(rs.getString("warehouse_name"));
                cd.setWarehouseAddress(rs.getString("warehouse_address"));

                // MANAGER
                cd.setManagerName(rs.getString("manager_name"));

                list.add(cd);
            }

public List<ContractDetail> getContractsByRenter(int renterId) {

    List<ContractDetail> list = new ArrayList<>();

    String sql = """
        SELECT c.contract_id,
               c.start_date,
               c.end_date,
               c.price,
               c.status,

               r.full_name AS renter_name,
               r.email AS renter_email,
               r.phone AS renter_phone,

               w.name AS warehouse_name,
               w.address AS warehouse_address,

               u.full_name AS manager_name
        FROM Contract c
        LEFT JOIN Renter r ON c.renter_id = r.renter_id
        LEFT JOIN Warehouse w ON c.warehouse_id = w.warehouse_id
        LEFT JOIN Rent_request rr ON c.request_id = rr.request_id
        LEFT JOIN Internal_user u ON rr.internal_user_id = u.internal_user_id
        WHERE c.renter_id = ?
        ORDER BY c.contract_id DESC
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql)) {

        ps.setInt(1, renterId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            ContractDetail cd = new ContractDetail();

            // ===== CONTRACT =====
            cd.setContractId(rs.getInt("contract_id"));
            cd.setStartDate(rs.getDate("start_date"));
            cd.setEndDate(rs.getDate("end_date"));
            cd.setPrice(rs.getDouble("price"));
            cd.setStatus(rs.getInt("status"));

            // ===== RENTER =====
            cd.setRenterName(rs.getString("renter_name"));
            cd.setRenterEmail(rs.getString("renter_email"));
            cd.setRenterPhone(rs.getString("renter_phone"));

            // ===== WAREHOUSE =====
            cd.setWarehouseName(rs.getString("warehouse_name"));
            cd.setWarehouseAddress(rs.getString("warehouse_address"));

            // ===== MANAGER =====
            cd.setManagerName(rs.getString("manager_name"));

            list.add(cd);
        }

        return list;
    }

    // =====================================================
    // GET CONTRACT DETAIL
    // =====================================================
    public ContractDetail getContractDetail(int id) {

        String sql = """
            SELECT
                c.contract_id,
                c.start_date,
                c.end_date,
                c.status,
                c.price,
                r.full_name AS renter_name,
                r.email AS renter_email,
                r.phone AS renter_phone,
                w.name AS warehouse_name,
                w.address AS warehouse_address,
                iu.full_name AS manager_name,
                iu.email AS manager_email,
                iu.phone AS manager_phone
            FROM Contract c
            LEFT JOIN Renter r ON c.renter_id = r.renter_id
            LEFT JOIN Warehouse w ON c.warehouse_id = w.warehouse_id
            LEFT JOIN Rent_request rr ON c.request_id = rr.request_id
            LEFT JOIN Internal_user iu ON rr.internal_user_id = iu.internal_user_id
            WHERE c.contract_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                ContractDetail c = new ContractDetail();

                c.setContractId(rs.getInt("contract_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setStatus(rs.getInt("status"));
                c.setPrice(rs.getDouble("price"));

                c.setRenterName(rs.getString("renter_name"));
                c.setRenterEmail(rs.getString("renter_email"));
                c.setRenterPhone(rs.getString("renter_phone"));

                c.setWarehouseName(rs.getString("warehouse_name"));
                c.setWarehouseAddress(rs.getString("warehouse_address"));

                c.setManagerName(rs.getString("manager_name"));
                c.setManagerEmail(rs.getString("manager_email"));
                c.setManagerPhone(rs.getString("manager_phone"));

                return c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =====================================================
    // MANAGER UPDATE STATUS
    // =====================================================
    public boolean managerUpdateStatus(int contractId, int status, int managerId) {

        if (status != 1 && status != 2) {
            return false;
        }

        String sql = """
            UPDATE Rent_request rr
            JOIN Contract c ON c.request_id = rr.request_id
            SET rr.internal_user_id = ?, c.status = ?
            WHERE c.contract_id = ?
              AND c.status = 0
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, managerId);
            ps.setInt(2, status);
            ps.setInt(3, contractId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // RENTER UPDATE STATUS
    // =====================================================
    public boolean renterUpdateStatus(int contractId, int status) {

        if (status != 3 && status != 4) {
            return false;
        }

        String sql = """
            UPDATE Contract
            SET status = ?
            WHERE contract_id = ?
              AND status = 1
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, status);
            ps.setInt(2, contractId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // GET CONTRACT BY ID
    // =====================================================
    public Contract getContractById(int id) {

        String sql = "SELECT * FROM Contract WHERE contract_id = ?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return new Contract(
                        rs.getInt("contract_id"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date"),
                        rs.getInt("status"),
                        rs.getDouble("price"),
                        null,
                        null,
                        null
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =====================================================
    // CHECK VALID CONTRACT
    // =====================================================
    public int getValidContractId(int renterId, int warehouseId) {

        String sql = """
            SELECT contract_id
            FROM Contract
            WHERE renter_id = ?
              AND warehouse_id = ?
              AND status = 1
        """;

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, renterId);
            st.setInt(2, warehouseId);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt("contract_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

   public static void main(String[] args) {

    ContractDAO dao = new ContractDAO();

    System.out.println("=================================");
    System.out.println("        CONTRACT DAO TEST        ");
    System.out.println("=================================");

    /* =====================================================
       1. TEST CREATE CONTRACT FROM REQUEST
    ===================================================== */
    System.out.println("\n[1] TEST CREATE CONTRACT");

    int requestId = 1; // đổi ID tồn tại trong DB
    int rows = dao.createContracts(requestId);

    System.out.println("Rows inserted = " + rows);


    /* =====================================================
       2. TEST GET ALL CONTRACTS
    ===================================================== */
    System.out.println("\n[2] TEST GET ALL CONTRACTS");

    List<ContractDetail> contracts = dao.getAllContracts();

    for (ContractDetail c : contracts) {
        System.out.println( "ID: " + c.getContractId() + " "
                + "| Renter: " + c.getRenterName() 
                + " | Warehouse: " + c.getWarehouseName()
                + " | Price: " + c.getPrice() + " | Status: " 
                + c.getStatus()
        );
    }

    /* =====================================================
       3. TEST GET CONTRACT DETAIL
    ===================================================== */
    System.out.println("\n[3] TEST CONTRACT DETAIL");

    int contractId = 1; // sửa theo DB

    ContractDetail detail = dao.getContractDetail(contractId);

    if (detail != null) {

        System.out.println("----- CONTRACT DETAIL -----");
        System.out.println("ID: " + detail.getContractId());
        System.out.println("Start: " + detail.getStartDate());
        System.out.println("End: " + detail.getEndDate());
        System.out.println("Status: " + detail.getStatus());
        System.out.println("Price: " + detail.getPrice());

        System.out.println("\nRenter:");
        System.out.println(detail.getRenterName());
        System.out.println(detail.getRenterEmail());
        System.out.println(detail.getRenterPhone());

        System.out.println("\nWarehouse:");
        System.out.println(detail.getWarehouseName());
        System.out.println(detail.getWarehouseAddress());

        System.out.println("\nManager:");
        System.out.println(detail.getManagerName());
        System.out.println(detail.getManagerEmail());
        System.out.println(detail.getManagerPhone());

    } else {
        System.out.println("❌ Contract không tồn tại");
    }


    /* =====================================================
       4. TEST MANAGER APPROVE
    ===================================================== */
    System.out.println("\n[4] TEST MANAGER UPDATE STATUS");

    dao.managerUpdateStatus(contractId, 2, 1); // status=2, managerId=1
    System.out.println("Manager đã update status.");


    /* =====================================================
       5. TEST RENTER CONFIRM
    ===================================================== */
    System.out.println("\n[5] TEST RENTER CONFIRM");

    dao.renterUpdateStatus(contractId, 3); // ví dụ renter confirm
    System.out.println("Renter đã confirm contract.");


    /* =====================================================
       6. TEST GET CONTRACT BY ID
    ===================================================== */
    System.out.println("\n[6] TEST GET CONTRACT BY ID");

    Contract c = dao.getContractById(contractId);

    if (c != null) {
        System.out.println("Contract found:");
        System.out.println("ID: " + c.getContractId());
        System.out.println("Price: " + c.getPrice());
        System.out.println("Status: " + c.getStatus());
    } else {
        System.out.println("Không tìm thấy contract.");
    }


    /* =====================================================
       7. TEST VALID CONTRACT CHECK
    ===================================================== */
    System.out.println("\n[7] TEST VALID CONTRACT");

    int renterId = 1;
    int warehouseId = 1;

    int validId = dao.getValidContractId(renterId, warehouseId);

    if (validId != -1) {
        System.out.println("Valid Contract ID = " + validId);
    } else {
        System.out.println("Không có contract hợp lệ.");
    }

    System.out.println("\n=========== TEST DONE ==========");
}
}
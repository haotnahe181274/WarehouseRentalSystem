package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;
import java.util.Date;
import model.Contract;
import model.ContractDetail;
import model.InternalUser;
import model.RentUnit;
import model.Renter;
import model.Warehouse;

public class ContractDAO extends DBContext {

    // =====================================================
    // CREATE CONTRACT FROM REQUEST
    // =====================================================
   public int insertContractFromRequest(int requestId) {
        int newContractId = -1;

        // 1. TẠO HỢP ĐỒNG (BẢNG CONTRACT)
        String sqlContract = """
            INSERT INTO Contract
            (start_date, end_date, status, renter_id, warehouse_id, request_id, price)
            SELECT
                MIN(ru.start_date),
                MAX(ru.end_date),
                1,
                rr.renter_id,
                rr.warehouse_id,
                rr.request_id,
                SUM(ru.rent_price)
            FROM Rent_request rr
            JOIN rent_request_unit ru
                ON rr.request_id = ru.request_id
            WHERE rr.request_id = ?
            GROUP BY rr.request_id, rr.renter_id, rr.warehouse_id
        """;

        try (PreparedStatement ps = connection.prepareStatement(sqlContract, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, requestId);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                newContractId = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Lỗi tạo Contract: " + e.getMessage());
            e.printStackTrace();
            return -1; // Nếu tạo hợp đồng thất bại thì dừng luôn
        }
        return newContractId;
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
                r.full_name,
                CASE 
                    WHEN EXISTS (
                        SELECT 1
                        FROM Payment p
                        WHERE p.contract_id = c.contract_id
                        AND p.status = 1
                    )
                    THEN 1
                    ELSE 0
                END AS payment_status
            FROM Contract c
            JOIN Renter r ON c.renter_id = r.renter_id
            ORDER BY c.contract_id 
        """;

        try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            ContractDetail c = new ContractDetail();

            c.setContractId(rs.getInt("contract_id"));
            c.setStartDate(rs.getDate("start_date"));
            c.setEndDate(rs.getDate("end_date"));
            c.setStatus(rs.getInt("status"));
            c.setPrice(rs.getDouble("price"));
            c.setRenterName(rs.getString("full_name"));
            c.setPaymentStatus(rs.getInt("payment_status"));

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
                c.status,
                c.price,
                CASE 
                    WHEN EXISTS (
                        SELECT 1
                        FROM Payment p
                        WHERE p.contract_id = c.contract_id
                        AND p.status = 1
                    )
                    THEN 1
                    ELSE 0
                END AS payment_status
            FROM Contract c
            WHERE c.renter_id = ?
            ORDER BY c.contract_id 
        """;

        try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, renterId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            ContractDetail c = new ContractDetail();

            c.setContractId(rs.getInt("contract_id"));
            c.setStartDate(rs.getDate("start_date"));
            c.setEndDate(rs.getDate("end_date"));
            c.setStatus(rs.getInt("status"));
            c.setPrice(rs.getDouble("price"));
            c.setPaymentStatus(rs.getInt("payment_status"));
            list.add(c);
        }

    } catch (Exception e) {
        e.printStackTrace();
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
                    c.renter_id,
                    r.full_name AS renter_name,
                    r.email AS renter_email,
                    r.phone AS renter_phone,
                    w.name AS warehouse_name,
                    w.address AS warehouse_address,
                    iu.full_name AS manager_name,
                    iu.email AS manager_email,
                    iu.phone AS manager_phone,
            
                    rru.area,
                    rru.rent_price,
                    rru.start_date AS rent_start,
                    rru.end_date AS rent_end,
            
                    CASE 
                        WHEN EXISTS (
                            SELECT 1 
                            FROM Payment p 
                            WHERE p.contract_id = c.contract_id 
                            AND p.status = 1
                        )
                        THEN 1
                        ELSE 0
                    END AS payment_status
            
                FROM Contract c
                JOIN Renter r ON c.renter_id = r.renter_id
                JOIN Warehouse w ON c.warehouse_id = w.warehouse_id
                LEFT JOIN Rent_request rr ON c.request_id = rr.request_id
                LEFT JOIN rent_request_unit rru ON rr.request_id = rru.request_id
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
                c.setArea(rs.getDouble("area"));
                c.setRenterId(rs.getInt("renter_id"));
                c.setRenterName(rs.getString("renter_name"));
                c.setRenterEmail(rs.getString("renter_email"));
                c.setRenterPhone(rs.getString("renter_phone"));

                c.setWarehouseName(rs.getString("warehouse_name"));
                c.setWarehouseAddress(rs.getString("warehouse_address"));

                c.setManagerName(rs.getString("manager_name"));
                c.setManagerEmail(rs.getString("manager_email"));
                c.setManagerPhone(rs.getString("manager_phone"));
                c.setPaymentStatus(rs.getInt("payment_status"));
                return c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
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
                        null);
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
                    SELECT c.contract_id
                    FROM Contract c
                    JOIN Payment p ON c.contract_id = p.contract_id
                    WHERE c.renter_id = ?
                      AND c.warehouse_id = ?
                      AND p.status = 1
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
    
    public void endContractEarly(int contractId) {

        String sql = "UPDATE Contract SET status = 0 WHERE contract_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, contractId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    public void rejectContract(int contractId) {
        String sql = "UPDATE Contract SET status = 0 WHERE contract_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<RentUnit> getRentUnitsByContract(int contractId) {
        List<RentUnit> list = new ArrayList<>();

        String sql = """
            SELECT 
                rru.area,
                rru.rent_price,
                rru.start_date,
                rru.end_date,
                rru.quantity
            FROM Contract c
            JOIN Rent_request rr ON c.request_id = rr.request_id
            JOIN rent_request_unit rru ON rr.request_id = rru.request_id
            WHERE c.contract_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RentUnit u = new RentUnit();
                u.setArea(rs.getDouble("area"));
                u.setPrice(rs.getDouble("rent_price"));
                u.setStartDate(rs.getDate("start_date"));
                u.setEndDate(rs.getDate("end_date"));
                u.setQuantity(rs.getInt("quantity"));
                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * RENTER chỉ được ký & thanh toán khi:
     * - contract.status = 1, thuộc về renterId
     * - warehouse.status = 1
     * - tất cả Contract_Storage_unit của contract đều có status = 1
     * - không tồn tại Contract_Storage_unit khác (đã có Payment.status = 1) bị trùng thời gian
     *   trên cùng một unit_id với các khoảng thuê trong contract hiện tại.
     */
    public boolean canRenterAgreeAndPay(int contractId, int renterId) {
        String sql = """
            SELECT 1
            FROM Contract c
            JOIN Warehouse w ON c.warehouse_id = w.warehouse_id
            WHERE c.contract_id = ?
              AND c.renter_id = ?
              AND c.status = 1
              AND w.status = 1
              AND EXISTS (
                  SELECT 1
                  FROM Contract_Storage_unit csu0
                  WHERE csu0.contract_id = c.contract_id
              )
              AND NOT EXISTS (
                  SELECT 1
                  FROM Contract_Storage_unit csu
                  WHERE csu.contract_id = c.contract_id
                    AND csu.status <> 1
              )
              AND NOT EXISTS (
                  SELECT 1
                  FROM Contract_Storage_unit csu
                  JOIN Contract_Storage_unit csu2
                    ON csu2.unit_id = csu.unit_id
                  JOIN Payment p2
                    ON p2.contract_id = csu2.contract_id
                  WHERE csu.contract_id = c.contract_id
                    AND csu2.contract_id <> c.contract_id
                    AND p2.status = 1
                    AND NOT (
                        csu2.end_date < csu.start_date
                        OR csu2.start_date > csu.end_date
                    )
              )
            LIMIT 1
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.setInt(2, renterId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void insertContractStorageUnit(int contractId) {
    String getRequestUnitSQL = """
        SELECT rru.area, rru.start_date, rru.end_date, rru.quantity,
               c.warehouse_id
        FROM rent_request_unit rru
        JOIN Contract c ON c.request_id = rru.request_id
        WHERE c.contract_id = ?
    """;

    String findUnitSQL = """
        SELECT su.unit_id
                FROM Storage_unit su
                JOIN Warehouse w ON su.warehouse_id = w.warehouse_id
                WHERE su.warehouse_id = ?
                AND su.area = ?
                AND w.status = 1
                AND su.unit_id NOT IN (
                    SELECT csu.unit_id
                    FROM Contract_Storage_unit csu
                    JOIN Payment p ON csu.contract_id = p.contract_id
                    WHERE p.status = 1
                    AND NOT (
                        csu.end_date < ?
                        OR csu.start_date > ?
                    )
                )
                LIMIT 1
    """;

    String insertSQL = """
        INSERT INTO Contract_Storage_unit
        (contract_id, unit_id, start_date, end_date, status)
        VALUES (?, ?, ?, ?, 1)
    """;

    try {
        PreparedStatement ps1 = connection.prepareStatement(getRequestUnitSQL);
        ps1.setInt(1, contractId);
        ResultSet rs1 = ps1.executeQuery();

        while (rs1.next()) {
            double area = rs1.getDouble("area");
            Date startDate = rs1.getDate("start_date");
            Date endDate = rs1.getDate("end_date");
            int quantity = rs1.getInt("quantity");
            int warehouseId = rs1.getInt("warehouse_id");

            for (int i = 0; i < quantity; i++) {

                PreparedStatement ps2 = connection.prepareStatement(findUnitSQL);
                ps2.setInt(1, warehouseId);
                ps2.setDouble(2, area);
                ps2.setDate(3, new java.sql.Date(endDate.getTime()));
                ps2.setDate(4, new java.sql.Date(startDate.getTime()));

                ResultSet rs2 = ps2.executeQuery();

                if (rs2.next()) {
                    int unitId = rs2.getInt("unit_id");

                    PreparedStatement ps3 = connection.prepareStatement(insertSQL);
                    ps3.setInt(1, contractId);
                    ps3.setInt(2, unitId);
                    ps3.setDate(3, new java.sql.Date(startDate.getTime()));
                    ps3.setDate(4, new java.sql.Date(endDate.getTime()));
                    ps3.executeUpdate();
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM Contract";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int countExpired() {
        String sql = "SELECT COUNT(*) FROM Contract WHERE status != 0 AND end_date < NOW()";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int countDone() {
        String sql = """
            SELECT COUNT(*) FROM Contract c 
            WHERE c.status != 0 AND c.end_date >= NOW() 
            AND EXISTS (SELECT 1 FROM Payment p WHERE p.contract_id = c.contract_id AND p.status = 1)
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int countProcess() {
        String sql = """
            SELECT COUNT(*) FROM Contract c 
            WHERE c.status != 0 AND c.end_date >= NOW() 
            AND NOT EXISTS (SELECT 1 FROM Payment p WHERE p.contract_id = c.contract_id AND p.status = 1)
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
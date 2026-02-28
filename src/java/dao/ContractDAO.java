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

 public int createContracts(int requestId) {
    String sql = """
        INSERT INTO Contract (start_date, end_date, status, renter_id, warehouse_id, request_id, price)
        SELECT 
            MIN(ru.start_date),
            MAX(ru.end_date),
            0,
            rr.renter_id,
            rr.warehouse_id,
            rr.request_id,
            SUM(ru.rent_price)
        FROM Rent_request rr
        JOIN rent_request_unit ru ON rr.request_id = ru.request_id
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

    public List<Contract> getAllContracts() {

        List<Contract> list = new ArrayList<>();

        String sql = "SELECT c.*, r.full_name, w.name AS warehouse_name "
                + "FROM Contract c "
                + "JOIN Renter r ON c.renter_id = r.renter_id "
                + "JOIN Warehouse w ON c.warehouse_id = w.warehouse_id";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {

                Contract c = new Contract();
                c.setContractId(rs.getInt("contract_id"));
                c.setStartDate(rs.getTimestamp("start_date"));
                c.setEndDate(rs.getTimestamp("end_date"));
                c.setStatus(rs.getInt("status"));
                c.setPrice(rs.getDouble("price"));

                Renter renter = new Renter();
                renter.setRenterId(rs.getInt("renter_id"));
                renter.setFullName(rs.getString("full_name"));

                Warehouse warehouse = new Warehouse();
                warehouse.setWarehouseId(rs.getInt("warehouse_id"));
                warehouse.setName(rs.getString("warehouse_name"));

                c.setRenter(renter);
                c.setWarehouse(warehouse);

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }  
    
    
    // 1. LẤY CHI TIẾT HỢP ĐỒNG (Full thông tin 3 bên)
   public ContractDetail getContractByRequest(int id) {

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
        
                    w.warehouse_id,
                    w.name AS warehouse_name,
                    w.address AS warehouse_address,
        
                    iu.full_name AS manager_name,
                    iu.email AS manager_email,
                    iu.phone AS manager_phone
                FROM Contract c
        
                LEFT JOIN Renter r 
                    ON c.renter_id = r.renter_id
        
                LEFT JOIN Warehouse w 
                    ON c.warehouse_id = w.warehouse_id
        
                LEFT JOIN Rent_request ru 
                    ON c.request_id = ru.request_id
        
                LEFT JOIN Internal_user iu 
                    ON ru.internal_user_id = iu.internal_user_id
        WHERE c.contract_id = ?
    """;

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            ContractDetail cd = new ContractDetail();

            cd.setContractId(rs.getInt("contract_id"));
            cd.setStartDate(rs.getDate("start_date"));
            cd.setEndDate(rs.getDate("end_date"));
            cd.setPrice(rs.getDouble("price"));
            cd.setStatus(rs.getInt("status"));

            cd.setRenterName(rs.getString("renter_name"));
            cd.setRenterEmail(rs.getString("renter_email"));
            cd.setRenterPhone(rs.getString("renter_phone"));

            cd.setWarehouseAddress(rs.getString("address"));

            cd.setManagerName(rs.getString("manager_name"));
            cd.setManagerEmail(rs.getString("manager_email"));
            cd.setManagerPhone(rs.getString("manager_phone"));

            return cd;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

    // 2. DÀNH CHO MANAGER: Duyệt/Từ chối + Cập nhật ID Manager vào Hợp đồng
    public boolean managerUpdateStatus(int contractId, int newStatus, int managerId) {
        // Khi Manager thao tác, ta lưu luôn ID của họ vào internal_user_id
        String sql = "UPDATE Contract SET status = ?, internal_user_id = ? WHERE contract_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, newStatus);
            ps.setInt(2, managerId);
            ps.setInt(3, contractId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi managerUpdateStatus: " + e.getMessage());
        }
        return false;
    }

    // 3. DÀNH CHO RENTER: Chấp nhận ký hoặc Từ chối
    public boolean renterUpdateStatus(int contractId, int newStatus) {
        // Renter thao tác thì chỉ cần đổi trạng thái, không đổi Manager đã duyệt trước đó
        String sql = "UPDATE Contract SET status = ? WHERE contract_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, newStatus);
            ps.setInt(2, contractId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi renterUpdateStatus: " + e.getMessage());
        }
        return false;
    }

   
    
    
    

    public Contract getContractById(int id) {

        String sql = "SELECT * FROM Contract WHERE contract_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {

                Contract contract = new Contract(
                        rs.getInt("contract_id"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date"),
                        rs.getInt("status"),
                        rs.getDouble("price"),
                        null,      // renter (chưa join)
                        null,      // warehouse (chưa join)
                        null       // internal user (chưa join)
                );

                return contract;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int getValidContractId(int renterId, int warehouseId) {
        String sql = "SELECT contract_id FROM Contract WHERE renter_id = ? AND warehouse_id = ? AND status = 1";
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
    
    // Test với ID 10 - Chắc chắn sẽ ra 1 nếu DB chưa có contract 10
    int testId = 12; 
    System.out.println("Đang test tạo hợp đồng cho Request ID: " + testId);
    
    int result = dao.createContracts(testId);
    
    if(result > 0) {
        System.out.println("Thành công! Đã thêm vào bảng Contract.");
    } else {
        System.out.println("Không có dòng nào được thêm (Có thể ID đã có Contract hoặc Status chưa = 1).");
    }
}
}
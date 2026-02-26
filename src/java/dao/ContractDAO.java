package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Contract;
import model.Renter;
import model.Warehouse;

public class ContractDAO extends DBContext {

 public int createContracts(int requestId) {
    String sql = """
        INSERT INTO Contract (start_date, end_date, status, renter_id, warehouse_id, request_id, price)
        SELECT 
            MIN(ru.start_date),
            MAX(ru.end_date),
            1, -- Mặc định hợp đồng mới có status = 1
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
    
    
    
    
    
    

    public Contract getContractById(int id) {
        String sql = "SELECT * FROM Contract WHERE contractId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Contract(rs.getInt(1), rs.getDate(2), rs.getDate(3), rs.getInt(4), null, null);
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
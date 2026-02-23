package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Contract;

public class ContractDAO extends DBContext {

    public List<Contract> getAllContracts() {
        List<Contract> list = new ArrayList<>();
        String sql = "SELECT * FROM Contract";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Contract c = new Contract();

                // --- PHẦN QUAN TRỌNG NHẤT: SỬA TÊN CỘT CHO KHỚP VỚI ẢNH DB ---

                // DB là "contract_id" -> Code phải gọi "contract_id"
                c.setContractId(rs.getInt("contract_id"));

                // DB là "start_date"
                c.setStartDate(rs.getDate("start_date"));

                // DB là "end_date"
                c.setEndDate(rs.getDate("end_date"));

                // DB là "status" (giống nhau nên giữ nguyên)
                c.setStatus(rs.getInt("status"));

                try {
                    c.setPrice(rs.getDouble("price"));
                } catch (Exception e) {
                    // cột price có thể chưa tồn tại trong DB cũ
                }

                // Nếu muốn lấy cả renter_id và warehouse_id (tạm thời mình set ID giả để tránh
                // null pointer)
                // c.setRenterId(rs.getInt("renter_id"));
                // c.setWarehouseId(rs.getInt("warehouse_id"));

                list.add(c);
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getAllContracts: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public void addContract(Contract c) {
        String sql = "INSERT INTO Contract (start_date, end_date, status, price) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, new java.sql.Date(c.getStartDate().getTime()));
            st.setDate(2, new java.sql.Date(c.getEndDate().getTime()));
            st.setInt(3, c.getStatus());
            st.setDouble(4, c.getPrice());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateContract(Contract c) {
        String sql = "UPDATE Contract SET start_date=?, end_date=?, status=?, price=? WHERE contract_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, new java.sql.Date(c.getStartDate().getTime()));
            st.setDate(2, new java.sql.Date(c.getEndDate().getTime()));
            st.setInt(3, c.getStatus());
            st.setDouble(4, c.getPrice());
            st.setInt(5, c.getContractId());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
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
}
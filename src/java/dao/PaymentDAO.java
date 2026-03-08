package dao;



import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Contract;
import model.Payment;

/**
 * DAO cho bảng Payment. Lấy danh sách payment theo renter thông qua
 * Contract.renter_id.
 */
public class PaymentDAO extends DBContext {

    public int insertPayment(Payment payment) {
        String sql = "INSERT INTO Payment (amount, payment_date, method, status, contract_id) "
                + "VALUES (?, NOW(), 'VNPAY', 0, ?)";

        try {
            PreparedStatement st = connection.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS);

            st.setDouble(1, payment.getAmount());
            st.setInt(2, payment.getContract().getContractId());

            int affectedRows = st.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating payment failed, no rows affected.");
            }

            try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating payment failed, no ID obtained.");
                }
            }

        } catch (SQLException e) {
            System.out.println(e);
            return -1;
        }
    }
    
    /**
     * Lấy payment_id của giao dịch đang chờ (status=0) cho contract_id.
     * Tránh tạo nhiều bản ghi khi user double-submit hoặc bấm "Đồng ý" hai lần.
     * @return payment_id nếu có, else -1
     */
    public int getPendingPaymentIdByContractId(int contractId) {
        String sql = "SELECT payment_id FROM Payment WHERE contract_id = ? AND status = 0 ORDER BY payment_id DESC LIMIT 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, contractId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("payment_id");
            }
        } catch (Exception e) {
            System.out.println("getPendingPaymentIdByContractId: " + e.getMessage());
        }
        return -1;
    }

    public boolean updatePaymentStatus(Payment payment) {
        String sql = "UPDATE Payment "
                + "SET status = ? "
                + "WHERE payment_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setInt(1, payment.getStatus());
            st.setInt(2, payment.getPaymentId());

            return st.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println(ex);
        }

        return false;
    }

    public List<Payment> getPaymentsByRenterId(int renterId) {
        List<Payment> list = new ArrayList<>();

        String sql = """
                SELECT p.payment_id,
                       p.amount,
                       p.payment_date,
                       p.method,
                       p.status,
                       c.contract_id
                FROM Payment p
                JOIN Contract c ON p.contract_id = c.contract_id
                WHERE c.renter_id = ?
                ORDER BY p.payment_date DESC
                """;

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, renterId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentDate(rs.getTimestamp("payment_date"));
                p.setMethod(rs.getString("method"));
                p.setStatus(rs.getInt("status"));

                Contract c = new Contract();
                c.setContractId(rs.getInt("contract_id"));
                p.setContract(c);

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}

package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Contract;
import model.Payment;

/**
 * DAO cho bảng Payment.
 * Lấy danh sách payment theo renter thông qua Contract.renter_id.
 */
public class PaymentDAO extends DBContext {

    /**
     * Lấy tất cả payment của một renter.
     *
     * @param renterId id của renter (UserView.id khi type = RENTER)
     * @return danh sách payment
     */
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


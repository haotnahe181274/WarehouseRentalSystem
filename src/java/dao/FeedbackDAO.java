package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Feedback;
import model.Renter;

public class FeedbackDAO extends DBContext {

    public boolean insertFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedback (rating, comment, is_anonymous, feedback_date, renter_id, contract_id) VALUES (?, ?, ?, NOW(), ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, feedback.getRating());
            st.setString(2, feedback.getComment());
            st.setBoolean(3, feedback.isAnonymous());
            st.setInt(4, feedback.getRenter().getRenterId());
            st.setInt(5, feedback.getContract().getContractId());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Feedback> getFeedbackByWarehouseId(int warehouseId) {
        List<Feedback> list = new ArrayList<>();
        String sql = """
                SELECT f.*, r.user_name, r.full_name, r.image
                FROM Feedback f
                JOIN Contract c ON f.contract_id = c.contract_id
                JOIN Renter r ON f.renter_id = r.renter_id
                WHERE c.warehouse_id = ?
                ORDER BY f.feedback_date DESC
                """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, warehouseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackId(rs.getInt("feedback_id"));
                f.setRating(rs.getInt("rating"));
                f.setComment(rs.getString("comment"));
                f.setAnonymous(rs.getBoolean("is_anonymous"));
                f.setFeedbackDate(rs.getTimestamp("feedback_date"));

                Renter r = new Renter();
                r.setRenterId(rs.getInt("renter_id"));
                r.setUsername(rs.getString("user_name"));
                r.setFullName(rs.getString("full_name"));
                r.setImage(rs.getString("image"));

                f.setRenter(r);

                // We don't necessarily need the full Contract object here, but could set ID if
                // needed
                model.Contract c = new model.Contract();
                c.setContractId(rs.getInt("contract_id"));
                f.setContract(c);

                list.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        String sql = """
                SELECT f.*, r.user_name, r.full_name, r.image,
                       c.warehouse_id, w.name as warehouse_name
                FROM Feedback f
                JOIN Contract c ON f.contract_id = c.contract_id
                JOIN Renter r ON f.renter_id = r.renter_id
                JOIN Warehouse w ON c.warehouse_id = w.warehouse_id
                ORDER BY f.feedback_date DESC
                """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackId(rs.getInt("feedback_id"));
                f.setRating(rs.getInt("rating"));
                f.setComment(rs.getString("comment"));
                f.setAnonymous(rs.getBoolean("is_anonymous"));
                f.setFeedbackDate(rs.getTimestamp("feedback_date"));

                Renter r = new Renter();
                r.setRenterId(rs.getInt("renter_id"));
                r.setUsername(rs.getString("user_name"));
                r.setFullName(rs.getString("full_name"));
                r.setImage(rs.getString("image"));
                f.setRenter(r);

                model.Contract c = new model.Contract();
                c.setContractId(rs.getInt("contract_id"));
                model.Warehouse w = new model.Warehouse();
                w.setWarehouseId(rs.getInt("warehouse_id"));
                w.setName(rs.getString("warehouse_name"));
                c.setWarehouse(w);
                f.setContract(c);

                list.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import model.Feedback;
import model.FeedbackResponse;
import model.InternalUser;

public class FeedbackResponseDAO extends DBContext {

    public boolean insertResponse(FeedbackResponse response) {
        String sql = "INSERT INTO FeedbackResponse (response_text, response_date, feedback_id, internal_user_id) VALUES (?, NOW(), ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, response.getResponseText());
            st.setInt(2, response.getFeedback().getFeedbackId());
            st.setInt(3, response.getInternalUser().getInternalUserId());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get responses mapped by feedbackId for easy lookup in JSP
    public Map<Integer, FeedbackResponse> getResponsesByWarehouseId(int warehouseId) {
        Map<Integer, FeedbackResponse> map = new HashMap<>();
        String sql = """
                SELECT fr.*, iu.full_name as replier_name
                FROM FeedbackResponse fr
                JOIN Feedback f ON fr.feedback_id = f.feedback_id
                JOIN Contract c ON f.contract_id = c.contract_id
                JOIN InternalUser iu ON fr.internal_user_id = iu.internal_user_id
                WHERE c.warehouse_id = ?
                """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, warehouseId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                FeedbackResponse fr = new FeedbackResponse();
                fr.setResponseId(rs.getInt("response_id"));
                fr.setResponseText(rs.getString("response_text"));
                fr.setResponseDate(rs.getTimestamp("response_date"));

                Feedback f = new Feedback();
                f.setFeedbackId(rs.getInt("feedback_id"));
                fr.setFeedback(f);

                InternalUser iu = new InternalUser();
                iu.setInternalUserId(rs.getInt("internal_user_id"));
                iu.setFullName(rs.getString("replier_name"));
                fr.setInternalUser(iu);

                map.put(f.getFeedbackId(), fr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
}

package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.SupportMessage;

public class SupportMessageDAO extends DBContext {

    public boolean sendMessage(SupportMessage message) {
        String sql = "INSERT INTO Support_message "
                + "(conversation_id, sender_type, renter_id, internal_user_id, message_content, is_read, sent_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, message.getConversationId());
            st.setString(2, message.getSenderType());

            if (message.getRenterId() != null) {
                st.setInt(3, message.getRenterId());
            } else {
                st.setNull(3, java.sql.Types.INTEGER);
            }

            if (message.getInternalUserId() != null) {
                st.setInt(4, message.getInternalUserId());
            } else {
                st.setNull(4, java.sql.Types.INTEGER);
            }

            st.setString(5, message.getMessageContent());
            st.setBoolean(6, message.isIsRead());

            int result = st.executeUpdate();

            if (result > 0) {
                SupportConversationDAO conversationDAO = new SupportConversationDAO();
                conversationDAO.updateConversationTime(message.getConversationId());
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ArrayList<SupportMessage> getMessagesByConversationId(int conversationId) {
        ArrayList<SupportMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM Support_message WHERE conversation_id = ? ORDER BY sent_at ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, conversationId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapMessage(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean markMessagesAsReadByRenter(int conversationId) {
        String sql = "UPDATE Support_message "
                + "SET is_read = 1 "
                + "WHERE conversation_id = ? AND sender_type = 'INTERNAL_USER' AND is_read = 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, conversationId);
            return st.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markMessagesAsReadByInternalUser(int conversationId) {
        String sql = "UPDATE Support_message "
                + "SET is_read = 1 "
                + "WHERE conversation_id = ? AND sender_type = 'RENTER' AND is_read = 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, conversationId);
            return st.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private SupportMessage mapMessage(ResultSet rs) throws Exception {
        SupportMessage message = new SupportMessage();
        message.setMessageId(rs.getInt("message_id"));
        message.setConversationId(rs.getInt("conversation_id"));
        message.setSenderType(rs.getString("sender_type"));

        int renterId = rs.getInt("renter_id");
        if (rs.wasNull()) {
            message.setRenterId(null);
        } else {
            message.setRenterId(renterId);
        }

        int internalUserId = rs.getInt("internal_user_id");
        if (rs.wasNull()) {
            message.setInternalUserId(null);
        } else {
            message.setInternalUserId(internalUserId);
        }

        message.setMessageContent(rs.getString("message_content"));
        message.setIsRead(rs.getBoolean("is_read"));
        message.setSentAt(rs.getTimestamp("sent_at"));
        return message;
    }
}
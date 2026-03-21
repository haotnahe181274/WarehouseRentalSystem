package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import model.SupportConversation;

public class SupportConversationDAO extends DBContext {

    public int createConversation(SupportConversation conversation) {
        String sql = "INSERT INTO Support_conversation "
                + "(subject, status, renter_id, assigned_internal_user_id, request_id, contract_id, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";
        try {
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, conversation.getSubject());
            st.setString(2, conversation.getStatus());
            st.setInt(3, conversation.getRenterId());

            if (conversation.getAssignedInternalUserId() != null) {
                st.setInt(4, conversation.getAssignedInternalUserId());
            } else {
                st.setNull(4, java.sql.Types.INTEGER);
            }

            if (conversation.getRequestId() != null) {
                st.setInt(5, conversation.getRequestId());
            } else {
                st.setNull(5, java.sql.Types.INTEGER);
            }

            if (conversation.getContractId() != null) {
                st.setInt(6, conversation.getContractId());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }

            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public SupportConversation getConversationById(int conversationId) {
        String sql = "SELECT * FROM Support_conversation WHERE conversation_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, conversationId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapConversation(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public ArrayList<SupportConversation> getConversationsByRenter(int renterId) {
        ArrayList<SupportConversation> list = new ArrayList<>();
        String sql = "SELECT * FROM Support_conversation WHERE renter_id = ? ORDER BY updated_at DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, renterId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapConversation(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<SupportConversation> getConversationsByInternalUser(int internalUserId) {
        ArrayList<SupportConversation> list = new ArrayList<>();
        String sql = "SELECT * FROM Support_conversation WHERE assigned_internal_user_id = ? ORDER BY updated_at DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, internalUserId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapConversation(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<SupportConversation> getUnassignedConversations() {
        ArrayList<SupportConversation> list = new ArrayList<>();
        String sql = "SELECT * FROM Support_conversation WHERE assigned_internal_user_id IS NULL ORDER BY created_at DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapConversation(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public SupportConversation getConversationByRequestId(int requestId) {
        String sql = "SELECT * FROM Support_conversation WHERE request_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, requestId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapConversation(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean assignConversation(int conversationId, int internalUserId) {
        String sql = "UPDATE Support_conversation "
                + "SET assigned_internal_user_id = ?, status = 'IN_PROGRESS', updated_at = NOW() "
                + "WHERE conversation_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, internalUserId);
            st.setInt(2, conversationId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int conversationId, String status) {
        String sql = "UPDATE Support_conversation SET status = ?, updated_at = NOW() WHERE conversation_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, conversationId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateConversationTime(int conversationId) {
        String sql = "UPDATE Support_conversation SET updated_at = NOW() WHERE conversation_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, conversationId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private SupportConversation mapConversation(ResultSet rs) throws Exception {
        SupportConversation conversation = new SupportConversation();
        conversation.setConversationId(rs.getInt("conversation_id"));
        conversation.setSubject(rs.getString("subject"));
        conversation.setStatus(rs.getString("status"));
        conversation.setRenterId(rs.getInt("renter_id"));

        int assignedInternalUserId = rs.getInt("assigned_internal_user_id");
        if (rs.wasNull()) {
            conversation.setAssignedInternalUserId(null);
        } else {
            conversation.setAssignedInternalUserId(assignedInternalUserId);
        }

        int requestId = rs.getInt("request_id");
        if (rs.wasNull()) {
            conversation.setRequestId(null);
        } else {
            conversation.setRequestId(requestId);
        }

        int contractId = rs.getInt("contract_id");
        if (rs.wasNull()) {
            conversation.setContractId(null);
        } else {
            conversation.setContractId(contractId);
        }

        conversation.setCreatedAt(rs.getTimestamp("created_at"));
        conversation.setUpdatedAt(rs.getTimestamp("updated_at"));
        return conversation;
    }
    public SupportConversation getDefaultConversationByRenter(int renterId) {
        String sql = "SELECT * FROM Support_conversation "
                + "WHERE renter_id = ? AND request_id IS NULL AND contract_id IS NULL "
                + "ORDER BY conversation_id DESC LIMIT 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, renterId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapConversation(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createDefaultConversation(int renterId) {
        SupportConversation conversation = new SupportConversation();
        conversation.setSubject("Support Request");
        conversation.setStatus("OPEN");
        conversation.setRenterId(renterId);
        conversation.setAssignedInternalUserId(null);
        conversation.setRequestId(null);
        conversation.setContractId(null);
        return createConversation(conversation);
    }
}
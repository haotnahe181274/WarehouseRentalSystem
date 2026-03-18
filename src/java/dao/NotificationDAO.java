package dao;

import model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends DBContext {

    // 1. Insert thông báo mới
    public void insertNotification(Notification noti) {
        String sql = "INSERT INTO Notification(title, message, type, link_url, renter_id, internal_user_id) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, noti.getTitle());
            ps.setString(2, noti.getMessage());
            ps.setString(3, noti.getType());
            ps.setString(4, noti.getLinkUrl());

            if (noti.getRenterId() == 0) {
                ps.setNull(5, Types.INTEGER);
            } else {
                ps.setInt(5, noti.getRenterId());
            }

            if (noti.getInternalUserId() == 0) {
                ps.setNull(6, Types.INTEGER);
            } else {
                ps.setInt(6, noti.getInternalUserId());
            }

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 2. Lấy top thông báo mới nhất
    public List<Notification> getTopNotificationsByUser(int userId, String userType, int limit) {
        List<Notification> list = new ArrayList<>();

        String sql;

        if ("RENTER".equalsIgnoreCase(userType)) {
            sql = "SELECT * FROM Notification WHERE renter_id = ? ORDER BY created_at DESC LIMIT ?";
        } else {
            sql = "SELECT * FROM Notification WHERE internal_user_id = ? ORDER BY created_at DESC LIMIT ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Notification n = new Notification();

                n.setNotificationId(rs.getInt("notification_id"));
                n.setTitle(rs.getString("title"));
                n.setMessage(rs.getString("message"));
                n.setType(rs.getString("type"));
                n.setLinkUrl(rs.getString("link_url"));
                n.setRead(rs.getBoolean("is_read"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                n.setRenterId(rs.getInt("renter_id"));
                n.setInternalUserId(rs.getInt("internal_user_id"));

                list.add(n);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // 3. Đếm số thông báo chưa đọc
    public int getUnreadCount(int userId, String userType) {
        int count = 0;
        String sql;

        if ("RENTER".equalsIgnoreCase(userType)) {
            sql = "SELECT COUNT(*) FROM Notification WHERE renter_id = ? AND is_read = 0";
        } else {
            sql = "SELECT COUNT(*) FROM Notification WHERE internal_user_id = ? AND is_read = 0";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    // 4. Mark tất cả thông báo đã đọc
    public void markAllAsRead(int userId, String userType) {
        String sql;

        if ("RENTER".equalsIgnoreCase(userType)) {
            sql = "UPDATE Notification SET is_read = 1 WHERE renter_id = ?";
        } else {
            sql = "UPDATE Notification SET is_read = 1 WHERE internal_user_id = ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
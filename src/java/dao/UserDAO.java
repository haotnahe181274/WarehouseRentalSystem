package dao;

import model.UserView;
import java.sql.*;
import java.util.*;

public class UserDAO extends DBContext {

    public List<UserView> getAllUserViews() {

        List<UserView> list = new ArrayList<>();
        String sql = """
            SELECT 
                iu.internal_user_id as id,
                iu.user_name,
                iu.email,
                iu.full_name,
                iu.phone,
                r.role_name as role,
                'INTERNAL' as type,
                iu.status,
                iu.image,
                iu.created_at
            FROM internal_user iu
            JOIN role r ON iu.role_id = r.role_id

            UNION ALL

            SELECT 
                re.renter_id as id,
                re.user_name,
                re.email,
                re.full_name,
                re.phone,
                null as role,
                'RENTER' as type,
                re.status,
                re.image,
                re.created_at
            FROM renter re
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                UserView u = new UserView(
                        rs.getInt("id"),
                        rs.getString("user_name"),
                        rs.getString("email"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getString("type"),
                        rs.getInt("status"),
                        rs.getString("image"),
                        rs.getTimestamp("created_at")
                );
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public UserView getUserById(int id, String type) {
        String sql;
        if ("internal".equalsIgnoreCase(type)) {
            sql = """
                select iu.internal_user_id as id,
                iu.user_name,
                iu.email,
                iu.full_name,
                iu.phone,
                r.role_name as role,
                'INTERNAL' as type,
                iu.status,
                iu.image,
                iu.created_at
                from internal_user iu
                join role r on iu.role_id = r.role_id
                where iu.internal_user_id = ? 
                """;
        } else {
            sql = """
                select renter_id as id,
                user_name,
                email,
                full_name,
                phone,
                null as role,
                'Renter' as type,
                status,
                image,
                created_at
                from renter
                where renter_id = ?
                """;
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new UserView(
                        rs.getInt("id"),
                        rs.getString("user_name"),
                        rs.getString("email"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getString("type"),
                        rs.getInt("status"),
                        rs.getString("image"),
                        rs.getTimestamp("created_at")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateStatus(int id, String type, int status) {
        String sql;

        if ("INTERNAL".equalsIgnoreCase(type)) {
            sql = "UPDATE internal_user SET status = ? WHERE internal_user_id = ?";
        } else {
            sql = "UPDATE renter SET status = ? WHERE renter_id = ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void insertInternalUser(
            String username,
            String password,
            String email,
            String fullName,
            String phone,
            String image,
            int roleId) {

        String sql = """
        INSERT INTO internal_user
        (user_name, password, email, full_name, phone, role_id, status, image, created_at)
        VALUES (?, ?, ?, ?, ?, ?, 1, ?, NOW())
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, fullName);
            ps.setString(5, phone);
            ps.setInt(6, roleId);
            ps.setString(7, image);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateInternalUser(
            int id,
            String email,
            String fullName,
            String phone,
            String image,
            int roleId) {

        String sql = """
        UPDATE internal_user
        SET email = ?, full_name = ?, phone = ?, image = ?, role_id = ?
        WHERE internal_user_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, fullName);
            ps.setString(3, phone);
            ps.setString(4, image);
            ps.setInt(5, roleId);
            ps.setInt(6, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

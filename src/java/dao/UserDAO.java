package dao;

import model.UserView;
import java.sql.*;
import java.util.*;

public class UserDAO extends DBContext {

    private UserView mapUserView(ResultSet rs) throws SQLException {
        UserView u = new UserView();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setImage(rs.getString("image"));
        u.setRole(rs.getString("role"));
        u.setType(rs.getString("type"));
        u.setStatus(rs.getInt("status"));
        u.setCreatedAt(rs.getTimestamp("createdAt"));
        return u;
    }

    public UserView getUserById(int id, String type) {
        String sql;
        if ("internal".equalsIgnoreCase(type)) {
            sql = """
                select iu.internal_user_id as id,
                iu.user_name as name,
                iu.email,
                iu.full_name,
                iu.phone,
                r.role_name as role,
                'INTERNAL' as type,
                iu.status,
                iu.image,
                iu.created_at createdAt
                from internal_user iu
                join role r on iu.role_id = r.role_id
                where iu.internal_user_id = ? 
                """;
        } else {
            sql = """
                select renter_id as id,
                user_name as name,
                email,
                full_name,
                phone,
                null as role,
                'Renter' as type,
                status,
                image,
                created_at as createdAt
                from renter
                where renter_id = ?
                """;
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserView(rs);
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

    public List<UserView> filterUsersPaging(
            String keyword,
            String status,
            String type,
            String sort,
            int offset,
            int pageSize) {
        List<UserView> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "select * from ( "
                + "select iu.internal_user_id as id, iu.user_name as name, iu.email, "
                + "iu.full_name, iu.phone, iu.image, r.role_name as role, "
                + "'INTERNAL' as type, iu.status, iu.created_at as createdAt "
                + "from internal_user iu "
                + "join role r on iu.role_id = r.role_id "
                + "union all "
                + "select re.renter_id as id, re.user_name as name, re.email, "
                + "re.full_name, re.phone, re.image, null as role, "
                + "'RENTER' as type, re.status, re.created_at as createdAt "
                + "from renter re "
                + ") u where 1=1 "
        );

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" and u.name like ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" and u.status = ?");
        }
        if (type != null && !type.isEmpty()) {
            sql.append(" and u.type = ?");
        }
        if ("asc".equalsIgnoreCase(sort)) {
            sql.append(" order by u.name asc");
        } else if ("desc".equalsIgnoreCase(sort)) {
            sql.append(" order by u.name desc");
        }
        sql.append(" LIMIT ? OFFSET ? ");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int i = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setInt(i++, Integer.parseInt(status));
            }
            if (type != null && !type.isEmpty()) {
                ps.setString(i++, type);
            }
            ps.setInt(i++, pageSize);
            ps.setInt(i++, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUserView(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countFilterUsers(
            String keyword,
            String status,
            String type) {
        StringBuilder sql = new StringBuilder(
                "select count(*) from ( "
                + "select iu.internal_user_id as id, iu.user_name as name, iu.status, 'INTERNAL' as type "
                + "from internal_user iu "
                + "union all "
                + "select re.renter_id as id, re.user_name as name, re.status, 'RENTER' as type "
                + "from renter re "
                + ") u where 1 = 1 "
        );
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" and u.name like ? ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" and u.status = ? ");
        }
        if (type != null && !type.isEmpty()) {
            sql.append(" and u.type = ? ");
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int i = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setInt(i++, Integer.parseInt(status));
            }
            if (type != null && !type.isEmpty()) {
                ps.setString(i++, type);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean isUsernameExists(String username) {
        String sql = "select 1 from internal_user where user_name= ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

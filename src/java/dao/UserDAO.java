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
        if ("INTERNAL".equalsIgnoreCase(u.getType())) {
            u.setIdCard(rs.getString("id_card"));
            u.setAddress(rs.getString("address"));
            u.setInternalUserCode(rs.getString("internal_user_code"));
        }
        return u;
    }

    public UserView getUserById(int id, String type) {
        String sql = null;
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
                    iu.created_at createdAt,
                    iu.id_card,
                    iu.address,
                    iu.internal_user_code
                    from internal_user iu
                    join role r on iu.role_id = r.role_id
                    where iu.internal_user_id = ?
                    """;
        } else if ("renter".equalsIgnoreCase(type)) {
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
            int roleId,
            String internalUserCode,
            String idCard,
            String address) {

        String sql = """
                    INSERT INTO internal_user
                    (user_name, password, email, full_name, phone, role_id, status, image, created_at, internal_user_code, id_card, address)
                    VALUES (?, ?, ?, ?, ?, ?, 1, ?, NOW(), ?, ?, ?)
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, fullName);
            ps.setString(5, phone);
            ps.setInt(6, roleId);
            ps.setString(7, image);
            ps.setString(8, internalUserCode);
            ps.setString(9, idCard);
            ps.setString(10, address);
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
            int roleId,
            String idCard,
            String address) {

        String sql = """
                    UPDATE internal_user
                    SET email = ?, full_name = ?, phone = ?, image = ?, role_id = ?, id_card = ?, address = ?
                    WHERE internal_user_id = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, fullName);
            ps.setString(3, phone);
            ps.setString(4, image);
            ps.setInt(5, roleId);
            ps.setString(6, idCard);
            ps.setString(7, address);
            ps.setInt(8, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<UserView> getAllUsers(String viewerRole, Integer excludeId, String excludeType,
            String filterType, Integer filterStatus, String filterRole) {
        List<UserView> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "select * from ( "
                        + "select iu.internal_user_id as id, iu.user_name as name, iu.email, "
                        + "iu.full_name, iu.phone, iu.image, r.role_name as role, "
                        + "'INTERNAL' as type, iu.status, iu.created_at as createdAt, "
                        + "iu.id_card, iu.address, iu.internal_user_code "
                        + "from internal_user iu "
                        + "join role r on iu.role_id = r.role_id "
                        + "union all "
                        + "select re.renter_id as id, re.user_name as name, re.email, "
                        + "re.full_name, re.phone, re.image, null as role, "
                        + "'RENTER' as type, re.status, re.created_at as createdAt, "
                        + "null as id_card, null as address, null as internal_user_code "
                        + "from renter re "
                        + ") u where 1=1 ");

        List<Object> params = new ArrayList<>();

        if ("Manager".equals(viewerRole)) {
            sql.append(" AND (u.role = 'Staff' OR u.type = 'RENTER') ");
        }

        if (excludeId != null && excludeType != null) {
            sql.append(" AND NOT (u.id = ? AND u.type = ?) ");
            params.add(excludeId);
            params.add(excludeType);
        }

        if (filterType != null && !filterType.isEmpty()) {
            sql.append(" AND u.type = ? ");
            params.add(filterType);
        }

        if (filterStatus != null) {
            sql.append(" AND u.status = ? ");
            params.add(filterStatus);
        }

        // Role filter applies only if filtering by INTERNAL or it matches one of the
        // internal
        // roles.
        // If filterType is RENTER, role filter shouldn't match anything usually, but
        // sql handles
        // it.
        if (filterRole != null && !filterRole.isEmpty()) {
            sql.append(" AND u.role = ? ");
            params.add(filterRole);
        }

        sql.append(" ORDER BY u.name ASC ");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUserView(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
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

    public void updateProfile(UserView u) {
        String sql;
        if ("INTERNAL".equals(u.getType())) {
            sql = """
                    update internal_user
                    set email = ?, full_name = ?, phone = ?, image = ?, id_card = ?, address = ?
                    where internal_user_id = ?
                    """;
        } else {
            sql = """
                    update renter
                    set email = ?, full_name = ?, phone = ?, image = ?
                    where renter_id = ?
                    """;
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getEmail());
            ps.setString(2, u.getFullName());
            ps.setString(3, u.getPhone());
            ps.setString(4, u.getImage());

            if ("INTERNAL".equals(u.getType())) {
                ps.setString(5, u.getIdCard());
                ps.setString(6, u.getAddress());
                ps.setInt(7, u.getId());
            } else {
                ps.setInt(5, u.getId());
            }

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public boolean changePassword(int id, String type, String newPassword) {
        String sql;
        if ("INTERNAL".equals(type)) {
            sql = "update internal_user set password = ? where internal_user_id = ?";
        } else {
            sql = "update renter set password = ? where renter_id = ?";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public UserView checkAuthen(String username, String password) {
        String sql = """
                select * from (
                    select
                        iu.internal_user_id as id,
                        iu.user_name as name,
                        iu.email,
                        iu.full_name,
                        iu.phone,
                        r.role_name as role,
                        'INTERNAL' as type,
                        iu.status,
                        iu.image,
                        iu.created_at as createdAt,
                                 iu.id_card,
                                                     iu.address,
                                                     iu.internal_user_code
                    from internal_user iu
                    join role r on iu.role_id = r.role_id
                    where iu.user_name = ? and iu.password = ?

                    union all

                    select
                        re.renter_id as id,
                        re.user_name as name,
                        re.email,
                        re.full_name,
                        re.phone,
                        null as role,
                        'RENTER' as type,
                        re.status,
                        re.image,
                        re.created_at as createdAt,
                        null as id_card,
                        null as address,
                        null as internal_user_code
                    from renter re
                    where re.user_name = ? and re.password = ?
                ) u
                where u.status = 1
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, username);
            ps.setString(4, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserView(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isRenterUsernameExists(String username) {
        String sql = "select 1 from renter where user_name= ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isRenterEmailExists(String email) {
        String sql = "select 1 from renter where email= ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insertRenter(String username, String password, String fullName, String email, String phone) {
        String sql = "INSERT INTO renter (user_name, password, full_name, email, phone, status, created_at) VALUES (?, ?, ?, ?, ?, 1, NOW())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, fullName);
            ps.setString(4, email);
            ps.setString(5, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

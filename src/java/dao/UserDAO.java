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
        try(PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
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
        }catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }
}

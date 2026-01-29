/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;


import java.util.ArrayList;
import java.util.List;
import model.UserView;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


/**
 *
 * @author hao23
 */
public class InternalUserDAO extends DBContext{
    public List<UserView> getUserViews() {
        List<UserView> list = new ArrayList<>();
        String sql = """
            SELECT iu.internal_user_id,
                   iu.user_name,
                   iu.email,
                   iu.full_name,
                   iu.phone,
                   r.role_name,
                   iu.status,
                   iu.image,
                   iu.created_at
            FROM internal_user iu
            JOIN role r ON iu.role_id = r.role_id
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new UserView(
                        rs.getInt("internal_user_id"),
                        rs.getString("user_name"),
                        rs.getString("email"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("role_name"),
                        "INTERNAL",
                        rs.getInt("status"),
                        rs.getString("image"),
                        rs.getTimestamp("created_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public void updateStatus(int id, int status){
        String sql = "update internal_user set status = ? where internal_user_id = ?";
        try(PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void insertInternalUser(String username, String password, String email, String fullName, String phone, String image, int roleId){
        String sql = """
                     insert into internal_user(user_name, password, email, full_name, phone, role_id, status, image, created_at)
                     values (?, ?, ?, ?, ?, ?, 1, ?, NOw())
                     """;
        try(PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, fullName);
            ps.setString(5, phone);
            ps.setInt(6, roleId);
            ps.setString(7, image);
            ps.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();    
        }
    }
    
    public void updateInternalUser(int id, String email, String fullName, String phone, String image, int roleId){
        String sql = """
                     update internal_user
                     set email = ?, full_name = ?, phone = ?, image = ?, role_id = ? 
                     where internal_user_id = ?
                     """;
        try(PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setString(1, email);
            ps.setString(2, fullName);
            ps.setString(3, phone);
            ps.setString(4, image);
            ps.setInt(5, roleId);
            ps.setInt(6, id);
            ps.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }     
    }
}

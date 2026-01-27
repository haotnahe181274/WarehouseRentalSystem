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
public class RenterDAO extends DBContext {

    public List<UserView> getUserViews() {
        List<UserView> list = new ArrayList<>();
        String sql = """
        SELECT renter_id,
               user_name,
               email,
               full_name,
               phone,
               status,
               image,
               created_at
        FROM renter
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new UserView(
                        rs.getInt("renter_id"),
                        rs.getString("user_name"),
                        rs.getString("email"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        "Renter",
                        "RENTER",
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
        String sql = "update renter set status = ? where renter_id = ?";
        try(PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}

package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Warehouse;
import model.WarehouseType;

public class WarehouseDAO extends DBContext {

    public List<Warehouse> getAll() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT * FROM Warehouse";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouseId"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setDescription(rs.getString("description"));
                w.setStatus(rs.getInt("status"));
                // Chú ý: Cần xử lý lấy WarehouseType từ ID tương ứng nếu cần
                list.add(w);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Warehouse w) {
        String sql = "INSERT INTO Warehouse (name, address, description, status) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, w.getName());
            st.setString(2, w.getAddress());
            st.setString(3, w.getDescription());
            st.setInt(4, w.getStatus());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Warehouse WHERE warehouseId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
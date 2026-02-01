    package dao;

    import java.sql.Connection;
    import java.sql.PreparedStatement;
    import java.sql.ResultSet;
    import java.util.ArrayList;
    import java.util.List;
    import model.Warehouse;

    public class WarehouseDAO extends DBContext {

        public WarehouseDAO() {
            super();
        }

        public List<Warehouse> getAll() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT * FROM warehouse";

        try {
            System.out.println("=== DAO TEST ===");
            System.out.println("Connection = " + connection);

            if (connection == null) {
                System.out.println("❌ CONNECTION NULL");
                return list;
            }

            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWarehouseId(rs.getInt("warehouseId"));
                w.setName(rs.getString("name"));
                list.add(w);
            }

            System.out.println("✅ DAO size = " + list.size());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


        public void insert(Warehouse w) {
            String sql = "INSERT INTO warehouse (name, address, description, status) VALUES (?, ?, ?, ?)";

            try {
                PreparedStatement st = connection.prepareStatement(sql);
                st.setString(1, w.getName());
                st.setString(2, w.getAddress());
                st.setString(3, w.getDescription());
                st.setInt(4, w.getStatus());
                st.executeUpdate();
                st.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        public void delete(int id) {
            String sql = "DELETE FROM warehouse WHERE warehouseId = ?";

            try {
                PreparedStatement st = connection.prepareStatement(sql);
                st.setInt(1, id);
                st.executeUpdate();
                st.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

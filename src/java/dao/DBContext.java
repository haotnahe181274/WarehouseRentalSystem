package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

<<<<<<< Updated upstream
    protected Connection connection;
=======
    public Connection connection; // cho lớp con dùng
>>>>>>> Stashed changes

    public DBContext() {
        try {
            String url = "jdbc:mysql://localhost:3306/wrs?useSSL=false&serverTimezone=UTC";
            String user = "root1";
            String password = "123456";

            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, user, password);

<<<<<<< Updated upstream
            System.out.println("Connected DB = " + connection.getCatalog());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


=======
            System.out.println("Kết nối MySQL thành công!");
        } catch (Exception e) {
            System.out.println("Lỗi kết nối DB:");
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        
        DBContext testContext = new DBContext();

        if (testContext.connection != null) {
            try {
                String catalog = testContext.connection.getCatalog();
                System.out.println("Đã kết nối tới Schema: " + catalog);
                System.out.println("Trạng thái: Sẵn sàng hoạt động!");

                testContext.connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Kết nối thất bại (connection = null).");
        }
    }
}
>>>>>>> Stashed changes

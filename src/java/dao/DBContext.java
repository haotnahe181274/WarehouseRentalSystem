/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author hao23
 */
public class DBContext {
    protected Connection connection; // Khai báo biến để lớp con dùng được

    public DBContext() {
        try {
            String url = "jdbc:mysql://localhost:3306/wrs?useSSL=false&serverTimezone=UTC";
            String user = "root";
            String password = "123456";
            Class.forName("com.mysql.cj.jdbc.Driver"); // Thêm dòng này để nạp Driver
            connection = DriverManager.getConnection(url, user, password);
            System.out.println("Kết nối MySQL thành công!");
        } catch (Exception e) {
            System.out.println("Lỗi kết nối DB: " );
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
    DBContext testContext = new DBContext();
    if (testContext.connection != null) {
        try {
            // Kiểm tra thông tin database đang kết nối
            String catalog = testContext.connection.getCatalog();
            System.out.println("Đã kết nối tới Schema: " + catalog);
            System.out.println("Trạng thái: Sẵn sàng hoạt động!");
            
            // Đóng kết nối sau khi test xong
            testContext.connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        System.out.println("Kết nối thất bại (biến connection bị null).");
    }
}
    
}
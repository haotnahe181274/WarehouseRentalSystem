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
            e.printStackTrace();
        }
    }
}
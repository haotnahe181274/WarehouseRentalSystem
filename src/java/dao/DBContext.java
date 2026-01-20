/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author hao23
 */
public class DBContext {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            String url = "jdbc:mysql://localhost:3306/w?useSSL=false&serverTimezone=UTC";
            String user = "root";
            String password = "123456";

            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Kết nối MySQL thành công!");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
    public static void main(String[] args) {
        Connection conn = DBContext.getConnection();
        if (conn != null) {
            System.out.println("Kết nối OK");
        }
    }
}

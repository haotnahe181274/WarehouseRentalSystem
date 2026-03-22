package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardDAO extends DBContext {

    public int getTotalUsers() {
        int total = 0;
        String sql = "SELECT (SELECT COUNT(*) FROM Renter) + (SELECT COUNT(*) FROM Internal_user) AS total";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getTotalUsers: " + e.getMessage());
        }
        return total;
    }

    public int getActiveWarehouses() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Warehouse WHERE status = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getActiveWarehouses: " + e.getMessage());
        }
        return count;
    }

    public int getTotalWarehouses() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Warehouse";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getTotalWarehouses: " + e.getMessage());
        }
        return count;
    }

    public int getTotalBookings() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Rent_request";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getTotalBookings: " + e.getMessage());
        }
        return count;
    }

    public double getMonthlyRevenue() {
        double revenue = 0;
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM Payment " +
                     "WHERE status = 1 AND MONTH(payment_date) = MONTH(CURRENT_DATE()) " +
                     "AND YEAR(payment_date) = YEAR(CURRENT_DATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                revenue = rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getMonthlyRevenue: " + e.getMessage());
        }
        return revenue;
    }

    public int getPendingTasks(int staffId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Staff_assignment WHERE assigned_to = ? AND completed_at IS NULL";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, staffId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getPendingTasks: " + e.getMessage());
        }
        return count;
    }

    public int getCompletedTasks(int staffId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Staff_assignment WHERE assigned_to = ? AND completed_at IS NOT NULL";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, staffId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getCompletedTasks: " + e.getMessage());
        }
        return count;
    }

    // ==========================================
    // CÁC HÀM XỬ LÝ BIỂU ĐỒ (CHARTS) ĐÃ FIX LỖI 1 CỘT
    // ==========================================

    public Map<String, Double> getRevenueByMonth() {
        Map<String, Double> data = new LinkedHashMap<>();
        // Khởi tạo mặc định 12 tháng với doanh thu = 0
        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        for (String month : months) {
            data.put(month, 0.0);
        }

        String sql = "SELECT DATE_FORMAT(payment_date, '%b') as month_label, COALESCE(SUM(amount), 0) as total_revenue " +
                     "FROM Payment " +
                     "WHERE status = 1 AND YEAR(payment_date) = YEAR(CURRENT_DATE()) " +
                     "GROUP BY MONTH(payment_date), DATE_FORMAT(payment_date, '%b')";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                String monthLabel = rs.getString("month_label");
                if (data.containsKey(monthLabel)) {
                    data.put(monthLabel, rs.getDouble("total_revenue")); // Đè số liệu thật lên tháng tương ứng
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getRevenueByMonth: " + e.getMessage());
        }
        return data;
    }

    public Map<String, Integer> getBookingsByMonth() {
        Map<String, Integer> data = new LinkedHashMap<>();
        // Khởi tạo mặc định 12 tháng với số booking = 0
        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        for (String month : months) {
            data.put(month, 0);
        }

        String sql = "SELECT DATE_FORMAT(request_date, '%b') as month_label, COUNT(*) as count " +
                     "FROM Rent_request " +
                     "WHERE YEAR(request_date) = YEAR(CURRENT_DATE()) " +
                     "GROUP BY MONTH(request_date), DATE_FORMAT(request_date, '%b')";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                String monthLabel = rs.getString("month_label");
                if (data.containsKey(monthLabel)) {
                    data.put(monthLabel, rs.getInt("count")); // Đè số liệu thật lên tháng tương ứng
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getBookingsByMonth: " + e.getMessage());
        }
        return data;
    }
}
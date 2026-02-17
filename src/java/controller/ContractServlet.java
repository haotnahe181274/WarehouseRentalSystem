package controller;

import dao.ContractDAO;
import model.Contract;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ContractServlet", urlPatterns = {"/contract"})
public class ContractServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ContractDAO dao = new ContractDAO();

        if (action == null) {
            // Hiển thị danh sách
            List<Contract> list = dao.getAllContracts();
            request.setAttribute("listC", list);
            request.getRequestDispatcher("Management/Contract-list.jsp").forward(request, response);
        } else if (action.equals("edit")) {
            // Chuyển sang trang sửa
            int id = Integer.parseInt(request.getParameter("id"));
            Contract c = dao.getContractById(id);
            request.setAttribute("contract", c);
            request.getRequestDispatcher("contract-form.jsp").forward(request, response);
        } else if (action.equals("add")) {
            // Chuyển sang trang thêm mới
            request.getRequestDispatcher("contract-form.jsp").forward(request, response);
        }
    }

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        ContractDAO dao = new ContractDAO();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        // Lấy dữ liệu dạng String trước
        String idStr = request.getParameter("contractId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String statusStr = request.getParameter("status");

        // Validate dữ liệu cơ bản
        if (startDateStr == null || endDateStr == null || statusStr == null) {
            // Nếu thiếu dữ liệu, quay lại form (có thể thêm thông báo lỗi)
            response.sendRedirect("contract?action=add"); 
            return;
        }

        java.util.Date start = sdf.parse(startDateStr);
        java.util.Date end = sdf.parse(endDateStr);
        int status = Integer.parseInt(statusStr);
        String priceStr = request.getParameter("price");
        double price = 0;
        if (priceStr != null && !priceStr.isEmpty()) {
            price = Double.parseDouble(priceStr);
        }

        // Giả sử Renter và Warehouse có ID là 1 để test (Bạn cần lấy từ form dropdown)
        // Nếu DB cho phép null thì để null, nếu không phải set giá trị giả
        // model.Renter r = new model.Renter(); r.setRenterId(1); 
        
        if (idStr == null || idStr.isEmpty()) {
            // Add new
            // Lưu ý: Kiểm tra xem DB có cho phép Renter/Warehouse null không
            Contract c = new Contract(0, start, end, status, null, null);
            c.setPrice(price);
            dao.addContract(c);
        } else {
            // Update
            int id = Integer.parseInt(idStr);
            Contract c = new Contract(id, start, end, status, null, null);
            c.setPrice(price);
            dao.updateContract(c);
        }
        
        // Thành công thì về trang danh sách
        response.sendRedirect("contract");
        
    } catch (java.text.ParseException e) {
        System.out.println("Lỗi định dạng ngày tháng: " + e.getMessage());
        // Có thể forward lại trang form với thông báo lỗi
    } catch (Exception e) {
        e.printStackTrace();
        // Chuyển hướng đến trang lỗi nếu cần
    }
}
}
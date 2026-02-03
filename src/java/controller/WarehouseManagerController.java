package controller;

import dao.WarehouseManagementDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Warehouse;

@WebServlet(name = "WarehouseController", urlPatterns = {"/warehouse"})
public class WarehouseManagerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        WarehouseManagementDAO dao = new WarehouseManagementDAO();
        String action = request.getParameter("action");

        // Xử lý xóa
        if (action != null && action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
        }

        // Lấy danh sách hiển thị
        List<Warehouse> list = dao.getAll();
        request.setAttribute("data", list);
        request.getRequestDispatcher("Management/warehouse.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý thêm mới Warehouse
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String desc = request.getParameter("description");
        int status = Integer.parseInt(request.getParameter("status"));

        Warehouse w = new Warehouse(0, name, address, desc, status, null);
        WarehouseManagementDAO dao = new WarehouseManagementDAO();
        dao.insert(w);

        response.sendRedirect("warehouse");
    }
}
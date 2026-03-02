package controller;

import dao.AssignmentDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.InternalUser;
import model.UserView;
import model.Warehouse;

@WebServlet(name = "AutoAssignServlet", urlPatterns = {"/Management/autoAssign"})
public class AutoAssignServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
         HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        AssignmentDAO dao = new AssignmentDAO();
        List<Warehouse> warehouseList = dao.getActiveWarehouses();
        request.setAttribute("listWarehouse", warehouseList);
        
        request.getRequestDispatcher("/Management/assignment-board.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            HttpSession session = request.getSession();
            UserView  loginUser = (UserView ) session.getAttribute("user");
            int assignedBy = loginUser.getId();
            
            int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
            int assignmentType = Integer.parseInt(request.getParameter("assignmentType"));
            String description = request.getParameter("description");
            int dueDays = Integer.parseInt(request.getParameter("dueDays"));
            
            String unitIdStr = request.getParameter("unitId");
            Integer unitId = null; 
            if (unitIdStr != null && !unitIdStr.trim().isEmpty()) {
                unitId = Integer.parseInt(unitIdStr);
            }
            
            AssignmentDAO dao = new AssignmentDAO();
            boolean isSuccess = dao.createAutoAssignment(warehouseId, unitId, assignedBy, assignmentType, description, dueDays);
            
            if (isSuccess) {
                request.setAttribute("MSG_SUCCESS", "Thành công: Nhiệm vụ đã được tự động giao cho nhân viên phù hợp nhất tại khu vực kho!");
            } else {
                request.setAttribute("MSG_ERROR", "Thất bại: Không tìm thấy nhân viên khả dụng nào đang làm việc tại khu vực này.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("MSG_ERROR", "Lỗi hệ thống: " + e.getMessage());
        }
        doGet(request, response);
    }
}
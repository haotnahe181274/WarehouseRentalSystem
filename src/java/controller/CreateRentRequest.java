/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ItemDAO;
import dao.RentRequestDAO;
import dao.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.RentRequest;
import model.UserView;
import model.Warehouse;

/**
 *
 * @author ad
 */
@WebServlet(name = "CreateRentRequest", urlPatterns = {"/createRentRequest"})
public class CreateRentRequest extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateRentRequest</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateRentRequest at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        WarehouseDAO dao = new WarehouseDAO();
        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect("homepage");
            return;
        }
        int id = Integer.parseInt(idRaw);
        Warehouse w = dao.findById(id);
        if (w == null) {
            response.sendRedirect("homepage");
            return;
        }
        RentRequest rr = new RentRequest();
        rr.setWarehouse(w);
        request.setAttribute("rr", rr);
        request.setAttribute("mode", "create");
        request.getRequestDispatcher("Rental/rentalDetail.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method. Creates a new rent request.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView user = (UserView) session.getAttribute("user");
        if (!"RENTER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/homepage");
            return;
        }

        String warehouseIdStr = request.getParameter("warehouseId");
        String[] startDates = request.getParameterValues("unitStartDate");
        String[] endDates = request.getParameterValues("unitEndDate");
        String[] areas = request.getParameterValues("unitArea");
        String[] prices = request.getParameterValues("unitPrice");
        String[] names = request.getParameterValues("itemName");
        String[] descriptions = request.getParameterValues("description");

        int warehouseId = Integer.parseInt(warehouseIdStr);
        if (startDates == null || endDates == null || areas == null || prices == null
                || startDates.length == 0 || endDates.length == 0 || areas.length == 0 || prices.length == 0) {
            response.sendRedirect(request.getContextPath() + "/createRentRequest?id=" + warehouseId);
            return;
        }

        int renterId = user.getId();
        RentRequestDAO rrDao = new RentRequestDAO();
        ItemDAO itemDao = new ItemDAO();

        int newRequestId = rrDao.insertRentRequest(renterId, warehouseId);

        for (int i = 0; i < startDates.length; i++) {
            try {
                java.sql.Date sd = java.sql.Date.valueOf(startDates[i].trim());
                java.sql.Date ed = java.sql.Date.valueOf(endDates[i].trim());
                double a = Double.parseDouble(areas[i].trim());
                double pr = Double.parseDouble(prices[i].trim());
                rrDao.insertRentRequestUnit(newRequestId, sd, ed, a, pr);
            } catch (IllegalArgumentException ignored) {
            }
        }

        if (names != null) {
            for (int i = 0; i < names.length; i++) {
                if (names[i] == null || names[i].trim().isEmpty()) continue;
                String desc = (descriptions != null && i < descriptions.length) ? descriptions[i] : "";
                int itemId = itemDao.insertItem(names[i].trim(), desc, renterId);
                rrDao.insertRentRequestItem(newRequestId, itemId);
            }
        }

        response.sendRedirect(request.getContextPath() + "/rentDetail?id=" + newRequestId);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

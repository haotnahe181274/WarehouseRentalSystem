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
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.RentRequest;
import model.Renter;
import model.UserView;

/**
 *
 * @author ad
 */
@WebServlet(name = "RentRequestDetail", urlPatterns = {"/rentDetail"})
public class RentRequestDetail extends HttpServlet {

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
            out.println("<title>Servlet RentRequestDetail</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RentRequestDetail at " + request.getContextPath() + "</h1>");
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

        RentRequestDAO dao = new RentRequestDAO();
        WarehouseDAO da = new WarehouseDAO();

        String idRaw = request.getParameter("id");

        if (idRaw == null) {
            response.sendRedirect("rentList");
            return;
        }

        int requestId = Integer.parseInt(idRaw);

        RentRequest rr = dao.getRentRequestDetailById(requestId);
        if (rr == null) {
            response.sendRedirect("rentList");
            return;
        }
        String action = request.getParameter("action");
        String mode = "edit".equals(action) ? "edit" : "view";

        int warehouseId = rr.getWarehouse().getWarehouseId();
        List<Double> areaList = da.getAvailableAreasByWarehouse(warehouseId, rr.getStartDate(), rr.getEndDate());
        Map<Double, Double> areaPriceMap = new LinkedHashMap<>();
        for (Double a : areaList) {
            areaPriceMap.put(a, da.getPriceByArea(warehouseId, a));
        }
        double price = da.getPriceByArea(warehouseId, rr.getArea());

        request.setAttribute("areaPriceMap", areaPriceMap);
        request.setAttribute("price", price);
        request.setAttribute("mode", mode);
        request.setAttribute("rr", rr);
        request.setAttribute("areaList", areaList);

        request.getRequestDispatcher("Rental/rentalDetail.jsp")
                .forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        double area = Double.parseDouble(request.getParameter("area"));
        String[] names = request.getParameterValues("itemName");
        String[] descriptions = request.getParameterValues("description");

        RentRequestDAO dao = new RentRequestDAO();
        ItemDAO itemDao = new ItemDAO();
        RentRequest x = dao.getRentRequestDetailById(requestId);
        if (x == null) {
            response.sendRedirect(request.getContextPath() + "/rentList");
            return;
        }
        int renterId = x.getRenter().getRenterId();

        java.util.Date startDate = x.getStartDate();
        java.util.Date endDate = x.getEndDate();
        String startStr = request.getParameter("startDate");
        String endStr = request.getParameter("endDate");
        if (startStr != null && !startStr.isEmpty() && endStr != null && !endStr.isEmpty()) {
            try {
                startDate = java.sql.Date.valueOf(startStr);
                endDate = java.sql.Date.valueOf(endStr);
            } catch (IllegalArgumentException ignored) { }
        }
        dao.updateRentRequestDatesAndArea(requestId, startDate, endDate, area);

        dao.deleteItemsByRequestId(requestId);

        if (names != null) {
        for (int i = 0; i < names.length; i++) {
            if (names[i] == null || names[i].trim().isEmpty()) continue;
            String desc = (descriptions != null && i < descriptions.length) ? descriptions[i] : "";
            int itemId = itemDao.insertItem(names[i].trim(), desc != null ? desc : "", renterId);
            dao.insertRentRequestItem(requestId, itemId);
        }
        }

        response.sendRedirect(request.getContextPath()
                + "/rentDetail?id=" + requestId);
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

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
import java.util.Arrays;
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
        List<Double> areaList = da.getAvailableAreasByWarehouse(
                rr.getWarehouse().getWarehouseId(),
                rr.getStartDate(),
                rr.getEndDate()
        );
        String action = request.getParameter("action");

        String mode = "view";

        if ("edit".equals(action)) {
            mode = "edit";
        }

        Map<Double, Double> areaPriceMap = new LinkedHashMap<>();

        for (Double a : areaList) {
            double p = da.getPriceByArea(rr.getWarehouse().getWarehouseId(), a);
            areaPriceMap.put(a, p);
        }

        request.setAttribute("areaPriceMap", areaPriceMap);
        double price = da.getPriceByArea(rr.getWarehouse().getWarehouseId(), rr.getArea());
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
        ItemDAO da = new ItemDAO();
        RentRequest x = dao.getRentRequestDetailById(requestId);
        int renterId = x.getRenter().getRenterId();

        dao.updateRentRequest(requestId, area);

// 1. delete all old items
        dao.deleteItemsByRequestId(requestId);

// 2. insert lại
        for (int i = 0; i < names.length; i++) {

            if (names[i] == null || names[i].isEmpty()) {
                continue;
            }

            int itemId = da.insertItem(
                    names[i],
                    descriptions[i],
                    renterId
            );

            dao.insertRentRequestItem(
                    requestId,
                    itemId);
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

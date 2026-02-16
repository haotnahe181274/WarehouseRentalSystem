/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.common;

import dao.WarehouseDAO;
import dao.WarehouseImageDAO;
import dao.WarehouseTypeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Warehouse;
import model.WarehouseType;

/**
 *
 * @author ad
 */
@WebServlet(name = "HomepageServlet", urlPatterns = {"/homepage"})
public class HomepageServlet extends HttpServlet {

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
            out.println("<title>Servlet HomepageServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomepageServlet at " + request.getContextPath() + "</h1>");
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
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        WarehouseTypeDAO typeDAO = new WarehouseTypeDAO();
        WarehouseImageDAO imageDAO = new WarehouseImageDAO();

        // ================== 1. LẤY PARAM ==================
        String location = request.getParameter("location");
        String typeIdRaw = request.getParameter("typeId");
        String startDateRaw = request.getParameter("startDate");
        String endDateRaw = request.getParameter("endDate");

        String minPriceRaw = request.getParameter("minPrice");
        String maxPriceRaw = request.getParameter("maxPrice");
        String minAreaRaw = request.getParameter("minArea");
        String maxAreaRaw = request.getParameter("maxArea");
        String pageRaw = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");

        // ================== 2. PARSE AN TOÀN ==================
        Integer typeId = null;
        Double minPrice = null, maxPrice = null;
        Double minArea = null, maxArea = null;
        Date startDate = null;
        Date endDate = null;
        int page = 1;

        try {
            if (startDateRaw != null && !startDateRaw.isEmpty()) {
                startDate = java.sql.Date.valueOf(startDateRaw);
            }

            if (endDateRaw != null && !endDateRaw.isEmpty()) {
                endDate = java.sql.Date.valueOf(endDateRaw);
            }
            if (typeIdRaw != null && !typeIdRaw.isEmpty()) {
                typeId = Integer.parseInt(typeIdRaw);
            }

            if (minPriceRaw != null && !minPriceRaw.isEmpty()) {
                minPrice = Double.parseDouble(minPriceRaw);
            }

            if (maxPriceRaw != null && !maxPriceRaw.isEmpty()) {
                maxPrice = Double.parseDouble(maxPriceRaw);
            }

            if (minAreaRaw != null && !minAreaRaw.isEmpty()) {
                minArea = Double.parseDouble(minAreaRaw);
            }

            if (maxAreaRaw != null && !maxAreaRaw.isEmpty()) {
                maxArea = Double.parseDouble(maxAreaRaw);
            }

            if (pageRaw != null && !pageRaw.isEmpty()) {
                page = Integer.parseInt(pageRaw);
            }

            if (page < 1) {
                page = 1;
            }

        } catch (Exception e) {
            page = 1;
        }

        // ================== 3. PHÂN TRANG ==================
        int pageSize = 6;
        int offset = (page - 1) * pageSize;

        // ================== 4. QUERY DB ==================
        List<Warehouse> list = warehouseDAO.getFilteredWarehouses(
                keyword, location, typeId,
                minPrice, maxPrice,
                minArea, maxArea,
                startDate, endDate,
                sort,
                offset, pageSize
        );

        Map<Integer, String> imageMap = new HashMap<>();
        for (Warehouse w : list) {
            String img = imageDAO.getPrimaryImage(w.getWarehouseId());
            imageMap.put(w.getWarehouseId(), img);
        }

        int totalRecords = warehouseDAO.getTotalRecords(
                startDate, endDate,
                keyword, location,
                typeId,
                minPrice, maxPrice,
                minArea, maxArea
        );

        int totalPages = (int) Math.ceil(totalRecords * 1.0 / pageSize);

        StringBuilder qs = new StringBuilder();
        if (sort != null && !sort.isEmpty()) {
            qs.append("&sort=").append(sort);
        }
        if (keyword != null && !keyword.isEmpty()) {
            qs.append("&keyword=").append(keyword);
        }
        if (location != null && !location.isEmpty()) {
            qs.append("&location=").append(location);
        }
        if (typeId != null) {
            qs.append("&typeId=").append(typeId);
        }
        if (minPrice != null) {
            qs.append("&minPrice=").append(minPrice);
        }
        if (maxPrice != null) {
            qs.append("&maxPrice=").append(maxPrice);
        }
        if (minArea != null) {
            qs.append("&minArea=").append(minArea);
        }
        if (maxArea != null) {
            qs.append("&maxArea=").append(maxArea);
        }
        if (startDate != null) {
            qs.append("&startDate=").append(startDate);
        }
        if (endDate != null) {
            qs.append("&endDate=").append(endDate);
        }

        // ================== 5. SET ATTRIBUTE ==================
        request.setAttribute("queryString", qs.toString());
        request.setAttribute("warehouses", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalRecords);
        request.setAttribute("imageMap", imageMap);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.setAttribute("locations", warehouseDAO.getAllLocations());
        request.setAttribute("warehouseTypes", typeDAO.getAllTypes());
        request.setAttribute("paginationUrl", "homepage");

        // ================== 6. FORWARD ==================
        request.getRequestDispatcher("/Common/homepage/show.jsp").forward(request, response);

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
        processRequest(request, response);
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

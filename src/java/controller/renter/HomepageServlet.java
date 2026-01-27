/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.renter;

import dao.WarehouseDAO;
import dao.WarehouseTypeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Warehouse;
import model.WarehouseType;

/**
 *
 * @author ad
 */
@WebServlet(name="HomepageServlet", urlPatterns={"/HomepageServlet"})
public class HomepageServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<h1>Servlet HomepageServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // 1. Lấy dữ liệu cho BANNER (Các loại kho để đổ vào dropdown)
        WarehouseTypeDAO typeDAO = new WarehouseTypeDAO();
        List<WarehouseType> types = typeDAO.getAllTypes();
        request.setAttribute("warehouseTypes", types); // Dữ liệu này banner.jsp sẽ dùng

        // 2. Lấy các tham số lọc từ BANNER gửi lên
        String loc = request.getParameter("location");
        String typeIdStr = request.getParameter("typeId");
        String maxPriceStr = request.getParameter("maxPrice");
        
        Integer typeId = (typeIdStr != null && !typeIdStr.equals("0")) ? Integer.parseInt(typeIdStr) : null;
        Double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : null;

        // 3. Xử lý PHÂN TRANG (Pagination)
        int pageSize = 6;
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null) page = Integer.parseInt(pageStr);
        int offset = (page - 1) * pageSize;

        // 4. Lấy dữ liệu cho CARD (Danh sách kho bãi đã lọc)
        WarehouseDAO wDao = new WarehouseDAO();
        List<Warehouse> list = wDao.getFilteredWarehouses(loc, typeId, null, maxPrice, offset, pageSize); //
        int totalRecords = wDao.getTotalRecords(loc, typeId); //
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // 5. Đẩy hết dữ liệu sang JSP
        request.setAttribute("products", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("result", totalRecords);

        request.getRequestDispatcher("homepage/show.jsp").forward(request, response);
    
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

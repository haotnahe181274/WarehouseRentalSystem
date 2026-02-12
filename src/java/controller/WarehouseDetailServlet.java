///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//
//package controller;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import dao.WarehouseManagementDAO;
//import dao.WarehouseImageDAO;
//import java.util.List;
//import model.Warehouse;
//import model.WarehouseImage;
///**
// *
// * @author HGC
// */
//@WebServlet(name="WarehouseDetailServlet", urlPatterns={"/WarehouseDetailServlet"})
//public class WarehouseDetailServlet extends HttpServlet {
//   
//    /** 
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet WarehouseDetailServlet</title>");  
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet WarehouseDetailServlet at " + request.getContextPath () + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    } 
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /** 
//     * Handles the HTTP <code>GET</code> method.
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//    try {
//        // 1. Lấy ID từ tham số URL
//        int warehouseId = Integer.parseInt(request.getParameter("id"));
//        
//        // 2. Gọi DAO để lấy thông tin chi tiết
//        WarehouseManagementDAO warehouseDAO = new WarehouseManagementDAO();
//        Warehouse warehouse = warehouseDAO.getWarehouseById(warehouseId);
//        
//        // 3. Lấy danh sách ảnh (Gallery)
//        WarehouseImageDAO imageDAO = new WarehouseImageDAO();
//        List<WarehouseImage> images = imageDAO.getImagesByWarehouseId(warehouseId);
//        
//        // 4. Lấy danh sách Zones (Storage Units)
//        // (Giả sử bạn có method này trong WarehouseDAO hoặc StorageUnitDAO)
//        StorageUnitDAO unitDAO = new StorageUnitDAO(); 
//        List<StorageUnit> units = unitDAO.getUnitsByWarehouseId(warehouseId);
//
//        // 5. Tìm ảnh chính (primary) để hiển thị to nhất ban đầu
//        String primaryImage = "default.jpg";
//        for (WarehouseImage img : images) {
//            if (img.isPrimary()) { // Giả sử model có field isPrimary (boolean)
//                primaryImage = img.getImageUrl();
//                break;
//            }
//        }
//        if (images.size() > 0 && primaryImage.equals("default.jpg")) {
//             primaryImage = images.get(0).getImageUrl();
//        }
//
//        // 6. Đẩy dữ liệu sang JSP
//        request.setAttribute("warehouse", warehouse);
//        request.setAttribute("imageList", images);
//        request.setAttribute("primaryImage", primaryImage);
//        request.setAttribute("storageUnits", units);
//        
//        request.getRequestDispatcher("/Management/warehouse-detail.jsp").forward(request, response);
//        
//    } catch (Exception e) {
//        e.printStackTrace();
//        // Xử lý lỗi hoặc redirect về trang lỗi
//    }
//}
//
//    /** 
//     * Handles the HTTP <code>POST</code> method.
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /** 
//     * Returns a short description of the servlet.
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}

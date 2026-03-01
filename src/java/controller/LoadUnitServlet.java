package controller;

import dao.AssignmentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.StorageUnit;

@WebServlet(name = "LoadUnitsServlet", urlPatterns = {"/management/load-units"})
public class LoadUnitServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
            AssignmentDAO dao = new AssignmentDAO();
            List<StorageUnit> units = dao.getUnitsByWarehouse(warehouseId);
            
            for (StorageUnit u : units) {
                out.print("<option value='" + u.getUnitId() + "'>" + 
                          u.getUnitCode() + " - " + u.getDescription() + 
                          "</option>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
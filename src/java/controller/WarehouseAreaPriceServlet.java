package controller;

import dao.WarehouseDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Trả về dữ liệu JSON cho form thuê:
 * - action=areas: danh sách diện tích + số lượng khả dụng
 * - action=price: giá theo diện tích (object { "price": số })
 */
@WebServlet(name = "WarehouseAreaPriceServlet", urlPatterns = {"/warehouseAreaPrice"})
public class WarehouseAreaPriceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        String action = req.getParameter("action");
        String wid = req.getParameter("warehouseId");
        if (wid == null || wid.isEmpty()) {
            resp.getWriter().print("{}");
            return;
        }
        int warehouseId = Integer.parseInt(wid);
        WarehouseDAO dao = new WarehouseDAO();

        if ("areas".equals(action)) {
            String start = req.getParameter("startDate");
            String end = req.getParameter("endDate");
            if (start == null || end == null || start.isEmpty() || end.isEmpty()) {
                resp.getWriter().print("[]");
                return;
            }
            try {
                java.sql.Date startDate = java.sql.Date.valueOf(start);
                java.sql.Date endDate = java.sql.Date.valueOf(end);

                Map<Double, Integer> areaQtyMap = dao.getAvailableAreaQuantityByWarehouse(warehouseId, startDate, endDate);
                StringBuilder sb = new StringBuilder("[");
                int i = 0;
                for (Map.Entry<Double, Integer> entry : areaQtyMap.entrySet()) {
                    if (i > 0) sb.append(",");
                    sb.append("{\"area\":").append(entry.getKey())
                            .append(",\"quantity\":").append(entry.getValue())
                            .append("}");
                    i++;
                }
                sb.append("]");
                resp.getWriter().print(sb.toString());
            } catch (Exception e) {
                resp.getWriter().print("[]");
            }
            return;
        }

        if ("price".equals(action)) {
            String areaStr = req.getParameter("area");
            if (areaStr == null || areaStr.isEmpty()) {
                resp.getWriter().print("{\"price\":0}");
                return;
            }
            try {
                double area = Double.parseDouble(areaStr);
                double price = dao.getPriceByArea(warehouseId, area);
                resp.getWriter().print("{\"price\":" + price + "}");
            } catch (Exception e) {
                resp.getWriter().print("{\"price\":0}");
            }
            return;
        }

        resp.getWriter().print("{}");
    }
}

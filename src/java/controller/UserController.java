/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.UserView;
import ultis.UserValidation;

/**
 *
 * @author hao23
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024)
@WebServlet("/user/list")
public class UserController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UserController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    UserDAO userDAO = new UserDAO();

    // Helper method to set default image if image is null, empty, or invalid
    private void setDefaultImageIfNeeded(UserView user) {
        if (user != null) {
            String img = user.getImage();
            if (img == null || img.trim().isEmpty() || img.trim().equalsIgnoreCase("null")) {
                user.setImage("default.jpg");
            }
        }
    }

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String rawId = request.getParameter("id");
        String type = request.getParameter("type");

        HttpSession session = request.getSession();
        UserView currentUser = (UserView) session.getAttribute("user");
        String userRole = (String) session.getAttribute("role");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        boolean isAdmin = "Admin".equalsIgnoreCase(userRole);
        boolean isManager = "Manager".equalsIgnoreCase(userRole);
        boolean isStaff = "Staff".equalsIgnoreCase(userRole);
        boolean isRenter = "RENTER".equalsIgnoreCase(currentUser.getType());

        // --- STAFF & RENTER Redirect Logic ---
        if (isStaff || isRenter) {
            boolean isViewOwn = "view".equalsIgnoreCase(action)
                    && rawId != null && Integer.parseInt(rawId) == currentUser.getId()
                    && (type == null || type.equalsIgnoreCase(currentUser.getType()));

            if (!isViewOwn) {
                // Always redirect to view own profile
                response.sendRedirect(request.getContextPath() + "/user/list?action=view&id=" + currentUser.getId()
                        + "&type=" + currentUser.getType());
                return;
            }
        }

        // --- MANAGER Access Control ---
        if (isManager) {
            if ("add".equals(action) || "edit".equals(action)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                return;
            }
        }

        // VIEW ADD UPDATE

        if ("view".equals(action)) {
            int id = Integer.parseInt(rawId);
            UserView user = userDAO.getUserById(id, type);

            if (isManager && user != null && "INTERNAL".equalsIgnoreCase(user.getType())) {
                boolean isSelf = (user.getId() == currentUser.getId());
                boolean isTargetAllowed = "Staff".equalsIgnoreCase(user.getRole());
                if (!isSelf && !isTargetAllowed) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                    return;
                }
            }

            setDefaultImageIfNeeded(user);

            request.setAttribute("targetUser", user);
            request.setAttribute("mode", "view");
            request.getRequestDispatcher("/user/users.jsp").forward(request, response);
            return;
        }

        if ("add".equals(action)) {
            request.setAttribute("mode", "add");
            request.getRequestDispatcher("/user/users.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(rawId);
            UserView user = userDAO.getUserById(id, type);
            setDefaultImageIfNeeded(user);
            request.setAttribute("targetUser", user);
            request.setAttribute("mode", "edit");
            request.getRequestDispatcher("/user/users.jsp").forward(request, response);
            return;
        }
        // Load all users (DataTables handles pagination/sorting/searching client-side)
        String filterType = request.getParameter("filterType");
        String filterStatusRaw = request.getParameter("filterStatus");
        String filterRole = request.getParameter("filterRole");

        Integer filterStatus = null;
        if (filterStatusRaw != null && !filterStatusRaw.isEmpty() && !filterStatusRaw.equals("All")) {
            try {
                filterStatus = Integer.parseInt(filterStatusRaw);
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        if ("All".equals(filterType)) {
            filterType = null;
        }
        if ("All".equals(filterRole)) {
            filterRole = null;
        }

        if ("RENTER".equalsIgnoreCase(filterType)) {
            filterRole = null;
        }

        List<UserView> users = userDAO.getAllUsers(userRole, currentUser.getId(), currentUser.getType(),
                filterType, filterStatus, filterRole);

        for (UserView u : users) {
            setDefaultImageIfNeeded(u);
        }

        request.setAttribute("filterType", filterType);
        request.setAttribute("filterStatus", filterStatus);
        request.setAttribute("filterRole", filterRole);
        request.setAttribute("users", users);
        request.getRequestDispatcher("/user/userlist.jsp").forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role");

        // Only Admin can perform POST actions (save, block, unblock)
        if (!"Admin".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        String mode = request.getParameter("mode");
        String idRaw = request.getParameter("id");
        if ("block".equals(action) || "unblock".equals(action)) {
            int id = Integer.parseInt(idRaw);
            String type = request.getParameter("type");
            int status = action.equals("block") ? 0 : 1;
            userDAO.updateStatus(id, type, status);
            response.sendRedirect(request.getContextPath() + "/user/list");
            return;
        }

        if ("save".equals(action)) {

            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String role = request.getParameter("roleId");
            Map<String, String> errors = new HashMap<>();
            // upload image
            Part avatar = request.getPart("image");
            String fileName = null;

            if (avatar != null && avatar.getSize() > 0) {
                String submittedFileName = avatar.getSubmittedFileName();
                String ext = submittedFileName.substring(submittedFileName.lastIndexOf(".") + 1).toLowerCase();
                if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png")) {
                    errors.put("image", "Just support .png .jpg");
                } else {
                    fileName = System.currentTimeMillis() + "_" + submittedFileName;
                    String uploadPath = request.getServletContext().getRealPath("/resources/user/image");
                    new File(uploadPath).mkdirs();
                    avatar.write(uploadPath + File.separator + fileName);
                }
            }

            // ===== ADD =====
            if ("add".equals(mode)) {
                int roleId = Integer.parseInt(role);
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String idCard = request.getParameter("idCard");
                String address = request.getParameter("address");
                Map<String, String> validateErrors = UserValidation.validateCreate(username, password, email, fullName,
                        phone, userDAO);
                errors.putAll(validateErrors);

                if (!UserValidation.isValidIdCard(idCard)) {
                    errors.put("idCard", "ID Card must be exactly 12 digits, no spaces");
                }
                if (!UserValidation.isValidString(address)) {
                    errors.put("address",
                            "Address must not have leading/trailing spaces or multiple consecutive spaces");
                }

                if (!errors.isEmpty()) {
                    request.setAttribute("errors", errors);
                    request.setAttribute("mode", "add");
                    // Giữ lại dữ liệu đã nhập
                    request.setAttribute("username", username);
                    request.setAttribute("email", email);
                    request.setAttribute("fullName", fullName);
                    request.setAttribute("phone", phone);
                    request.setAttribute("roleId", role);
                    request.setAttribute("idCard", idCard);
                    request.setAttribute("address", address);
                    request.getRequestDispatcher("/user/users.jsp").forward(request, response);
                    return;
                }

                // Auto-generate internal user code based on role: A12345, M12345, S12345
                String internalUserCode = generateInternalUserCode(roleId);

                userDAO.insertInternalUser(
                        username, password, email, fullName, phone, fileName, roleId, internalUserCode, idCard,
                        address);
            }

            // ===== UPDATE =====
            if ("edit".equals(mode)) {
                int id = Integer.parseInt(idRaw);
                int roleId = (role != null && !role.isEmpty()) ? Integer.parseInt(role) : 0;
                String idCard = request.getParameter("idCard");
                String address = request.getParameter("address");

                // Validate email
                if (!UserValidation.isValidEmail(email)) {
                    errors.put("email", "Invalid email format");
                }

                // Validate fullName
                if (!UserValidation.isValidString(fullName)) {
                    errors.put("fullName",
                            "Full name must not have leading/trailing spaces or multiple consecutive spaces");
                }

                // Validate phone
                if (!UserValidation.isValidPhone(phone)) {
                    errors.put("phone", "Phone must start with 0, contain only digits, max 10 characters");
                }

                if (!UserValidation.isValidIdCard(idCard)) {
                    errors.put("idCard", "ID Card must be exactly 12 digits, no spaces");
                }
                if (!UserValidation.isValidString(address)) {
                    errors.put("address",
                            "Address must not have leading/trailing spaces or multiple consecutive spaces");
                }

                if (!errors.isEmpty()) {
                    UserView user = userDAO.getUserById(id, "INTERNAL");
                    setDefaultImageIfNeeded(user);
                    // Cập nhật dữ liệu đã nhập
                    user.setEmail(email);
                    user.setFullName(fullName);
                    user.setPhone(phone);
                    request.setAttribute("errors", errors);
                    request.setAttribute("targetUser", user);
                    request.setAttribute("mode", "edit");
                    request.setAttribute("roleId", role);
                    request.setAttribute("idCard", idCard);
                    request.setAttribute("address", address);
                    request.getRequestDispatcher("/user/users.jsp").forward(request, response);
                    return;
                }

                // nếu không upload ảnh mới → giữ ảnh cũ
                if (fileName == null) {
                    UserView old = userDAO.getUserById(id, "INTERNAL");
                    fileName = old.getImage();
                }

                userDAO.updateInternalUser(
                        id, email, fullName, phone, fileName, roleId, idCard, address);
            }
        }

        response.sendRedirect(request.getContextPath() + "/user/list");
    }

    // Helper method to generate internal user code based on role
    // Format: Role prefix + 4-5 random digits
    // Admin -> A12345, Manager -> M12345, Staff -> S12345
    private String generateInternalUserCode(int roleId) {
        String prefix;
        switch (roleId) {
            case 1: // Admin
                prefix = "A";
                break;
            case 2: // Manager
                prefix = "M";
                break;
            case 3: // Staff
                prefix = "S";
                break;
            default:
                prefix = "U"; // Unknown
        }

        // Random 4-5 digits (10000-99999)
        int randomNum = (int) (Math.random() * 90000 + 10000);

        return prefix + randomNum;
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

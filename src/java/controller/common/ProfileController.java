/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.common;

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
import java.util.HashMap;
import java.util.Map;
import model.UserView;
import ultis.UserValidation;

/**
 *
 * @author hao23
 */
@WebServlet(name = "ProfileController", urlPatterns = { "/profile" })
@MultipartConfig
public class ProfileController extends HttpServlet {

    UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView loginUser = (UserView) session.getAttribute("user");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idRaw = request.getParameter("id");
        String type = request.getParameter("type");
        UserView targetUser;

        // Determine target user
        if (idRaw != null && type != null) {
            try {
                int id = Integer.parseInt(idRaw);
                // Allow viewing others only if admin or correct logic, otherwise default to
                // self if not found/allowed
                // But for now let's assume if ID is passed, we try to get it.
                // Access control check:
                if ("ADMIN".equals(loginUser.getRole())) {
                    targetUser = userDao.getUserById(id, type);
                } else if (loginUser.getId() == id && loginUser.getType().equals(type)) {
                    targetUser = loginUser;
                } else {
                    // If trying to access others and not Admin -> Access Denied or redirect to self
                    response.sendRedirect(request.getContextPath() + "/profile?id=" + loginUser.getId() + "&type="
                            + loginUser.getType());
                    return;
                }
            } catch (NumberFormatException e) {
                targetUser = loginUser;
            }
        } else {
            targetUser = loginUser;
        }

        if (targetUser == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("targetUser", targetUser);
        request.getRequestDispatcher("user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserView loginUser = (UserView) session.getAttribute("user");

        String btnAction = request.getParameter("btnAction");
        String idRaw = request.getParameter("id");
        String type = request.getParameter("type");

        int id = Integer.parseInt(idRaw);
        UserView targetUser = userDao.getUserById(id, type);

        // Security Check: Only Admin or Owner can update
        boolean isOwner = (loginUser.getId() == id && loginUser.getType().equals(type));
        if (!"ADMIN".equals(loginUser.getRole()) && !isOwner) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Map<String, String> errors = new HashMap<>();

        if ("updateInfo".equals(btnAction)) {
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String idCard = request.getParameter("idCard");
            String address = request.getParameter("address");

            // Validate
            if (!UserValidation.isValidEmail(email)) {
                errors.put("email", "Invalid email format");
            }
            if (!UserValidation.isValidString(fullName)) {
                errors.put("fullName",
                        "Full name must not have leading/trailing spaces or multiple consecutive spaces");
            }
            if (!UserValidation.isValidPhone(phone)) {
                errors.put("phone", "Phone must start with 0, contain only digits, max 10 characters");
            }

            // Image Upload
            String fileName = targetUser.getImage();
            try {
                Part avatar = request.getPart("image");
                if (avatar != null && avatar.getSize() > 0) {
                    String submittedFileName = avatar.getSubmittedFileName();
                    String ext = submittedFileName.substring(submittedFileName.lastIndexOf(".") + 1).toLowerCase();
                    if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png")) {
                        errors.put("image", "Just support .png .jpg");
                    } else {
                        String newFileName = System.currentTimeMillis() + "_" + submittedFileName;
                        String uploadPath = request.getServletContext().getRealPath("/resources/user/image");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists())
                            uploadDir.mkdirs();
                        avatar.write(uploadPath + File.separator + newFileName);
                        fileName = newFileName;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (errors.isEmpty()) {
                targetUser.setEmail(email);
                targetUser.setFullName(fullName);
                targetUser.setPhone(phone);
                targetUser.setImage(fileName);
                if ("INTERNAL".equals(targetUser.getType())) {
                    targetUser.setIdCard(idCard);
                    targetUser.setAddress(address);
                }

                userDao.updateProfile(targetUser);

                // Update session if self
                if (isOwner) {
                    // Update session attributes if needed, or just specific fields
                    // Ideally we should reload user from DB, but setting fields is faster
                    loginUser.setEmail(email);
                    loginUser.setFullName(fullName);
                    loginUser.setPhone(phone);
                    loginUser.setImage(fileName);
                    if ("INTERNAL".equals(loginUser.getType())) {
                        loginUser.setIdCard(idCard);
                        loginUser.setAddress(address);
                    }
                    session.setAttribute("user", loginUser);
                }
                request.setAttribute("message", "Profile updated successfully!");
            }

        } else if ("changePassword".equals(btnAction)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (oldPassword == null || oldPassword.isEmpty()) {
                errors.put("oldPassword", "Old password is required");
            } else {
                // Verify old password
                UserView checkedUser = userDao.checkAuthen(targetUser.getName(), oldPassword);
                if (checkedUser == null) {
                    errors.put("oldPassword", "Incorrect old password");
                }
            }

            if (newPassword == null || newPassword.length() < 6) {
                errors.put("newPassword", "Password must be at least 6 characters");
            }

            if (!newPassword.equals(confirmPassword)) {
                errors.put("confirmPassword", "Confirm password does not match");
            }

            if (errors.isEmpty()) {
                boolean success = userDao.changePassword(id, type, newPassword);
                if (success) {
                    request.setAttribute("message", "Password changed successfully!");
                } else {
                    request.setAttribute("error", "Failed to change password");
                }
            }
        }

        request.setAttribute("errors", errors);
        request.setAttribute("targetUser", targetUser);
        request.getRequestDispatcher("user/profile.jsp").forward(request, response);
    }
}

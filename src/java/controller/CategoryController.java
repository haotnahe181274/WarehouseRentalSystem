package controller;

import dao.BlogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.BlogCategory;
import model.UserView;
import ultis.UserValidation;

@WebServlet(name = "CategoryController", urlPatterns = { "/category-management" })
public class CategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserView user = (UserView) session.getAttribute("user");

        // Check if user is logged in and is Admin (Internal User with appropriate type)
        if (user == null || !"INTERNAL".equals(user.getType())) {
            response.sendRedirect("login");
            return;
        }

        BlogDAO dao = new BlogDAO();
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    listCategories(request, response, dao);
                    break;
                case "delete":
                    deleteCategory(request, response, dao);
                    break;
                default:
                    listCategories(request, response, dao);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("category-management");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserView user = (UserView) session.getAttribute("user");

        if (user == null || !"INTERNAL".equals(user.getType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        BlogDAO dao = new BlogDAO();
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                addCategory(request, response, dao);
            } else if ("update".equals(action)) {
                updateCategory(request, response, dao);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("category-management");
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response, BlogDAO dao)
            throws ServletException, IOException {
        List<BlogCategory> categories = dao.getBlogCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("Management/category-management.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response, BlogDAO dao)
            throws ServletException, IOException {
        String name = request.getParameter("categoryName");
        String error = UserValidation.validateCategoryName(name);

        if (error != null) {
            request.setAttribute("error", error);
            listCategories(request, response, dao);
            return;
        }

        dao.addCategory(name);
        response.sendRedirect("category-management?success=Category added successfully");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response, BlogDAO dao)
            throws ServletException, IOException {
        String idStr = request.getParameter("categoryId");
        String name = request.getParameter("categoryName");
        String error = UserValidation.validateCategoryName(name);

        if (error != null) {
            request.setAttribute("error", error);
            listCategories(request, response, dao);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            dao.updateCategory(id, name);
            response.sendRedirect("category-management?success=Category updated successfully");
        } catch (NumberFormatException e) {
            response.sendRedirect("category-management?error=Invalid category ID");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response, BlogDAO dao)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            if (dao.deleteCategory(id)) {
                response.sendRedirect("category-management?success=Category deleted successfully");
            } else {
                response.sendRedirect("category-management?error=Cannot delete category. It might be in use by existing blog posts.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("category-management?error=Invalid category ID");
        }
    }
}

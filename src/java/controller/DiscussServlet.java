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
import model.BlogPost;
import model.UserView;

@WebServlet(name = "DiscussServlet", urlPatterns = { "/discuss" })
public class DiscussServlet extends HttpServlet {

    private static final int PAGE_SIZE = 2;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserView user = (UserView) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        BlogDAO dao = new BlogDAO();
        try {
            String catIdStr = request.getParameter("categoryId");
            Integer categoryId = (catIdStr != null && !catIdStr.isEmpty()) ? Integer.parseInt(catIdStr) : null;

            // Pagination
            String pageStr = request.getParameter("page");
            int currentPage = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            if (currentPage < 1)
                currentPage = 1;

            int totalItems = dao.countAllPosts(categoryId);
            int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
            if (totalPages < 1)
                totalPages = 1;
            if (currentPage > totalPages)
                currentPage = totalPages;

            int offset = (currentPage - 1) * PAGE_SIZE;
            List<BlogPost> list = dao.getAllPostsWithDetailsPaged(user.getId(), user.getType(), categoryId, offset,
                    PAGE_SIZE);
            List<model.BlogCategory> categories = dao.getBlogCategories();

            request.setAttribute("blogList", list);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategory", categoryId);
            request.setAttribute("pageTitle", "Discuss");

            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("paginationUrl", "discuss");
            String queryString = "";
            if (categoryId != null && categoryId > 0) {
                queryString = "&categoryId=" + categoryId;
            }
            request.setAttribute("queryString", queryString);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/blog/discuss.jsp").forward(request, response);
    }
}

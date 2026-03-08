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

/**
 * Servlet to list blog posts created by the current user.
 */
@WebServlet(name = "MyBlogListServlet", urlPatterns = { "/my-posts" })
public class MyBlogListServlet extends HttpServlet {

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
            // Get posts authored by this user (Renter or Internal User)
            List<BlogPost> list = dao.getPostsByUser(user.getId(), user.getType());
            request.setAttribute("blogList", list);
            request.setAttribute("pageTitle", "My Blog Posts");
            request.setAttribute("canManage", true);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("blog/blog-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

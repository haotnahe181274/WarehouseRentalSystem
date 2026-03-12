package controller;

import dao.BlogDAO;
import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.UserView;
import model.BlogComment;
import model.Notification;

@WebServlet(name = "BlogActionServlet", urlPatterns = { "/blog-action" })
public class BlogActionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("getComments".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            BlogDAO dao = new BlogDAO();
            List<BlogComment> comments = dao.getCommentsByPostId(postId);

            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < comments.size(); i++) {
                BlogComment c = comments.get(i);
                json.append("{")
                        .append("\"commentId\": ").append(c.getCommentId()).append(",")
                        .append("\"userName\": \"").append(escapeJson(c.getUserName())).append("\",")
                        .append("\"userImage\": \"").append(escapeJson(c.getUserImage())).append("\",")
                        .append("\"content\": \"").append(escapeJson(c.getContent())).append("\",")
                        .append("\"createdAt\": \"").append(escapeJson(c.getCreatedAt())).append("\",")
                        .append("\"parentCommentId\": ").append(c.getParentCommentId())
                        .append("}");
                if (i < comments.size() - 1)
                    json.append(",");
            }
            json.append("]");
            out.print(json.toString());
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        UserView user = (UserView) session.getAttribute("user");

        if (user == null) { 
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        BlogDAO dao = new BlogDAO();

        if ("like".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            boolean isLiked = dao.toggleLike(postId, user.getId(), user.getType());
         
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true, \"isLiked\": " + isLiked + "}");
            if (isLiked)
            {
                 UserView userV = dao.getUserInfoByLikeId(postId);
            Notification noti = new Notification();
            noti.setMessage("Your blog have a new like.");
            noti.setType("SUCCESS");
            noti.setLinkUrl("/discuss");
            noti.setRenterId(userV.getId());
            new NotificationDAO().insertNotification(noti);
            }
            
            out.flush();
          
        } else if ("create".equals(action)) {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            dao.createPost(title, content, categoryId, user.getId(), user.getType());

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true}");
            out.flush();
        } else if ("comment".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String content = request.getParameter("content");
            String parentIdStr = request.getParameter("parentCommentId");
            Integer parentId = (parentIdStr != null && !parentIdStr.isEmpty()) ? Integer.parseInt(parentIdStr) : null;

            dao.addComment(postId, user.getId(), user.getType(), content, parentId);

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true}");
            out.flush();
        }
    }

    private String escapeJson(String str) {
        if (str == null)
            return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}

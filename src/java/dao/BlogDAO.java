/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import model.BlogPost;
import java.sql.*;

/**
 *
 * @author hao23
 */
public class BlogDAO extends DBContext {

    public List<BlogPost> getAllPosts() throws SQLException {
        List<BlogPost> list = new ArrayList<>();
        String sql = """
                select p.post_id, p.title, p.created_at, p.category_id, c.category_name
                from Blog_Post p
                left join Blog_Category c
                on p.category_id = c.category_id
                where p.status = 1
                order by p.created_at desc
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BlogPost post = new BlogPost();
                post.setPostId(rs.getInt("post_id"));
                post.setTitle(rs.getString("title"));
                post.setCategoryId(rs.getInt("category_id"));
                post.setCategoryName(rs.getString("category_name"));
                post.setCreatedAt(rs.getString("created_at"));
                list.add(post);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public List<BlogPost> getPostsByUser(int userId, String userType) throws SQLException {
        List<BlogPost> list = new ArrayList<>();
        String column = "RENTER".equals(userType) ? "renter_id" : "internal_user_id";
        String sql = "select p.post_id, p.title, p.created_at, p.category_id, c.category_name "
                + "from Blog_Post p "
                + "left join Blog_Category c on p.category_id = c.category_id "
                + "where p.status = 1 and p." + column + " = ? "
                + "order by p.created_at desc";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BlogPost post = new BlogPost();
                post.setPostId(rs.getInt("post_id"));
                post.setTitle(rs.getString("title"));
                post.setCategoryId(rs.getInt("category_id"));
                post.setCategoryName(rs.getString("category_name"));
                post.setCreatedAt(rs.getString("created_at"));
                list.add(post);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public BlogPost getPostById(int id) {
        String sql = """
                SELECT p.post_id, p.title, p.content, p.category_id,
                       c.category_name, p.created_at,
                       CASE
                           WHEN p.renter_id IS NOT NULL THEN (SELECT full_name FROM Renter WHERE renter_id = p.renter_id)
                           WHEN p.internal_user_id IS NOT NULL THEN (SELECT full_name FROM Internal_user WHERE internal_user_id = p.internal_user_id)
                       END as author_name,
                       CASE
                           WHEN p.renter_id IS NOT NULL THEN (SELECT image FROM Renter WHERE renter_id = p.renter_id)
                           WHEN p.internal_user_id IS NOT NULL THEN (SELECT image FROM Internal_user WHERE internal_user_id = p.internal_user_id)
                       END as author_image,
                       (SELECT COUNT(*) FROM Blog_Comment bc WHERE bc.post_id = p.post_id AND bc.status = 1) as comment_count
                FROM Blog_Post p
                JOIN Blog_Category c ON p.category_id = c.category_id
                WHERE p.post_id = ?
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BlogPost post = new BlogPost();
                post.setPostId(rs.getInt("post_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setCategoryId(rs.getInt("category_id"));
                post.setCategoryName(rs.getString("category_name"));
                post.setCreatedAt(rs.getString("created_at"));
                post.setAuthorName(rs.getString("author_name"));
                post.setAuthorImage(rs.getString("author_image"));
                post.setCommentCount(rs.getInt("comment_count"));
                return post;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void createPost(String title, String content, int categoryId, int userId, String userType) {
        String column = "RENTER".equals(userType) ? "renter_id" : "internal_user_id";
        String sql = "insert into Blog_Post(title, content, category_id, " + column + ") values(?,?,?,?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, categoryId);
            ps.setInt(4, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updatePost(int id, String title, String content, int categoryId) {

        String sql = """
                    UPDATE Blog_Post
                    SET title = ?, content = ?, category_id = ?, updated_at = NOW()
                    WHERE post_id = ?
                """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, categoryId);
            ps.setInt(4, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deletePost(int id) {
        String sql = "update Blog_Post set status = 0 where post_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<model.BlogCategory> getBlogCategories() {
        List<model.BlogCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM Blog_Category";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                model.BlogCategory cat = new model.BlogCategory();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setCategoryName(rs.getString("category_name"));
                list.add(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<BlogPost> getAllPostsWithDetails(int currentUserId, String currentUserType, Integer categoryId)
            throws SQLException {
        List<BlogPost> list = new ArrayList<>();
        String likeColumn = "RENTER".equals(currentUserType) ? "renter_id" : "internal_user_id";
        String sql = "SELECT p.post_id, p.title, p.content, p.created_at, p.category_id, c.category_name, "
                + "(SELECT COUNT(*) FROM Blog_Like WHERE target_type = 'POST' AND target_id = p.post_id) as like_count, "
                + "(SELECT COUNT(*) FROM Blog_Comment WHERE post_id = p.post_id AND status = 1) as comment_count, "
                + "CASE WHEN p.renter_id IS NOT NULL THEN (SELECT full_name FROM Renter WHERE renter_id = p.renter_id) "
                + "     WHEN p.internal_user_id IS NOT NULL THEN (SELECT full_name FROM Internal_user WHERE internal_user_id = p.internal_user_id) "
                + "END as author_name, "
                + "CASE WHEN p.renter_id IS NOT NULL THEN (SELECT image FROM Renter WHERE renter_id = p.renter_id) "
                + "     WHEN p.internal_user_id IS NOT NULL THEN (SELECT image FROM Internal_user WHERE internal_user_id = p.internal_user_id) "
                + "END as author_image, "
                + "EXISTS (SELECT 1 FROM Blog_Like WHERE target_type = 'POST' AND target_id = p.post_id AND "
                + likeColumn
                + " = ?) as is_liked "
                + "FROM Blog_Post p "
                + "LEFT JOIN Blog_Category c ON p.category_id = c.category_id "
                + "WHERE p.status = 1 ";
        if (categoryId != null && categoryId > 0) {
            sql += " AND p.category_id = ? ";
        }
        sql += " ORDER BY p.created_at DESC ";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, currentUserId);
            if (categoryId != null && categoryId > 0) {
                ps.setInt(2, categoryId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BlogPost post = new BlogPost();
                post.setPostId(rs.getInt("post_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setCategoryId(rs.getInt("category_id"));
                post.setCategoryName(rs.getString("category_name"));
                post.setCreatedAt(rs.getString("created_at"));
                post.setLikeCount(rs.getInt("like_count"));
                post.setCommentCount(rs.getInt("comment_count"));
                post.setAuthorName(rs.getString("author_name"));
                post.setAuthorImage(rs.getString("author_image"));
                post.setIsLikedByUser(rs.getBoolean("is_liked"));
                list.add(post);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public int countAllPosts(Integer categoryId) {
        String sql = "SELECT COUNT(*) FROM Blog_Post WHERE status = 1";
        if (categoryId != null && categoryId > 0) {
            sql += " AND category_id = ?";
        }
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (categoryId != null && categoryId > 0) {
                ps.setInt(1, categoryId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<BlogPost> getAllPostsWithDetailsPaged(int currentUserId, String currentUserType, Integer categoryId,
            int offset, int limit)
            throws SQLException {
        List<BlogPost> list = new ArrayList<>();
        String likeColumn = "RENTER".equals(currentUserType) ? "renter_id" : "internal_user_id";
        String sql = "SELECT p.post_id, p.title, p.content, p.created_at, p.category_id, c.category_name, "
                + "(SELECT COUNT(*) FROM Blog_Like WHERE target_type = 'POST' AND target_id = p.post_id) as like_count, "
                + "(SELECT COUNT(*) FROM Blog_Comment WHERE post_id = p.post_id AND status = 1) as comment_count, "
                + "CASE WHEN p.renter_id IS NOT NULL THEN (SELECT full_name FROM Renter WHERE renter_id = p.renter_id) "
                + "     WHEN p.internal_user_id IS NOT NULL THEN (SELECT full_name FROM Internal_user WHERE internal_user_id = p.internal_user_id) "
                + "END as author_name, "
                + "CASE WHEN p.renter_id IS NOT NULL THEN (SELECT image FROM Renter WHERE renter_id = p.renter_id) "
                + "     WHEN p.internal_user_id IS NOT NULL THEN (SELECT image FROM Internal_user WHERE internal_user_id = p.internal_user_id) "
                + "END as author_image, "
                + "EXISTS (SELECT 1 FROM Blog_Like WHERE target_type = 'POST' AND target_id = p.post_id AND "
                + likeColumn + " = ?) as is_liked "
                + "FROM Blog_Post p "
                + "LEFT JOIN Blog_Category c ON p.category_id = c.category_id "
                + "WHERE p.status = 1 ";
        if (categoryId != null && categoryId > 0) {
            sql += " AND p.category_id = ? ";
        }
        sql += " ORDER BY p.created_at DESC LIMIT ?, ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int idx = 1;
            ps.setInt(idx++, currentUserId);
            if (categoryId != null && categoryId > 0) {
                ps.setInt(idx++, categoryId);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx++, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BlogPost post = new BlogPost();
                post.setPostId(rs.getInt("post_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setCategoryId(rs.getInt("category_id"));
                post.setCategoryName(rs.getString("category_name"));
                post.setCreatedAt(rs.getString("created_at"));
                post.setLikeCount(rs.getInt("like_count"));
                post.setCommentCount(rs.getInt("comment_count"));
                post.setAuthorName(rs.getString("author_name"));
                post.setAuthorImage(rs.getString("author_image"));
                post.setIsLikedByUser(rs.getBoolean("is_liked"));
                list.add(post);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public List<model.BlogComment> getCommentsByPostId(int postId) {
        List<model.BlogComment> list = new ArrayList<>();
        String sql = """
                SELECT bc.*,
                       CASE
                           WHEN bc.renter_id IS NOT NULL THEN (SELECT full_name FROM Renter WHERE renter_id = bc.renter_id)
                           WHEN bc.internal_user_id IS NOT NULL THEN (SELECT full_name FROM Internal_user WHERE internal_user_id = bc.internal_user_id)
                       END as user_name,
                       CASE
                           WHEN bc.renter_id IS NOT NULL THEN (SELECT image FROM Renter WHERE renter_id = bc.renter_id)
                           WHEN bc.internal_user_id IS NOT NULL THEN (SELECT image FROM Internal_user WHERE internal_user_id = bc.internal_user_id)
                       END as user_image
                FROM Blog_Comment bc
                WHERE bc.post_id = ? AND bc.status = 1
                ORDER BY bc.parent_comment_id ASC, bc.created_at ASC
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                model.BlogComment comment = new model.BlogComment();
                comment.setCommentId(rs.getInt("comment_id"));
                comment.setContent(rs.getString("content"));
                comment.setPostId(rs.getInt("post_id"));
                comment.setUserName(rs.getString("user_name"));
                comment.setUserImage(rs.getString("user_image"));
                comment.setCreatedAt(rs.getString("created_at"));
                comment.setParentCommentId(rs.getInt("parent_comment_id"));
                list.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean toggleLike(int postId, int userId, String userType) {
        String column = "RENTER".equals(userType) ? "renter_id" : "internal_user_id";
        String checkSql = "SELECT 1 FROM Blog_Like WHERE target_type = 'POST' AND target_id = ? AND " + column + " = ?";
        try {
            PreparedStatement psCheck = connection.prepareStatement(checkSql);
            psCheck.setInt(1, postId);
            psCheck.setInt(2, userId);
            ResultSet rs = psCheck.executeQuery();
            if (rs.next()) {
                // Already liked, so remove like
                String deleteSql = "DELETE FROM Blog_Like WHERE target_type = 'POST' AND target_id = ? AND " + column
                        + " = ?";
                PreparedStatement psDelete = connection.prepareStatement(deleteSql);
                psDelete.setInt(1, postId);
                psDelete.setInt(2, userId);
                psDelete.executeUpdate();
                return false;
            } else {
                // Not liked yet, so add like
                String insertSql = "INSERT INTO Blog_Like (target_type, target_id, " + column
                        + ") VALUES ('POST', ?, ?)";
                PreparedStatement psInsert = connection.prepareStatement(insertSql);
                psInsert.setInt(1, postId);
                psInsert.setInt(2, userId);
                psInsert.executeUpdate();
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void addComment(int postId, int userId, String userType, String content, Integer parentCommentId) {
        String column = "RENTER".equals(userType) ? "renter_id" : "internal_user_id";
        String sql = "INSERT INTO Blog_Comment (post_id, " + column
                + ", content, parent_comment_id) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, postId);
            ps.setInt(2, userId);
            ps.setString(3, content);
            if (parentCommentId != null && parentCommentId > 0) {
                ps.setInt(4, parentCommentId);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

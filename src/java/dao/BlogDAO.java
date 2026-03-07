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
                select p.post_id, p.title, p.view_count, p.created_at, p.category_id, c.category_name
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
                post.setViewCount(rs.getInt("view_count"));
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
                select p.post_id,
                p.title,
                p.content,
                p.view_count,
                p.category_id,
                c.category_name, p.created_at
                from Blog_Post p
                join Blog_Category c on p.category_id = c.category_id
                where p.post_id = ?
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
                post.setViewCount(rs.getInt("view_count"));
                post.setCategoryId(rs.getInt("category_id"));
                post.setCategoryName(rs.getString("category_name"));
                post.setCreatedAt(rs.getString("created_at"));
                return post;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void createPost(String title, String content, int categoryId, int renter) {
        String sql = """
                insert into Blog_Post(title, content, category_id, renter_id)
                values(?,?,?,?)
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, categoryId);
            ps.setInt(4, renter);
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

    public void incrementViewCount(int id) {
        String sql = "UPDATE Blog_Post SET view_count = view_count + 1 WHERE post_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

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
                select p.post_id, p.title, p.view_count, p.created_at, c.category_name
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
                post.setCategoryName(rs.getString("category_name"));
                post.setCreatedAt(rs.getString("created_at"));
                list.add(post);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }
}

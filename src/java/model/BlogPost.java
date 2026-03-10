/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hao23
 */
public class BlogPost {
    private int postId;
    private String title;
    private String content;
    private int categoryId;
    private String categoryName;
    private String createdAt;

    // Extended fields for Discuss page
    private int likeCount;
    private int commentCount;
    private String authorName;
    private String authorImage;
    private boolean isLikedByUser;
    private String authorType;

    public BlogPost() {
    }

    public BlogPost(int postId, String title, String content, int categoryId, String categoryName,
            String createdAt) {
        this.postId = postId;
        this.title = title;
        this.content = content;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.createdAt = createdAt;
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getAuthorImage() {
        return authorImage;
    }

    public void setAuthorImage(String authorImage) {
        this.authorImage = authorImage;
    }

    public boolean isIsLikedByUser() {
        return isLikedByUser;
    }

    public void setIsLikedByUser(boolean isLikedByUser) {
        this.isLikedByUser = isLikedByUser;
    }

    public String getAuthorType() {
        return authorType;
    }

    public void setAuthorType(String authorType) {
        this.authorType = authorType;
    }

}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author HGC
 */
public class Notification {

    private int notificationId;
    private String title;
    private String message;
    private String type;
    private String linkUrl;
    private boolean isRead;
    private Timestamp createdAt;
    private int renterId;

    public int getRenterId() {
        return renterId;
    }

    public void setRenterId(int renterId) {
        this.renterId = renterId;
    }

    public int getInternalUserId() {
        return internalUserId;
    }

    public void setInternalUserId(int internalUserId) {
        this.internalUserId = internalUserId;
    }
    private int internalUserId;

    // Hàm helper để hiển thị thời gian giống UI của Hiếu
    public String getTimeAgo() {
        long timeDifference = System.currentTimeMillis() - createdAt.getTime();
        long minutes = timeDifference / 60000;
        if (minutes < 60) {
            return minutes + " mins ago";
        }
        long hours = minutes / 60;
        if (hours < 24) {
            return hours + " hours ago";
        }
        return (hours / 24) + " days ago";
    }

    // Hàm helper lấy icon CSS class dựa theo type
    public String getIconClass() {
        if ("WARNING".equals(type)) {
            return "bg-warning";
        }
        if ("SUCCESS".equals(type)) {
            return "bg-success";
        }
        return "bg-primary"; // INFO
    }

    public String getIconName() {
        if ("WARNING".equals(type)) {
            return "fa-exclamation-triangle";
        }
        if ("SUCCESS".equals(type)) {
            return "fa-check-circle";
        }
        return "fa-info-circle"; // INFO
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
    }

   public boolean isRead() {
    return isRead;
}

    public void setRead(boolean isRead) {
    this.isRead = isRead;
}

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

}

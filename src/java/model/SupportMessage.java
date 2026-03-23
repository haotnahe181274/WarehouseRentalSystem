package model;

import java.sql.Timestamp;

public class SupportMessage {
    private int messageId;
    private int conversationId;
    private String senderType;
    private Integer renterId;
    private Integer internalUserId;
    private String messageContent;
    private boolean isRead;
    private Timestamp sentAt;

    public SupportMessage() {
    }

    public SupportMessage(int messageId, int conversationId, String senderType,
            Integer renterId, Integer internalUserId, String messageContent,
            boolean isRead, Timestamp sentAt) {
        this.messageId = messageId;
        this.conversationId = conversationId;
        this.senderType = senderType;
        this.renterId = renterId;
        this.internalUserId = internalUserId;
        this.messageContent = messageContent;
        this.isRead = isRead;
        this.sentAt = sentAt;
    }

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public int getConversationId() {
        return conversationId;
    }

    public void setConversationId(int conversationId) {
        this.conversationId = conversationId;
    }

    public String getSenderType() {
        return senderType;
    }

    public void setSenderType(String senderType) {
        this.senderType = senderType;
    }

    public Integer getRenterId() {
        return renterId;
    }

    public void setRenterId(Integer renterId) {
        this.renterId = renterId;
    }

    public Integer getInternalUserId() {
        return internalUserId;
    }

    public void setInternalUserId(Integer internalUserId) {
        this.internalUserId = internalUserId;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

    public boolean isIsRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }

    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }
}
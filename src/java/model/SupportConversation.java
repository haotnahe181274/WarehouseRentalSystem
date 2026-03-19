package model;

import java.sql.Timestamp;

public class SupportConversation {
    private int conversationId;
    private String subject;
    private String status;
    private int renterId;
    private Integer assignedInternalUserId;
    private Integer requestId;
    private Integer contractId;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public SupportConversation() {
    }

    public SupportConversation(int conversationId, String subject, String status, int renterId,
            Integer assignedInternalUserId, Integer requestId, Integer contractId,
            Timestamp createdAt, Timestamp updatedAt) {
        this.conversationId = conversationId;
        this.subject = subject;
        this.status = status;
        this.renterId = renterId;
        this.assignedInternalUserId = assignedInternalUserId;
        this.requestId = requestId;
        this.contractId = contractId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getConversationId() {
        return conversationId;
    }

    public void setConversationId(int conversationId) {
        this.conversationId = conversationId;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getRenterId() {
        return renterId;
    }

    public void setRenterId(int renterId) {
        this.renterId = renterId;
    }

    public Integer getAssignedInternalUserId() {
        return assignedInternalUserId;
    }

    public void setAssignedInternalUserId(Integer assignedInternalUserId) {
        this.assignedInternalUserId = assignedInternalUserId;
    }

    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public Integer getContractId() {
        return contractId;
    }

    public void setContractId(Integer contractId) {
        this.contractId = contractId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class StaffAssignment {

    private int assignmentId;
    private Date assignedDate;
    private int assignedTo;
    private int warehouseId;
    private int assignedBy;
    private int assignmentType;
    private String description;
    private Timestamp assignedAt;
    private Timestamp dueDate;
    private Timestamp startedAt;
    private Timestamp completedAt;
    private int status;
    private int isOverdue;

    // Quan hệ 1-N
    private List<StaffAssignmentItem> items;

    public StaffAssignment() {
    }

    public StaffAssignment(int assignmentId, Date assignedDate, int assignedTo, int warehouseId, int assignedBy, int assignmentType, String description, Timestamp assignedAt, Timestamp dueDate, Timestamp startedAt, Timestamp completedAt, int status, int isOverdue, List<StaffAssignmentItem> items) {
        this.assignmentId = assignmentId;
        this.assignedDate = assignedDate;
        this.assignedTo = assignedTo;
        this.warehouseId = warehouseId;
        this.assignedBy = assignedBy;
        this.assignmentType = assignmentType;
        this.description = description;
        this.assignedAt = assignedAt;
        this.dueDate = dueDate;
        this.startedAt = startedAt;
        this.completedAt = completedAt;
        this.status = status;
        this.isOverdue = isOverdue;
        this.items = items;
    }
    
    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public Date getAssignedDate() {
        return assignedDate;
    }

    public void setAssignedDate(Date assignedDate) {
        this.assignedDate = assignedDate;
    }

    public int getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(int assignedTo) {
        this.assignedTo = assignedTo;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public int getAssignedBy() {
        return assignedBy;
    }

    public void setAssignedBy(int assignedBy) {
        this.assignedBy = assignedBy;
    }

    public int getAssignmentType() {
        return assignmentType;
    }

    public void setAssignmentType(int assignmentType) {
        this.assignmentType = assignmentType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Timestamp assignedAt) {
        this.assignedAt = assignedAt;
    }

    public Timestamp getDueDate() {
        return dueDate;
    }

    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }

    public Timestamp getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(Timestamp startedAt) {
        this.startedAt = startedAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getIsOverdue() {
        return isOverdue;
    }

    public void setIsOverdue(int isOverdue) {
        this.isOverdue = isOverdue;
    }

    public List<StaffAssignmentItem> getItems() {
        return items;
    }

    public void setItems(List<StaffAssignmentItem> items) {
        this.items = items;
    }
}


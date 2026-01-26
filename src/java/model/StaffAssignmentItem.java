/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hao23
 */
public class StaffAssignmentItem {

    private int assignmentItemId;
    private int assignmentId;
    private int itemId;
    private String itemName;
    private int quantity;
    private String note;

    public StaffAssignmentItem() {
    }

    public StaffAssignmentItem(int assignmentItemId, int assignmentId, int itemId,
                               String itemName, int quantity, String note) {
        this.assignmentItemId = assignmentItemId;
        this.assignmentId = assignmentId;
        this.itemId = itemId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.note = note;
    }

    public int getAssignmentItemId() {
        return assignmentItemId;
    }

    public void setAssignmentItemId(int assignmentItemId) {
        this.assignmentItemId = assignmentItemId;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}


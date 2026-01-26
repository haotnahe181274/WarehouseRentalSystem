/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author hao23
 */
public class StaffAssignment {
    private int assignmentId;
    private Date assignedDate;
    private InternalUser internalUser;
    private Warehouse warehouse;

    public StaffAssignment() {
    }

    public StaffAssignment(int assignmentId, Date assignedDate, InternalUser internalUser, Warehouse warehouse) {
        this.assignmentId = assignmentId;
        this.assignedDate = assignedDate;
        this.internalUser = internalUser;
        this.warehouse = warehouse;
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

    public InternalUser getInternalUser() {
        return internalUser;
    }

    public void setInternalUser(InternalUser internalUser) {
        this.internalUser = internalUser;
    }

    public Warehouse getWarehouse() {
        return warehouse;
    }

    public void setWarehouse(Warehouse warehouse) {
        this.warehouse = warehouse;
    }
    
    
}

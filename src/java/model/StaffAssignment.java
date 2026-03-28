package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class StaffAssignment {

    // Columns that actually exist in Staff_assignment table
    private int assignmentId;
    private int assignedTo;
    private int warehouseId;
    private Integer unitId;           // nullable
    private int assignmentType;       // 1=check-in, 2=check-out
    private Integer checkRequestId;   // nullable
    private String description;
    private Date startedDate;
    private Date dueDate;
    private Timestamp completedAt;    // null = not yet completed

    // Joined display fields (not in DB, populated by DAO query)
    private String staffName;
    private String warehouseName;
    private String unitCode;

    // One-to-many relationship
    private List<StaffAssignmentItem> items;

    public StaffAssignment() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getAssignmentId()                    { return assignmentId; }
    public void setAssignmentId(int assignmentId)   { this.assignmentId = assignmentId; }

    public int getAssignedTo()                      { return assignedTo; }
    public void setAssignedTo(int assignedTo)       { this.assignedTo = assignedTo; }

    public int getWarehouseId()                     { return warehouseId; }
    public void setWarehouseId(int warehouseId)     { this.warehouseId = warehouseId; }

    public Integer getUnitId()                      { return unitId; }
    public void setUnitId(Integer unitId)           { this.unitId = unitId; }

    public int getAssignmentType()                  { return assignmentType; }
    public void setAssignmentType(int assignmentType) { this.assignmentType = assignmentType; }

    public Integer getCheckRequestId()              { return checkRequestId; }
    public void setCheckRequestId(Integer id)       { this.checkRequestId = id; }

    public String getDescription()                  { return description; }
    public void setDescription(String description)  { this.description = description; }

    public Date getStartedDate()                    { return startedDate; }
    public void setStartedDate(Date startedDate)    { this.startedDate = startedDate; }

    public Date getDueDate()                        { return dueDate; }
    public void setDueDate(Date dueDate)            { this.dueDate = dueDate; }

    public Timestamp getCompletedAt()               { return completedAt; }
    public void setCompletedAt(Timestamp completedAt) { this.completedAt = completedAt; }

    public String getStaffName()                    { return staffName; }
    public void setStaffName(String staffName)      { this.staffName = staffName; }

    public String getWarehouseName()                { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }

    public String getUnitCode()                     { return unitCode; }
    public void setUnitCode(String unitCode)        { this.unitCode = unitCode; }

    public List<StaffAssignmentItem> getItems()     { return items; }
    public void setItems(List<StaffAssignmentItem> items) { this.items = items; }

    // ── Helpers for JSP ───────────────────────────────────────

    /** Returns true if the assignment has not been completed yet. */
    public boolean isPending() {
        return completedAt == null;
    }

    /** Returns human-readable assignment type label. */
    public String getAssignmentTypeLabel() {
        switch (assignmentType) {
            case 1: return "Check-in";
            case 2: return "Check-out";
            default: return "General";
        }
    }

    /** Returns true if past due date and not yet completed. */
    public boolean isOverdue() {
        if (completedAt != null) return false;
        if (dueDate == null) return false;
        return dueDate.before(new java.util.Date());
    }
}
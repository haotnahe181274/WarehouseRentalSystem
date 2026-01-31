package model;

import java.sql.Timestamp;

public class CheckInTask {

    private int assignmentId;
    private String renterName;
    private Timestamp startDate;
    private Timestamp endDate;
    private String unitCode;
    private int status;   // ✅ thêm

    public CheckInTask(int assignmentId,
                       String renterName,
                       Timestamp startDate,
                       Timestamp endDate,
                       String unitCode,
                       int status) {

        this.assignmentId = assignmentId;
        this.renterName = renterName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.unitCode = unitCode;
        this.status = status;
    }

    // ===== getters =====

    public int getAssignmentId() {
        return assignmentId;
    }

    public String getRenterName() {
        return renterName;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public String getUnitCode() {
        return unitCode;
    }

    public int getStatus() {          // ✅ thêm
        return status;
    }
}

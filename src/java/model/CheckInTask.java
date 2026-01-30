package model;

import java.sql.Timestamp;

public class CheckInTask {
    private String renterName;
    private Timestamp startDate;
    private Timestamp endDate;
    private String unitCode;

    public CheckInTask() {}

    public CheckInTask(String renterName, Timestamp startDate, Timestamp endDate, String unitCode) {
        this.renterName = renterName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.unitCode = unitCode;
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
}

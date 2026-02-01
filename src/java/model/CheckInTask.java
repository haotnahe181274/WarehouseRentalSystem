package model;

import java.sql.Timestamp;

public class CheckInTask {

    private int csuId;       
    private int contractId;
    private String renterName;
    private String unitCode;
    private Timestamp startDate;
    private Timestamp endDate;
    private int status;

    public CheckInTask(int csuId, int contractId, String renterName,
                       String unitCode, Timestamp startDate,
                       Timestamp endDate, int status) {
        this.csuId = csuId;
        this.contractId = contractId;
        this.renterName = renterName;
        this.unitCode = unitCode;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    // getters
    public int getCsuId() { return csuId; }
    public int getContractId() { return contractId; }
    public String getRenterName() { return renterName; }
    public String getUnitCode() { return unitCode; }
    public Timestamp getStartDate() { return startDate; }
    public Timestamp getEndDate() { return endDate; }
    public int getStatus() { return status; }
}

package model;

import java.util.Date;

public class IncidentReport {

    private int reportId;
    private String type;
    private String description;
    private Date reportDate;
    private int status;
    private int warehouseId;
    private int internalUserId;
     private String warehouseName;
    private String staffName;

    public IncidentReport() {}

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getReportDate() { return reportDate; }
    public void setReportDate(Date reportDate) { this.reportDate = reportDate; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public int getWarehouseId() { return warehouseId; }
    public void setWarehouseId(int warehouseId) { this.warehouseId = warehouseId; }

    public int getInternalUserId() { return internalUserId; }
    public void setInternalUserId(int internalUserId) {
        this.internalUserId = internalUserId;
    }
}

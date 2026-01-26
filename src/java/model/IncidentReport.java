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
public class IncidentReport {
    private int reportId;
    private String type;
    private String description;
    private Date reportDate;
    private int status;
    private Warehouse warehouse;
    private InternalUser internalUser;

    public IncidentReport() {
    }

    public IncidentReport(int reportId, String type, String description, Date reportDate, int status, Warehouse warehouse, InternalUser internalUser) {
        this.reportId = reportId;
        this.type = type;
        this.description = description;
        this.reportDate = reportDate;
        this.status = status;
        this.warehouse = warehouse;
        this.internalUser = internalUser;
    }
    
    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getReportDate() {
        return reportDate;
    }

    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Warehouse getWarehouse() {
        return warehouse;
    }

    public void setWarehouse(Warehouse warehouse) {
        this.warehouse = warehouse;
    }

    public InternalUser getInternalUser() {
        return internalUser;
    }

    public void setInternalUser(InternalUser internalUser) {
        this.internalUser = internalUser;
    }
    
    
}

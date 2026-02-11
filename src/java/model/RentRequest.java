/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
import java.util.Date;

/**
 *
 * @author hao23
 */
public class RentRequest {
    private int requestId;
    private Date requestDate;
    private int status;
    private String requestType;
    private Renter renter;
    private Warehouse warehouse;
    private InternalUser processedBy;
    private Date processedDate;
    private LocalDate startDate;
    private LocalDate endDate;

    public RentRequest(int requestId, Date requestDate, int status, String requestType, Renter renter, Warehouse warehouse, InternalUser processedBy, Date processedDate, LocalDate startDate, LocalDate endDate) {
        this.requestId = requestId;
        this.requestDate = requestDate;
        this.status = status;
        this.requestType = requestType;
        this.renter = renter;
        this.warehouse = warehouse;
        this.processedBy = processedBy;
        this.processedDate = processedDate;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public RentRequest() {
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public Renter getRenter() {
        return renter;
    }

    public void setRenter(Renter renter) {
        this.renter = renter;
    }

    public Warehouse getWarehouse() {
        return warehouse;
    }

    public void setWarehouse(Warehouse warehouse) {
        this.warehouse = warehouse;
    }

    public InternalUser getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(InternalUser processedBy) {
        this.processedBy = processedBy;
    }

    public Date getProcessedDate() {
        return processedDate;
    }

    public void setProcessedDate(Date processedDate) {
        this.processedDate = processedDate;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    

    

    
}

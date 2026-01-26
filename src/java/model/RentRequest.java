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
public class RentRequest {
    private int requestId;
    private Date requestDate;
    private int status;
    private Renter renter;
    private Warehouse warehouse;
    private InternalUser processedBy;
    private Date processedDate;

    public RentRequest() {
    }

    public RentRequest(int requestId, Date requestDate, int status, Renter renter, Warehouse warehouse, InternalUser processedBy, Date processedDate) {
        this.requestId = requestId;
        this.requestDate = requestDate;
        this.status = status;
        this.renter = renter;
        this.warehouse = warehouse;
        this.processedBy = processedBy;
        this.processedDate = processedDate;
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

    
}

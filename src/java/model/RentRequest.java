/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class RentRequest {

    private int requestId;
    private Date requestDate;
    private int status;
    private String requestType;
    private Renter renter;
    private Warehouse warehouse;
    private double area;

    private InternalUser processedBy;
    private Date processedDate;
    private Date startDate;
    private Date endDate;

    private List<RentRequestItem> items;

    public RentRequest() {
        items = new ArrayList<>();
    }

    public RentRequest(int requestId, Date requestDate, int status, String requestType, Renter renter, Warehouse warehouse, double area, InternalUser processedBy, Date processedDate, Date startDate, Date endDate, List<RentRequestItem> items) {
        this.requestId = requestId;
        this.requestDate = requestDate;
        this.status = status;
        this.requestType = requestType;
        this.renter = renter;
        this.warehouse = warehouse;
        this.area = area;
        this.processedBy = processedBy;
        this.processedDate = processedDate;
        this.startDate = startDate;
        this.endDate = endDate;
        this.items = items;
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

    public double getArea() {
        return area;
    }

    public void setArea(double area) {
        this.area = area;
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

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    

    public List<RentRequestItem> getItems() {
        return items;
    }

    public void setItems(List<RentRequestItem> items) {
        this.items = items;
    }
    

}

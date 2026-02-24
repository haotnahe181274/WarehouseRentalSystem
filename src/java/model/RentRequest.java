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
    private Renter renter;
    private Warehouse warehouse;
    private InternalUser processedBy;
    private Date processedDate;

    private List<RentRequestItem> items;
    /** Các unit trong request (mỗi unit: ngày, diện tích, giá riêng). */
    private List<RentRequestUnit> units;

    public RentRequest() {
        items = new ArrayList<>();
        units = new ArrayList<>();
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


    public List<RentRequestItem> getItems() {
        return items;
    }

    public void setItems(List<RentRequestItem> items) {
        this.items = items;
    }

    public List<RentRequestUnit> getUnits() {
        return units;
    }

    public void setUnits(List<RentRequestUnit> units) {
        this.units = units;
    }

    /** Tổng tiền các unit (để hiển thị). */
    public double getTotalUnitsPrice() {
        if (units == null || units.isEmpty()) return 0;
        return units.stream().mapToDouble(RentRequestUnit::getRentPrice).sum();
    }
}

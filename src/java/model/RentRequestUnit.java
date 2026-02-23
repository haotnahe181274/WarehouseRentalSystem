/*
 * Model: một unit trong rent request (ngày, diện tích, giá riêng).
 */
package model;

import java.util.Date;

public class RentRequestUnit {

    private int id;
    private int requestId;
    private double area;
    private Date startDate;
    private Date endDate;
    private double rentPrice;

    public RentRequestUnit() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public double getArea() {
        return area;
    }

    public void setArea(double area) {
        this.area = area;
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

    public double getRentPrice() {
        return rentPrice;
    }

    public void setRentPrice(double rentPrice) {
        this.rentPrice = rentPrice;
    }
}

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
public class Contract {
    private int contractId;
    private Date startDate;
    private Date endDate;
    private int status;
    private double price;
    private Renter renter;
    private Warehouse warehouse;

    public Contract() {
    }

    public Contract(int contractId, Date startDate, Date endDate, int status, Renter renter, Warehouse warehouse) {
        this.contractId = contractId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.renter = renter;
        this.warehouse = warehouse;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
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

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
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

    
    
}

package model;

import java.util.Date;

public class UnitContractView {

    // 🔥 QUAN TRỌNG NHẤT
    private int csuId;        // Contract_Storage_unit.id

    private int contractId;
    private int status;

    private String renterName;
    private String unitCode;

    private Date checkInDate;
    private Date checkOutDate;

    private String itemName;
    private String description;

    // ===== csuId =====
    public int getCsuId() {
        return csuId;
    }

    public void setCsuId(int csuId) {
        this.csuId = csuId;
    }

    // ===== contractId =====
    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    // ===== status =====
    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    // ===== renter =====
    public String getRenterName() {
        return renterName;
    }

    public void setRenterName(String renterName) {
        this.renterName = renterName;
    }

    // ===== unit =====
    public String getUnitCode() {
        return unitCode;
    }

    public void setUnitCode(String unitCode) {
        this.unitCode = unitCode;
    }

    // ===== dates =====
    public Date getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(Date checkInDate) {
        this.checkInDate = checkInDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    // ===== items =====
    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    public int getUnitStatusCode() {
        return status;
    }
}

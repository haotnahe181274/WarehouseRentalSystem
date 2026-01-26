/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hao23
 */
public class StorageUnit {
    private int unitId;
    private String unitCode;
    private int status;
    private double area;
    private double pricePerUnit;
    private String description;
    private Warehouse warehouse;

    public StorageUnit() {
    }

    public StorageUnit(int unitId, String unitCode, int status, double area, double pricePerUnit, String description, Warehouse warehouse) {
        this.unitId = unitId;
        this.unitCode = unitCode;
        this.status = status;
        this.area = area;
        this.pricePerUnit = pricePerUnit;
        this.description = description;
        this.warehouse = warehouse;
    }

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public String getUnitCode() {
        return unitCode;
    }

    public void setUnitCode(String unitCode) {
        this.unitCode = unitCode;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public double getArea() {
        return area;
    }

    public void setArea(double area) {
        this.area = area;
    }

    public double getPricePerUnit() {
        return pricePerUnit;
    }

    public void setPricePerUnit(double pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Warehouse getWarehouse() {
        return warehouse;
    }

    public void setWarehouse(Warehouse warehouse) {
        this.warehouse = warehouse;
    }

    
    
}

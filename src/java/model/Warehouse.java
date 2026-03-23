package model;

public class Warehouse {

    private int warehouseId;
    private String name;
    private String address;
    private String description;
    private int status;
    private WarehouseType warehouseType;
    private Double minPrice;
    private Double minArea;
    private double totalArea; // ← THÊM MỚI: tổng diện tích của kho

    public Warehouse() {
    }

    public Warehouse(int warehouseId, String name, String address, String description, int status, WarehouseType warehouseType) {
        this.warehouseId = warehouseId;
        this.name = name;
        this.address = address;
        this.description = description;
        this.status = status;
        this.warehouseType = warehouseType;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String desc) {
        this.description = desc;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public WarehouseType getWarehouseType() {
        return warehouseType;
    }

    public void setWarehouseType(WarehouseType warehouseType) {
        this.warehouseType = warehouseType;
    }

    public Double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(Double minPrice) {
        this.minPrice = minPrice;
    }

    public Double getMinArea() {
        return minArea;
    }

    public void setMinArea(Double minArea) {
        this.minArea = minArea;
    }

    public double getTotalArea() {
        return totalArea;
    }

    public void setTotalArea(double totalArea) {
        this.totalArea = totalArea;
    }
}

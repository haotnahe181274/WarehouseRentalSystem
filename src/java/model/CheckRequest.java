package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/** Đơn check in/out (header). */
public class CheckRequest {
    private int id;
    private Date requestDate;
    private String requestType; // CHECK_IN | CHECK_OUT
    private int renterId;
    private int warehouseId;
    private int unitId;
    private Integer internalUserId;
    private Date processedDate;

    private Renter renter;
    private Warehouse warehouse;
    private StorageUnit unit;
    private List<CheckRequestItem> items = new ArrayList<>();
    // Trạng thái tổng suy ra từ các CheckRequestItem: processing | done | fail
    private String overallStatus;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }
    public String getRequestType() { return requestType; }
    public void setRequestType(String requestType) { this.requestType = requestType; }
    public int getRenterId() { return renterId; }
    public void setRenterId(int renterId) { this.renterId = renterId; }
    public int getWarehouseId() { return warehouseId; }
    public void setWarehouseId(int warehouseId) { this.warehouseId = warehouseId; }
    public int getUnitId() { return unitId; }
    public void setUnitId(int unitId) { this.unitId = unitId; }
    public Integer getInternalUserId() { return internalUserId; }
    public void setInternalUserId(Integer internalUserId) { this.internalUserId = internalUserId; }
    public Date getProcessedDate() { return processedDate; }
    public void setProcessedDate(Date processedDate) { this.processedDate = processedDate; }
    public Renter getRenter() { return renter; }
    public void setRenter(Renter renter) { this.renter = renter; }
    public Warehouse getWarehouse() { return warehouse; }
    public void setWarehouse(Warehouse warehouse) { this.warehouse = warehouse; }
    public StorageUnit getUnit() { return unit; }
    public void setUnit(StorageUnit unit) { this.unit = unit; }
    public List<CheckRequestItem> getItems() { return items; }
    public void setItems(List<CheckRequestItem> items) { this.items = items != null ? items : new ArrayList<>(); }

    public String getOverallStatus() { return overallStatus; }
    public void setOverallStatus(String overallStatus) { this.overallStatus = overallStatus; }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hao23
 */
public class WarehouseType {
    private int warehouseTypeId;
    private String typeName;
    private String description;

    public WarehouseType() {
    }

    public WarehouseType(int warehouseTypeId, String typeName, String description) {
        this.warehouseTypeId = warehouseTypeId;
        this.typeName = typeName;
        this.description = description;
    }

    public int getWarehouseTypeId() {
        return warehouseTypeId;
    }

    public void setWarehouseTypeId(int warehouseTypeId) {
        this.warehouseTypeId = warehouseTypeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    
}

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
public class WarehouseImage {
    private int imageId;
    private String imageUrl;
    private String imageType;
    private boolean primary;
    private int status;
    private Date createAt;
    private Warehouse warehouse;

    public WarehouseImage() {
    }

   
    
    public WarehouseImage(int imageId, String imageUrl, String imageType, boolean primary, int status, Date createAt, Warehouse warehouse) {
        this.imageId = imageId;
        this.imageUrl = imageUrl;
        this.imageType = imageType;
        this.primary = primary;
        this.status = status;
        this.createAt = createAt;
        this.warehouse = warehouse;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getImageType() {
        return imageType;
    }

    public void setImageType(String imageType) {
        this.imageType = imageType;
    }

    public boolean isPrimary() {
        return primary;
    }

    public void setPrimary(boolean primary) {
        this.primary = primary;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public Warehouse getWarehouse() {
        return warehouse;
    }

    public void setWarehouse(Warehouse warehouse) {
        this.warehouse = warehouse;
    }
    
}

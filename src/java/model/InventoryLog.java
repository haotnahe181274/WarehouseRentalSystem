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
public class InventoryLog {
    private int logId;
    private int action;
    private int quantity;
    private Date actionDate;
    private Item item;
    private StorageUnit storageUnit;
    private InternalUser internalUser;

    public InventoryLog() {
    }

    public InventoryLog(int logId, int action, int quantity, Date actionDate, Item item, StorageUnit storageUnit, InternalUser internalUser) {
        this.logId = logId;
        this.action = action;
        this.quantity = quantity;
        this.actionDate = actionDate;
        this.item = item;
        this.storageUnit = storageUnit;
        this.internalUser = internalUser;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getAction() {
        return action;
    }

    public void setAction(int action) {
        this.action = action;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getActionDate() {
        return actionDate;
    }

    public void setActionDate(Date actionDate) {
        this.actionDate = actionDate;
    }

    public Item getItem() {
        return item;
    }

    public void setItem(Item item) {
        this.item = item;
    }

    public StorageUnit getStorageUnit() {
        return storageUnit;
    }

    public void setStorageUnit(StorageUnit storageUnit) {
        this.storageUnit = storageUnit;
    }

    public InternalUser getInternalUser() {
        return internalUser;
    }

    public void setInternalUser(InternalUser internalUser) {
        this.internalUser = internalUser;
    }
    
}

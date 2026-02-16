/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ad
 */
public class StorageUnitItem {
    private int id;
    private int quantity;
    private Item item;
    private StorageUnit unit;

    public StorageUnitItem() {
    }

    public StorageUnitItem(int id, int quantity, Item item, StorageUnit unit) {
        this.id = id;
        this.quantity = quantity;
        this.item = item;
        this.unit = unit;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Item getItem() {
        return item;
    }

    public void setItem(Item item) {
        this.item = item;
    }

    public StorageUnit getUnit() {
        return unit;
    }

    public void setUnit(StorageUnit unit) {
        this.unit = unit;
    }
    
    
}

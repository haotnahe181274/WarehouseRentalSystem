/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ad
 */
/** Item khai báo trong đơn thuê kho (không có quantity). */
public class RentRequestItem {
    private int id;
    private Item item;

    public RentRequestItem() {
    }

    public RentRequestItem(int id, Item item) {
        this.id = id;
        this.item = item;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Item getItem() {
        return item;
    }

    public void setItem(Item item) {
        this.item = item;
    }

    
    
    
}

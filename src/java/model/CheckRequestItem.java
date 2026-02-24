package model;

/** Một dòng item trong đơn check in/out. */
public class CheckRequestItem {
    private int id;
    private int checkRequestId;
    private int itemId;
    private int quantity;
    private Integer processedQuantity;
    private String status; // processing | done | fail

    private Item item;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCheckRequestId() { return checkRequestId; }
    public void setCheckRequestId(int checkRequestId) { this.checkRequestId = checkRequestId; }
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public Integer getProcessedQuantity() { return processedQuantity; }
    public void setProcessedQuantity(Integer processedQuantity) { this.processedQuantity = processedQuantity; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Item getItem() { return item; }
    public void setItem(Item item) { this.item = item; }
}

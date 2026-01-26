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
public class Contract {
    private int contractId;
    private Date startDate;
    private Date endDate;
    private int status;
    private Renter renter;
    private Warehouse warehouse;

    public Contract() {
    }

    public Contract(int contractId, Date startDate, Date endDate, int status, Renter renter, Warehouse warehouse) {
        this.contractId = contractId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.renter = renter;
        this.warehouse = warehouse;
    }

    
    
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ASUS
 */
import Model.enums.StaffStatus;

public class ContractStaff {

    private int id;
    private int contractId;
    private int staffId;

    private StaffStatus status;

    public ContractStaff() {
    }

    public ContractStaff(int id, int contractId, int staffId, StaffStatus status) {
        this.id = id;
        this.contractId = contractId;
        this.staffId = staffId;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public StaffStatus getStatus() {
        return status;
    }

    public void setStatus(StaffStatus status) {
        this.status = status;
    } 
}

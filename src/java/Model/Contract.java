/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ASUS
 */

import java.util.Date;
import Model.enums.ContractStatus;

public class Contract {

    private int id;

    private int surveyRequestId;
    private int managerId;

    private double totalPrice;

    private ContractStatus status;

    private Date signedAt;

    public Contract() {
    }

    public Contract(int id, int surveyRequestId, int managerId,
                    double totalPrice, ContractStatus status, Date signedAt) {
        this.id = id;
        this.surveyRequestId = surveyRequestId;
        this.managerId = managerId;
        this.totalPrice = totalPrice;
        this.status = status;
        this.signedAt = signedAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSurveyRequestId() {
        return surveyRequestId;
    }

    public void setSurveyRequestId(int surveyRequestId) {
        this.surveyRequestId = surveyRequestId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public ContractStatus getStatus() {
        return status;
    }

    public void setStatus(ContractStatus status) {
        this.status = status;
    }

    public Date getSignedAt() {
        return signedAt;
    }

    public void setSignedAt(Date signedAt) {
        this.signedAt = signedAt;
    } 
}

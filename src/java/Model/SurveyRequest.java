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
import Model.enums.SurveyStatus;

public class SurveyRequest {
    
    private int id;

    private int customerId;
    private int servicePackageId;

    private String pickupAddress;
    private String deliveryAddress;

    private double distanceKm;

    private int extraStaff;
    private int extraVehicle;

    private double totalPrice;

    private SurveyStatus status;

    private Date createdAt;

    public SurveyRequest() {
    }

    public SurveyRequest(int id, int customerId, int servicePackageId,
                         String pickupAddress, String deliveryAddress,
                         double distanceKm, int extraStaff, int extraVehicle,
                         double totalPrice, SurveyStatus status, Date createdAt) {
        this.id = id;
        this.customerId = customerId;
        this.servicePackageId = servicePackageId;
        this.pickupAddress = pickupAddress;
        this.deliveryAddress = deliveryAddress;
        this.distanceKm = distanceKm;
        this.extraStaff = extraStaff;
        this.extraVehicle = extraVehicle;
        this.totalPrice = totalPrice;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getServicePackageId() {
        return servicePackageId;
    }

    public void setServicePackageId(int servicePackageId) {
        this.servicePackageId = servicePackageId;
    }

    public String getPickupAddress() {
        return pickupAddress;
    }

    public void setPickupAddress(String pickupAddress) {
        this.pickupAddress = pickupAddress;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public int getExtraStaff() {
        return extraStaff;
    }

    public void setExtraStaff(int extraStaff) {
        this.extraStaff = extraStaff;
    }

    public int getExtraVehicle() {
        return extraVehicle;
    }

    public void setExtraVehicle(int extraVehicle) {
        this.extraVehicle = extraVehicle;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public SurveyStatus getStatus() {
        return status;
    }

    public void setStatus(SurveyStatus status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    
}

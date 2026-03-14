/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.enums;

/**
 *
 * @author ASUS
 */

public enum VehicleStatus {

    AVAILABLE("AVAILABLE", "Sẵn sàng"),
    ASSIGNED("ASSIGNED", "Đã phân công"),
    MAINTENANCE("MAINTENANCE", "Bảo trì");

    private final String value;
    private final String label;

    VehicleStatus(String value, String label) {
        this.value = value;
        this.label = label;
    }

    public String getValue() {
        return value;
    }

    public String getLabel() {
        return label;
    }

    public static VehicleStatus fromValue(String value) {
        for (VehicleStatus status : VehicleStatus.values()) {
            if (status.value.equalsIgnoreCase(value)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid VehicleStatus: " + value);
    }

    // Xe có thể dùng được không?
    public boolean isAvailable() {
        return this == AVAILABLE;
    }

    // Xe đang được sử dụng?
    public boolean isBusy() {
        return this == ASSIGNED;
    }
}

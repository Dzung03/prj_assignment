/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.enums;

/**
 *
 * @author ASUS
 */

public enum StaffStatus {

    AVAILABLE("AVAILABLE", "Đang rảnh"),
    BUSY("BUSY", "Đang thực hiện hợp đồng");

    private final String value;
    private final String label;

    StaffStatus(String value, String label) {
        this.value = value;
        this.label = label;
    }

    public String getValue() {
        return value;
    }

    public String getLabel() {
        return label;
    }
}

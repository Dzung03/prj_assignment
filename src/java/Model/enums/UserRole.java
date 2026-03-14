/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.enums;

/**
 *
 * @author ASUS
 */
public enum  UserRole {
    ADMIN("ADMIN", "Quản trị viên"),
    MANAGER("MANAGER", "Quản lý"),
    STAFF("STAFF", "Nhân viên"),
    CUSTOMER("CUSTOMER", "Khách hàng");

    private final String value;
    private final String label;

    UserRole(String value, String label) {
        this.value = value;
        this.label = label;
    }

    public String getValue() {
        return value;
    }

    public String getLabel() {
        return label;
    }

    public static UserRole fromValue(String value) {
        for (UserRole role : UserRole.values()) {
            if (role.value.equalsIgnoreCase(value)) {
                return role;
            }
        }
        throw new IllegalArgumentException("Invalid UserRole: " + value);
    }
}

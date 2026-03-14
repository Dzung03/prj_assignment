/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.enums;

/**
 *
 * @author ASUS
 */
public enum SurveyStatus {
    PENDING("PENDING", "Chờ duyệt"),
    APPROVED("APPROVED", "Đã duyệt"),
    REJECTED("REJECTED", "Từ chối");

    private final String value;
    private final String label;

    SurveyStatus(String value, String label) {
        this.value = value;
        this.label = label;
    }

    public String getValue() {
        return value;
    }

    public String getLabel() {
        return label;
    }

    public static SurveyStatus fromValue(String value) {
        for (SurveyStatus status : SurveyStatus.values()) {
            if (status.value.equalsIgnoreCase(value)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid SurveyStatus: " + value);
    }
}

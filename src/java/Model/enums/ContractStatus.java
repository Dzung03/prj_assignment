/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.enums;

/**
 *
 * @author ASUS
 */
import java.util.Arrays;
import java.util.List;
public enum ContractStatus {
    
    CREATED("CREATED", "Đã tạo"),
    CONFIRMED("CONFIRMED", "Đã xác nhận"),
    IN_PROGRESS("IN_PROGRESS", "Đang thực hiện"),
    COMPLETED("COMPLETED", "Hoàn thành"),
    CANCELLED("CANCELLED", "Đã hủy");
    
    private final String value;
    private final String label;
    
    ContractStatus(String value, String label) {
        this.value = value;
        this.label = label;
    }

    public String getValue() {
        return value;
    }

    public String getLabel() {
        return label;
    }
     // Convert từ DB -> Enum
    public static ContractStatus fromValue(String value) {
        for (ContractStatus status : ContractStatus.values()) {
            if (status.value.equalsIgnoreCase(value)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid ContractStatus: " + value);
    }

    // Kiểm soát chuyển trạng thái hợp lệ
    public boolean canTransitionTo(ContractStatus newStatus) {

        switch (this) {

            case CREATED:
                return Arrays.asList(CONFIRMED, CANCELLED).contains(newStatus);

            case CONFIRMED:
                return Arrays.asList(IN_PROGRESS, CANCELLED).contains(newStatus);

            case IN_PROGRESS:
                return Arrays.asList(COMPLETED).contains(newStatus);

            case COMPLETED:
                return false;

            case CANCELLED:
                return false;

            default:
                return false;
        }
    }
}

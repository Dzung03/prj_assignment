package Model;

import java.time.LocalDateTime;
public class ServicePackage {

    // ID của package (Primary Key)
    private int id;

    // Tên gói dịch vụ
    private String name;

    // Mô tả gói dịch vụ
    private String description;

    // ===== DEFAULT CONFIGURATION =====

    // Giá cơ bản của gói
    private double defaultBasePrice;

    // Số nhân viên mặc định
    private int defaultStaff;

    // Số xe mặc định
    private int defaultVehicle;

    // ===== DISTANCE PRICING =====

    // Giá tính thêm cho mỗi km
    private double pricePerKm;

    // ===== EXTRA SERVICE PRICING =====
    private double extraStaffPrice;    // giá thêm mỗi nhân viên 
    private double extraVehiclePrice;  // giá thêm mỗi xe

    // Trạng thái hoạt động của gói
    private boolean active;

    // Thời điểm tạo
    private LocalDateTime createdAt;

    // Thời điểm cập nhật
    private LocalDateTime updatedAt;

    // Constructor rỗng (dùng cho DAO mapping)
    public ServicePackage() {
    }

    // Constructor đầy đủ
    public ServicePackage(int id, String name, String description, double defaultBasePrice,
                          int defaultStaff, int defaultVehicle, double pricePerKm,
                          double extraStaffPrice, double extraVehiclePrice, boolean active) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.defaultBasePrice = defaultBasePrice;
        this.defaultStaff = defaultStaff;
        this.defaultVehicle = defaultVehicle;
        this.pricePerKm = pricePerKm;
        this.extraStaffPrice = extraStaffPrice;
        this.extraVehiclePrice = extraVehiclePrice;
        this.active = active;
    }

    // ===== GETTERS & SETTERS =====

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getDefaultBasePrice() {
        return defaultBasePrice;
    }

    public void setDefaultBasePrice(double defaultBasePrice) {
        this.defaultBasePrice = defaultBasePrice;
    }

    public int getDefaultStaff() {
        return defaultStaff;
    }

    public void setDefaultStaff(int defaultStaff) {
        this.defaultStaff = defaultStaff;
    }

    public int getDefaultVehicle() {
        return defaultVehicle;
    }

    public void setDefaultVehicle(int defaultVehicle) {
        this.defaultVehicle = defaultVehicle;
    }

    public double getPricePerKm() {
        return pricePerKm;
    }

    public void setPricePerKm(double pricePerKm) {
        this.pricePerKm = pricePerKm;
    }

    public double getExtraStaffPrice() {
        return extraStaffPrice;
    }

    public void setExtraStaffPrice(double extraStaffPrice) {
        this.extraStaffPrice = extraStaffPrice;
    }

    public double getExtraVehiclePrice() {
        return extraVehiclePrice;
    }

    public void setExtraVehiclePrice(double extraVehiclePrice) {
        this.extraVehiclePrice = extraVehiclePrice;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}

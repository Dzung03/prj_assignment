package Service;

import DAO.VehicleDAO;
import Model.Vehicle;
import Model.enums.VehicleStatus;

import java.util.List;

public class VehicleService {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    // ============================================================
    // GET ALL
    // ============================================================
    public List<Vehicle> getAllVehicles() {
        return vehicleDAO.findAll();
    }

    // ============================================================
    // GET BY ID
    // ============================================================
    public Vehicle getById(int id) {
        return vehicleDAO.findById(id);
    }

    // ============================================================
    // ADD
    // ============================================================
    public String addVehicle(String plateNumber, String type, String capacityStr, String statusStr) {

        // Validate biển số
        plateNumber = plateNumber == null ? "" : plateNumber.trim();
        if (plateNumber.isEmpty()) {
            return "Biển số xe không được để trống.";
        }

        // Kiểm tra trùng biển số
        if (vehicleDAO.existsByPlateNumber(plateNumber, 0)) {
            return "Biển số xe \"" + plateNumber + "\" đã tồn tại.";
        }

        // Validate loại xe
        type = type == null ? "" : type.trim();
        if (type.isEmpty()) {
            return "Loại xe không được để trống.";
        }

        // Validate sức chứa
        int capacity;
        try {
            capacity = Integer.parseInt(capacityStr);
            if (capacity <= 0) return "Sức chứa phải lớn hơn 0.";
        } catch (NumberFormatException e) {
            return "Sức chứa không hợp lệ.";
        }

        // Validate trạng thái
        VehicleStatus status;
        try {
            status = VehicleStatus.fromValue(statusStr);
        } catch (Exception e) {
            return "Trạng thái xe không hợp lệ.";
        }

        Vehicle v = new Vehicle();
        v.setVehicleCode(plateNumber);
        v.setType(type);
        v.setCapacity(capacity);
        v.setStatus(status);

        boolean ok = vehicleDAO.insert(v);
        return ok ? null : "Thêm xe thất bại, vui lòng thử lại.";
    }

    // ============================================================
    // UPDATE
    // ============================================================
    public String updateVehicle(int id, String plateNumber, String type, String capacityStr, String statusStr) {

        Vehicle existing = vehicleDAO.findById(id);
        if (existing == null) {
            return "Không tìm thấy xe cần cập nhật.";
        }

        plateNumber = plateNumber == null ? "" : plateNumber.trim();
        if (plateNumber.isEmpty()) {
            return "Biển số xe không được để trống.";
        }

        if (vehicleDAO.existsByPlateNumber(plateNumber, id)) {
            return "Biển số xe \"" + plateNumber + "\" đã tồn tại.";
        }

        type = type == null ? "" : type.trim();
        if (type.isEmpty()) {
            return "Loại xe không được để trống.";
        }

        int capacity;
        try {
            capacity = Integer.parseInt(capacityStr);
            if (capacity <= 0) return "Sức chứa phải lớn hơn 0.";
        } catch (NumberFormatException e) {
            return "Sức chứa không hợp lệ.";
        }

        VehicleStatus status;
        try {
            status = VehicleStatus.fromValue(statusStr);
        } catch (Exception e) {
            return "Trạng thái xe không hợp lệ.";
        }

        existing.setVehicleCode(plateNumber);
        existing.setType(type);
        existing.setCapacity(capacity);
        existing.setStatus(status);

        boolean ok = vehicleDAO.update(existing);
        return ok ? null : "Cập nhật xe thất bại, vui lòng thử lại.";
    }

    // ============================================================
    // DELETE
    // ============================================================
    public String deleteVehicle(int id) {
        Vehicle existing = vehicleDAO.findById(id);
        if (existing == null) {
            return "Không tìm thấy xe cần xoá.";
        }
        boolean ok = vehicleDAO.delete(id);
        return ok ? null : "Xoá xe thất bại, xe có thể đang được dùng trong hợp đồng.";
    }
}

///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package Service;
//
///**
// *
// * @author ASUS
// */
//
//import DAO.*;
//import Model.*;
//import Model.enums.ContractStatus;
//import Model.enums.VehicleStatus;
//
//import java.sql.Connection;
//import java.sql.SQLException;
//import java.util.List;
//
//public class ContractService {
//
//    private ContractDAO contractDAO;
//    private ContractStaffDAO contractStaffDAO;
//    private ContractVehicleDAO contractVehicleDAO;
//    private VehicleDAO vehicleDAO;
//    private StaffDAO staffDAO;
//    private DBConnection dbConnection;
//
//    public ContractService() {
//        this.contractDAO = new ContractDAO();
//        this.contractStaffDAO = new ContractStaffDAO();
//        this.contractVehicleDAO = new ContractVehicleDAO();
//        this.vehicleDAO = new VehicleDAO();
//        this.staffDAO = new StaffDAO();
//        this.dbConnection = new DBConnection();
//    }
//
//    /**
//     * Tạo hợp đồng + phân staff + phân xe (TRANSACTION)
//     */
//    public void createContract(
//            Contract contract,
//            List<Integer> staffIds,
//            List<Integer> vehicleIds
//    ) {
//
//        Connection conn = null;
//
//        try {
//            // 1. Mở connection & bắt đầu transaction
//            conn = dbConnection.getConnection();
//            conn.setAutoCommit(false);
//
//            // 2. Validate staff
//            for (Integer staffId : staffIds) {
//                if (staffDAO.isStaffBusy(staffId, conn)) {
//                    throw new IllegalStateException(
//                        "Nhân viên ID " + staffId + " đang bận hợp đồng khác"
//                    );
//                }
//            }
//
//            // 3. Validate vehicle
//            for (Integer vehicleId : vehicleIds) {
//                Vehicle vehicle = vehicleDAO.findById(vehicleId, conn);
//
//                if (vehicle == null) {
//                    throw new IllegalArgumentException(
//                        "Xe ID " + vehicleId + " không tồn tại"
//                    );
//                }
//
//                if (!vehicle.getStatus().equals(VehicleStatus.AVAILABLE)) {
//                    throw new IllegalStateException(
//                        "Xe ID " + vehicleId + " không sẵn sàng"
//                    );
//                }
//            }
//
//            // 4. Set trạng thái ban đầu cho contract
//            contract.setStatus(ContractStatus.CONFIRMED);
//
//            // 5. Insert contract
//            int contractId = contractDAO.insert(contract, conn);
//
//            // 6. Gán staff vào contract
//            for (Integer staffId : staffIds) {
//                contractStaffDAO.insert(contractId, staffId, conn);
//            }
//
//            // 7. Gán vehicle vào contract + update status
//            for (Integer vehicleId : vehicleIds) {
//                contractVehicleDAO.insert(contractId, vehicleId, conn);
//                vehicleDAO.updateStatus(
//                        vehicleId,
//                        VehicleStatus.ASSIGNED,
//                        conn
//                );
//            }
//
//            // 8. Commit transaction
//            conn.commit();
//
//        } catch (Exception ex) {
//
//            // 9. Rollback nếu có lỗi
//            if (conn != null) {
//                try {
//                    conn.rollback();
//                } catch (SQLException e) {
//                    e.printStackTrace();
//                }
//            }
//
//            throw new RuntimeException(
//                "Lỗi tạo hợp đồng: " + ex.getMessage(), ex
//            );
//
//        } finally {
//
//            // 10. Đóng connection
//            if (conn != null) {
//                try {
//                    conn.setAutoCommit(true);
//                    conn.close();
//                } catch (SQLException e) {
//                    e.printStackTrace();
//                }
//            }
//        }
//    }
//}

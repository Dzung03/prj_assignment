package Service;

import DAO.ServicePackageDAO;
import Model.ServicePackage;

import java.util.List;

/**
 * Service xử lý logic liên quan ServicePackage
 */
public class PackageService {

    private ServicePackageDAO packageDAO;
                                                                                                    
    public PackageService() {
        packageDAO = new ServicePackageDAO();
    }

    // Lấy tất cả package
    public List<ServicePackage> getAllPackages() {
        return packageDAO.getAllPackages();
    }

    // Lấy package đang active
    public List<ServicePackage> getActivePackages() {
        return packageDAO.getActivePackages();
    }

    // Lấy package theo id
    public ServicePackage getPackageById(int id) {
        return packageDAO.getPackageById(id);
    }

    // Tạo package mới
    public boolean createPackage(ServicePackage pkg) {
        return packageDAO.createPackage(pkg);
    }

    // Cập nhật package
    public boolean updatePackage(ServicePackage pkg) {
        return packageDAO.updatePackage(pkg);
    }

    // Xóa package
    public boolean deletePackage(int id) {
        return packageDAO.deletePackage(id);
    }
}
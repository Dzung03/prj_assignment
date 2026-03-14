package DAO;

import Model.ServicePackage;
import Util.DBConnection;
import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ServicePackageDAO {

    public List<ServicePackage> findActive() {
        String sql = """
            SELECT id, name, description,   
                   default_base_price, default_staff, default_vehicle,
                   price_per_km, extra_staff_price, extra_vehicle_price, active
            FROM ServicePackages
            WHERE active = 1
            ORDER BY id
            """;
        List<ServicePackage> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ServicePackage findById(int id) {
        String sql = """
            SELECT id, name, description,
                   default_base_price, default_staff, default_vehicle,
                   price_per_km, extra_staff_price, extra_vehicle_price, active
            FROM ServicePackages
            WHERE id = ?
            """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private ServicePackage map(ResultSet rs) throws Exception {
        ServicePackage p = new ServicePackage();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setDefaultBasePrice(rs.getDouble("default_base_price"));
        p.setDefaultStaff(rs.getInt("default_staff"));
        p.setDefaultVehicle(rs.getInt("default_vehicle"));
        p.setPricePerKm(rs.getDouble("price_per_km"));
        p.setExtraStaffPrice(rs.getDouble("extra_staff_price"));
        p.setExtraVehiclePrice(rs.getDouble("extra_vehicle_price"));
        p.setActive(rs.getBoolean("active"));
        return p;
    }
    public boolean createPackage(ServicePackage pkg) {

            String sql = "INSERT INTO ServicePackages "
                    + "(name, description, default_base_price, default_staff, default_vehicle, "
                    + "price_per_km, extra_staff_price, extra_vehicle_price, active) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, pkg.getName());
                ps.setString(2, pkg.getDescription());
                ps.setDouble(3, pkg.getDefaultBasePrice());
                ps.setInt(4, pkg.getDefaultStaff());
                ps.setInt(5, pkg.getDefaultVehicle());
                ps.setDouble(6, pkg.getPricePerKm());
                ps.setDouble(7, pkg.getExtraStaffPrice());
                ps.setDouble(8, pkg.getExtraVehiclePrice());
                ps.setBoolean(9, pkg.isActive());

                return ps.executeUpdate() > 0;

            } catch (Exception e) {
                e.printStackTrace();
            }

            return false;
        }

        // ==============================
        // GET ALL PACKAGES
        // ==============================
        public List<ServicePackage> getAllPackages() {

            List<ServicePackage> list = new ArrayList<>();

            String sql = "SELECT * FROM ServicePackages";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    ServicePackage pkg = mapResultSet(rs);

                    list.add(pkg);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            return list;
        }

        // ==============================
        // GET PACKAGE BY ID
        // ==============================
        public ServicePackage getPackageById(int id) {

            String sql = "SELECT * FROM ServicePackages WHERE id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, id);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    return mapResultSet(rs);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            return null;
        }

        // ==============================
        // UPDATE PACKAGE
        // ==============================
        public boolean updatePackage(ServicePackage pkg) {

            String sql = "UPDATE ServicePackages SET "
                    + "name=?, description=?, default_base_price=?, "
                    + "default_staff=?, default_vehicle=?, price_per_km=?, "
                    + "extra_staff_price=?, extra_vehicle_price=?, active=?, "
                    + "updated_at = GETDATE() "
                    + "WHERE id=?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, pkg.getName());
                ps.setString(2, pkg.getDescription());
                ps.setDouble(3, pkg.getDefaultBasePrice());
                ps.setInt(4, pkg.getDefaultStaff());
                ps.setInt(5, pkg.getDefaultVehicle());
                ps.setDouble(6, pkg.getPricePerKm());
                ps.setDouble(7, pkg.getExtraStaffPrice());
                ps.setDouble(8, pkg.getExtraVehiclePrice());
                ps.setBoolean(9, pkg.isActive());
                ps.setInt(10, pkg.getId());

                return ps.executeUpdate() > 0;

            } catch (Exception e) {
                e.printStackTrace();
            }

            return false;
        }

        // ==============================
        // DELETE PACKAGE
        // ==============================
        public boolean deletePackage(int id) {

            String sql = "DELETE FROM ServicePackages WHERE id=?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, id);

                return ps.executeUpdate() > 0;

            } catch (Exception e) {
                e.printStackTrace();
            }

            return false;
        }

        // ==============================
        // GET ONLY ACTIVE PACKAGES
        // ==============================
        public List<ServicePackage> getActivePackages() {

            List<ServicePackage> list = new ArrayList<>();

            String sql = "SELECT * FROM ServicePackages WHERE active = 1";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    ServicePackage pkg = mapResultSet(rs);

                    list.add(pkg);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            return list;
        }

        // ==============================
        // RESULTSET → MODEL MAPPING
        // ==============================
        private ServicePackage mapResultSet(ResultSet rs) throws SQLException {

            ServicePackage pkg = new ServicePackage();

            pkg.setId(rs.getInt("id"));
            pkg.setName(rs.getString("name"));
            pkg.setDescription(rs.getString("description"));

            pkg.setDefaultBasePrice(rs.getDouble("default_base_price"));
            pkg.setDefaultStaff(rs.getInt("default_staff"));
            pkg.setDefaultVehicle(rs.getInt("default_vehicle"));

            pkg.setPricePerKm(rs.getDouble("price_per_km"));
            pkg.setExtraStaffPrice(rs.getDouble("extra_staff_price"));
            pkg.setExtraVehiclePrice(rs.getDouble("extra_vehicle_price"));

            pkg.setActive(rs.getBoolean("active"));

            Timestamp created = rs.getTimestamp("created_at");
            if (created != null) {
                pkg.setCreatedAt(created.toLocalDateTime());
            }

            Timestamp updated = rs.getTimestamp("updated_at");
            if (updated != null) {
                pkg.setUpdatedAt(updated.toLocalDateTime());
            }

            return pkg;
    }
}


package DAO;

import Model.Vehicle;
import Model.enums.VehicleStatus;
import Util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    // ============================================================
    // MAP ROW → Vehicle
    // ============================================================
    private Vehicle mapRow(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setId(rs.getInt("id"));
        v.setVehicleCode(rs.getString("plate_number"));
        v.setType(rs.getString("type"));
        v.setCapacity(rs.getInt("capacity"));
        v.setStatus(VehicleStatus.fromValue(rs.getString("status")));
        return v;
    }

    // ============================================================
    // GET ALL
    // ============================================================
    public List<Vehicle> findAll() {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM Vehicles ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ============================================================
    // FIND BY ID
    // ============================================================
    public Vehicle findById(int id) {
        String sql = "SELECT * FROM Vehicles WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ============================================================
    // CHECK DUPLICATE PLATE NUMBER (bỏ qua id hiện tại khi edit)
    // ============================================================
    public boolean existsByPlateNumber(String plateNumber, int excludeId) {
        String sql = "SELECT 1 FROM Vehicles WHERE plate_number = ? AND id <> ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, plateNumber);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ============================================================
    // INSERT
    // ============================================================
    public boolean insert(Vehicle v) {
        String sql = "INSERT INTO Vehicles (plate_number, type, capacity, status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, v.getVehicleCode());
            ps.setString(2, v.getType());
            ps.setInt(3, v.getCapacity());
            ps.setString(4, v.getStatus().getValue());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ============================================================
    // UPDATE
    // ============================================================
    public boolean update(Vehicle v) {
        String sql = "UPDATE Vehicles SET plate_number=?, type=?, capacity=?, status=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, v.getVehicleCode());
            ps.setString(2, v.getType());
            ps.setInt(3, v.getCapacity());
            ps.setString(4, v.getStatus().getValue());
            ps.setInt(5, v.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ============================================================
    // DELETE
    // ============================================================
    public boolean delete(int id) {
        String sql = "DELETE FROM Vehicles WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

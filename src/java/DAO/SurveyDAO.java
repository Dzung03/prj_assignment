package DAO;

import Model.SurveyRequest;
import Model.enums.SurveyStatus;
import Util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SurveyDAO {

    /* ============================================================
       INSERT – Khách hàng gửi yêu cầu khảo sát
    ============================================================ */
    public boolean create(SurveyRequest s) {
        String sql = """
            INSERT INTO SurveyRequests
                (customer_id, service_package_id, pickup_address, delivery_address,
                 distance_km, extra_staff, extra_vehicle, total_price, status, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'PENDING', GETDATE())
            """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, s.getCustomerId());
            ps.setInt(2, s.getServicePackageId());
            ps.setString(3, s.getPickupAddress());
            ps.setString(4, s.getDeliveryAddress());
            ps.setDouble(5, s.getDistanceKm());
            ps.setInt(6, s.getExtraStaff());
            ps.setInt(7, s.getExtraVehicle());
            ps.setDouble(8, s.getTotalPrice());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /* ============================================================
       SELECT ALL – Admin xem toàn bộ
    ============================================================ */
    public List<SurveyRequest> findAll() {
        String sql = "SELECT * FROM SurveyRequests ORDER BY created_at DESC";
        List<SurveyRequest> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ============================================================
       SELECT BY STATUS
    ============================================================ */
    public List<SurveyRequest> findByStatus(SurveyStatus status) {
        String sql = "SELECT * FROM SurveyRequests WHERE status = ? ORDER BY created_at DESC";
        List<SurveyRequest> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.getValue());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ============================================================
       SELECT BY CUSTOMER
    ============================================================ */
    public List<SurveyRequest> findByCustomer(int customerId) {
        String sql = "SELECT * FROM SurveyRequests WHERE customer_id = ? ORDER BY created_at DESC";
        List<SurveyRequest> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ============================================================
       UPDATE STATUS – Approve / Reject
    ============================================================ */
    public boolean updateStatus(int id, SurveyStatus status) {
        String sql = "UPDATE SurveyRequests SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.getValue());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /* -------- Helper: map ResultSet → SurveyRequest -------- */
    private SurveyRequest map(ResultSet rs) throws SQLException {
        SurveyRequest s = new SurveyRequest();
        s.setId(rs.getInt("id"));
        s.setCustomerId(rs.getInt("customer_id"));
        s.setServicePackageId(rs.getInt("service_package_id"));
        s.setPickupAddress(rs.getString("pickup_address"));
        s.setDeliveryAddress(rs.getString("delivery_address"));
        s.setDistanceKm(rs.getDouble("distance_km"));
        s.setExtraStaff(rs.getInt("extra_staff"));
        s.setExtraVehicle(rs.getInt("extra_vehicle"));
        s.setTotalPrice(rs.getDouble("total_price"));
        s.setStatus(SurveyStatus.fromValue(rs.getString("status")));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}

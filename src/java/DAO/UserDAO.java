package DAO;

import Model.User;
import Model.enums.UserRole;
import Model.enums.UserStatus;
import Util.DBConnection;
import Util.PasswordUtil;
import Util.PhoneUtil;

import java.sql.*;
import java.time.LocalDateTime;

public class UserDAO {

    private static final int MAX_FAILED_ATTEMPTS = 5;

    // ================= FIND USER =================
    public User findByEmailOrPhone(String input) {

        String sql = "SELECT * FROM Users WHERE email = ? OR phone IN (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String[] phoneForms = PhoneUtil.getEquivalentForms(input);
            ps.setString(1, input);
            ps.setString(2, phoneForms[0]);
            ps.setString(3, phoneForms[1]);
            ps.setString(4, phoneForms[2]);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                User user = new User();

                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setRole(UserRole.fromValue(rs.getString("role")));
                user.setStatus(UserStatus.fromValue(rs.getString("status")));
                user.setFailedAttempts(rs.getInt("failed_attempts"));

                Timestamp lockedUntil = rs.getTimestamp("locked_until");
                if (lockedUntil != null) {
                    user.setLockedUntil(lockedUntil.toLocalDateTime());
                }

                // ===== AUTO UNLOCK IF TIME PASSED =====
                if (user.getStatus() == UserStatus.LOCKED &&
                        user.getLockedUntil() != null &&
                        user.getLockedUntil().isBefore(LocalDateTime.now())) {

                    resetLogin(user.getId());
                    user.setStatus(UserStatus.ACTIVE);
                    user.setFailedAttempts(0);
                    user.setLockedUntil(null);
                }

                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ================= CHECK EMAIL =================
    public boolean existsByEmail(String email) {

        String sql = "SELECT 1 FROM Users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= CHECK PHONE =================
    /** Kiểm tra trùng: +84 và 0 được coi như nhau (VD: 0868133083 = +84868133083) */
    public boolean existsByPhone(String phone) {

        String sql = "SELECT 1 FROM Users WHERE phone IN (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String[] forms = PhoneUtil.getEquivalentForms(phone);
            ps.setString(1, forms[0]);
            ps.setString(2, forms[1]);
            ps.setString(3, forms[2]);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= REGISTER USER =================
    public boolean register(User user) {

        String sql = """
            INSERT INTO Users
            (full_name, email, password, phone,
             role, status, failed_attempts, locked_until, created_at)
            VALUES (?, ?, ?, ?, 'CUSTOMER', 'ACTIVE', 0, NULL, GETDATE())
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // password đã hash
            ps.setString(4, PhoneUtil.normalizeForStorage(user.getPhone()));

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= UPDATE FAILED ATTEMPTS =================
    public void updateFailedAttempts(int userId, int attempts) {

        String sql = "UPDATE Users SET failed_attempts = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, attempts);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= LOCK USER =================
    public void lockUser(int userId, LocalDateTime lockUntil) {

        String sql = "UPDATE Users SET status='LOCKED', locked_until=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(lockUntil));
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= RESET LOGIN =================
    public void resetLogin(int userId) {

        String sql = """
                UPDATE Users 
                SET failed_attempts = 0, 
                    locked_until = NULL, 
                    status = 'ACTIVE'
                WHERE id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= CHECK PASSWORD =================
    public boolean checkPassword(String inputPassword, String storedHash) {

    return PasswordUtil.verifyPassword(inputPassword, storedHash);
    }

    public int getMaxFailedAttempts() {
        return MAX_FAILED_ATTEMPTS;
    }

    // ================= FIND ALL BY ROLE =================
    public java.util.List<User> findAllByRole(String role) {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRole(UserRole.fromValue(rs.getString("role")));
                u.setStatus(UserStatus.fromValue(rs.getString("status")));
                list.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Util;

/**
 *
 * @author ASUS
 */
import java.security.MessageDigest; 

public class PasswordUtil {
    
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256"); //Gọi class của java để tạo hash (SHA-256 thuật toán hash)
            byte[] hashedBytes = md.digest(password.getBytes());  //Nhận password chuyển về byte
            // cần phải chuyển thành HEX Byte array mưới đọc được.
            
            StringBuilder sb = new StringBuilder(); // tạo hộp rỗng để chứa chuỗi (dùng này đỡ tốn tài nguyên)
            for (byte b : hashedBytes) { //duyệt từng byte trong mảng
                sb.append(String.format("%02x", b));
                //%x -> in dạng hex, 02 -> luôn đủ 2 ký hiệu
            }
            return sb.toString();
        } catch (Exception  e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    // ================= VERIFY PASSWORD =================
    // Hàm này dùng để so sánh mật khẩu người dùng nhập với mật khẩu đã hash trong database
    public static boolean verifyPassword(String inputPassword, String storedHash) {
        String hashedInput = hashPassword(inputPassword);

        // So sánh an toàn hơn (tránh timing attack)
        return java.security.MessageDigest.isEqual(
                hashedInput.getBytes(),
                storedHash.getBytes()
        );
    }
}
package Util;

/**
 * Chuẩn hóa số điện thoại Việt Nam: +84 và 0 được coi là tương đương.
 */
public class PhoneUtil {

    /**
     * Lấy phần số thuần (bỏ +84, 84, 0 đầu).
     * VD: +84868133083, 0868133083, 84868133083 → 868133083
     */
    public static String toCanonical(String phone) {
        if (phone == null) return "";
        String digits = phone.replaceAll("\\D", "");
        if (digits.startsWith("84") && digits.length() >= 10) {
            return digits.substring(2);
        }
        if (digits.startsWith("0")) {
            return digits.substring(1);
        }
        return digits;
    }

    /**
     * Trả về các dạng tương đương của số điện thoại để so sánh.
     * VD: 0868133083 và +84868133083 đều cho ["0868133083", "+84868133083", "84868133083"]
     */
    public static String[] getEquivalentForms(String phone) {
        String canonical = toCanonical(phone);
        if (canonical.isEmpty()) {
            String p = phone != null ? phone : "";
            return new String[]{p, p, p};
        }
        return new String[]{
            "0" + canonical,
            "+84" + canonical,
            "84" + canonical
        };
    }

    /**
     * Chuẩn hóa để lưu DB: luôn dạng 0xxxxxxxxx
     */
    public static String normalizeForStorage(String phone) {
        String canonical = toCanonical(phone);
        return canonical.isEmpty() ? (phone != null ? phone : "") : "0" + canonical;
    }
}

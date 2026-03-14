package Service;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * GroqService – gọi Groq API bằng HttpURLConnection (đáng tin cậy nhất).
 * Không cần thêm bất kỳ jar nào.
 *
 * ⚠️  API_KEY đã được set sẵn.
 */
public class GroqService {

    // ============================================================
    // CONFIG
    // ============================================================
    private static final String API_KEY = "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";

    private static final String API_URL = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL   = "llama-3.3-70b-versatile";

    private static final String SYSTEM_PROMPT =
        "Ban la tro ly AI thong minh cua SafeMove – cong ty dich vu chuyen nha, chuyen van phong " +
        "chuyen nghiep. Hay tra loi cac cau hoi cua khach hang ve dich vu chuyen nha, bao gia, " +
        "lich trinh, xe tai, nhan vien boc xep, va cac van de lien quan. " +
        "Tra loi ngan gon, than thien, bang tieng Viet co dau. " +
        "Neu cau hoi khong lien quan den SafeMove, van hay tra loi huu ich " +
        "nhung nhac kheo rang ban la tro ly cua SafeMove.";

    // ============================================================
    // MAIN METHOD
    // ============================================================
    public String chat(List<String[]> history, String userMsg) throws Exception {

        // -- Build JSON body --
        StringBuilder messages = new StringBuilder("[");

        messages.append("{\"role\":\"system\",\"content\":\"")
                .append(escapeJson(SYSTEM_PROMPT))
                .append("\"}");

        for (String[] msg : history) {
            messages.append(",{\"role\":\"")
                    .append(msg[0])
                    .append("\",\"content\":\"")
                    .append(escapeJson(msg[1]))
                    .append("\"}");
        }

        messages.append(",{\"role\":\"user\",\"content\":\"")
                .append(escapeJson(userMsg))
                .append("\"}]");

        String body = "{"
                + "\"model\":\"" + MODEL + "\","
                + "\"messages\":" + messages + ","
                + "\"max_tokens\":1024,"
                + "\"temperature\":0.7"
                + "}";

        byte[] bodyBytes = body.getBytes(StandardCharsets.UTF_8);

        // -- Open connection --
        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        try {
            conn.setRequestMethod("POST");                          // ← luôn là POST
            conn.setDoOutput(true);                                 // cho phép gửi body
            conn.setDoInput(true);
            conn.setUseCaches(false);
            conn.setInstanceFollowRedirects(false);                 // không follow redirect
            conn.setConnectTimeout(15_000);
            conn.setReadTimeout(30_000);

            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Content-Length", String.valueOf(bodyBytes.length));
            conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
            conn.setRequestProperty("Accept", "application/json");

            // -- Write body --
            try (OutputStream os = conn.getOutputStream()) {
                os.write(bodyBytes);
                os.flush();
            }

            // -- Read response --
            int status = conn.getResponseCode();

            InputStream is = (status == 200)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            String responseBody;
            try (InputStream stream = is) {
                responseBody = new String(stream.readAllBytes(), StandardCharsets.UTF_8);
            }

            if (status != 200) {
                throw new RuntimeException("Groq API lỗi HTTP " + status + ": " + responseBody);
            }

            return extractContent(responseBody);

        } finally {
            conn.disconnect();
        }
    }

    // ============================================================
    // PARSE JSON RESPONSE (không dùng thư viện)
    // ============================================================
    private String extractContent(String json) {
        // Tìm "message" rồi "content" trong JSON response
        int msgIdx = json.indexOf("\"message\"");
        if (msgIdx == -1) return fallback(json);

        int contentIdx = json.indexOf("\"content\"", msgIdx);
        if (contentIdx == -1) return fallback(json);

        int colonIdx = json.indexOf(':', contentIdx);
        if (colonIdx == -1) return fallback(json);

        int quoteStart = json.indexOf('"', colonIdx + 1);
        if (quoteStart == -1) return fallback(json);
        quoteStart++;

        StringBuilder sb = new StringBuilder();
        int i = quoteStart;
        while (i < json.length()) {
            char c = json.charAt(i);
            if (c == '\\' && i + 1 < json.length()) {
                char next = json.charAt(i + 1);
                switch (next) {
                    case '"'  -> { sb.append('"');  i += 2; }
                    case '\\' -> { sb.append('\\'); i += 2; }
                    case 'n'  -> { sb.append('\n'); i += 2; }
                    case 'r'  -> { sb.append('\r'); i += 2; }
                    case 't'  -> { sb.append('\t'); i += 2; }
                    case 'u'  -> {
                        // 4 hex digits unicode
                        if (i + 5 < json.length()) {
                            String hex = json.substring(i + 2, i + 6);
                            try {
                                sb.append((char) Integer.parseInt(hex, 16));
                            } catch (NumberFormatException e) {
                                sb.append(next);
                            }
                            i += 6;
                        } else {
                            sb.append(c);
                            i++;
                        }
                    }
                    default -> { sb.append(c); i++; }
                }
            } else if (c == '"') {
                break;
            } else {
                sb.append(c);
                i++;
            }
        }

        return sb.length() > 0
                ? sb.toString()
                : "Xin lỗi, tôi không thể trả lời lúc này. Vui lòng thử lại!";
    }

    private String fallback(String json) {
        System.err.println("[GroqService] Không parse được JSON: " + json);
        return "Xin lỗi, có lỗi xảy ra khi xử lý phản hồi. Vui lòng thử lại!";
    }

    // ============================================================
    // JSON ESCAPE
    // ============================================================
    private String escapeJson(String text) {
        if (text == null) return "";
        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}

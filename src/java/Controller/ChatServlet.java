package Controller;

import Service.GroqService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * ChatServlet – xử lý API chat với AI (Groq)
 *
 *  GET  /chat/page   → trang chat đầy đủ
 *  GET  /chat/clear  → xoá lịch sử hội thoại
 *  POST /chat/send   → gửi tin nhắn, nhận JSON {"reply":"..."}
 */
public class ChatServlet extends HttpServlet {

    private final GroqService groqService = new GroqService();

    // ============================================================
    // GET
    // ============================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "/page";

        switch (pathInfo) {
            case "/clear" -> {
                request.getSession().removeAttribute("chatHistory");
                response.sendRedirect(request.getContextPath() + "/chat/page");
            }
            default -> {
                request.getRequestDispatcher("/Views/Chat/chatPage.jsp")
                       .forward(request, response);
            }
        }
    }

    // ============================================================
    // POST
    // ============================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        if ("/send".equals(pathInfo)) {
            handleSend(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ============================================================
    // HANDLE SEND MESSAGE
    // ============================================================
    @SuppressWarnings("unchecked")
    private void handleSend(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        String message = request.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            out.print("{\"error\":\"Tin nhắn không được để trống.\"}");
            return;
        }

        message = message.trim();

        // -- Lấy lịch sử từ session --
        HttpSession session = request.getSession();
        List<String[]> history = (List<String[]>) session.getAttribute("chatHistory");
        if (history == null) {
            history = new ArrayList<>();
        }

        try {
            String aiReply = groqService.chat(history, message);

            // Cập nhật lịch sử
            history.add(new String[]{"user",      message});
            history.add(new String[]{"assistant", aiReply});

            // Giữ tối đa 20 lượt (10 exchanges)
            if (history.size() > 20) {
                history = new ArrayList<>(history.subList(history.size() - 20, history.size()));
            }
            session.setAttribute("chatHistory", history);

            // Trả JSON
            String escaped = escapeJson(aiReply);
            out.print("{\"reply\":\"" + escaped + "\"}");

        } catch (Exception e) {
            e.printStackTrace();
            String errMsg = e.getMessage() != null
                    ? e.getMessage().replace("\"", "'").replace("\n", " ")
                    : "Không xác định";
            out.print("{\"error\":\"Lỗi kết nối AI: " + errMsg + "\"}");
        }
    }

    // ============================================================
    // HELPER
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

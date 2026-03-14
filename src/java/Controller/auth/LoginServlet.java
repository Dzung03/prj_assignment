package Controller.auth;

import DAO.UserDAO;
import Model.User;
import Model.enums.UserStatus;
import Util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.time.Duration;
import java.time.LocalDateTime;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã login rồi thì về home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        // Chuyển về home và mở modal đăng nhập
        response.sendRedirect(request.getContextPath() + "/home?openLogin=1");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String identifier = request.getParameter("identifier");
        String password   = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user   = dao.findByEmailOrPhone(identifier);

        /* ---- 1. Không tìm thấy user ---- */
        if (user == null) {
            String msg = "Email / số điện thoại hoặc mật khẩu không đúng.";
            sendError(request, response, msg);
            return;
        }

        /* ---- 2. Tài khoản bị khoá ---- */
        if (user.getStatus() == UserStatus.LOCKED
                && user.getLockedUntil() != null
                && user.getLockedUntil().isAfter(LocalDateTime.now())) {

            long secs = Duration.between(LocalDateTime.now(), user.getLockedUntil()).getSeconds();
            String msg = "Tài khoản bị khoá. Vui lòng thử lại sau " + secs + " giây.";
            sendError(request, response, msg);
            return;
        }

        /* ---- 3. Sai mật khẩu ---- */
        if (!dao.checkPassword(password, user.getPassword())) {
            int attempts = user.getFailedAttempts() + 1;
            dao.updateFailedAttempts(user.getId(), attempts);

            if (attempts >= dao.getMaxFailedAttempts()) {
                int violations  = attempts - dao.getMaxFailedAttempts() + 1;
                int lockSeconds = 30 * violations;
                dao.lockUser(user.getId(), LocalDateTime.now().plusSeconds(lockSeconds));
            }

            String msg = "Email / số điện thoại hoặc mật khẩu không đúng.";
            sendError(request, response, msg);
            return;
        }

        /* ---- 4. ĐĂNG NHẬP THÀNH CÔNG ---- */
        dao.resetLogin(user.getId());
        user = dao.findByEmailOrPhone(identifier); // reload

        HttpSession session = request.getSession(); 
        session.setAttribute("user", user);

        // Chuyển về trang phù hợp theo role
        String role = user.getRole() != null ? user.getRole().getValue() : "";
        switch (role) {
            case "MANAGER" -> response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            case "STAFF"   -> response.sendRedirect(request.getContextPath() + "/home");
            default        -> response.sendRedirect(request.getContextPath() + "/survey");
        }
    }

    /** Gửi lỗi: redirect về home với loginError=1 và msg */
    private void sendError(HttpServletRequest req, HttpServletResponse res, String msg)
            throws IOException {
        String encoded = URLEncoder.encode(msg, "UTF-8");
        res.sendRedirect(req.getContextPath() + "/home?loginError=1&msg=" + encoded);
    }
}

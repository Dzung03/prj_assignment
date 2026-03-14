package Controller.auth;

import DAO.UserDAO;
import Model.User;
import Util.PasswordUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

public class RegisterServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Chuyển về home và mở modal đăng ký
        response.sendRedirect(request.getContextPath() + "/home?openRegister=1");
    }

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate mật khẩu
        if (password == null || password.length() < 6) {
            sendError(request, response, "Mật khẩu phải có ít nhất 6 ký tự!");
            return;
        }
        if (!password.equals(confirmPassword)) {
            sendError(request, response, "Mật khẩu nhập lại không khớp!");
            return;
        }

        // Validate số điện thoại
        if (phone == null || phone.length() != 10) {
            sendError(request, response, "Số điện thoại không đúng 10 chữ số!");
            return;
        }
        if (!phone.matches("^(0[35789])\\d{8}$")) {
            sendError(request, response, "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại(đầu số 03x, 05x, 07x, 08x, 09x)");
            return;
        }

        UserDAO dao = new UserDAO();

        // Validate
        if (dao.existsByEmail(email)) {
            sendError(request, response, "Email đã tồn tại");
            return;
        }

        if (dao.existsByPhone(phone)) {
            sendError(request, response, "Số điện thoại đã tồn tại");
            return;
        }

        // Tạo user
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(PasswordUtil.hashPassword(password));

        dao.register(user);

        response.sendRedirect(request.getContextPath() + "/home?openLogin=1");
    }

    /**
     * Gửi lỗi: redirect về home với registerError=1 và msg
     */
    private void sendError(HttpServletRequest req, HttpServletResponse res, String msg)
            throws IOException {
        String encoded = URLEncoder.encode(msg, "UTF-8");
        res.sendRedirect(req.getContextPath() + "/home?registerError=1&registerMsg=" + encoded);
    }
}

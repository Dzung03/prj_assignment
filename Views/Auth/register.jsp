<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng ký – SafeMove</title>
    <link rel="stylesheet" href="./assets/css/main.css"/>
    <link rel="stylesheet" href="./assets/css/base.css"/>
    <link rel="stylesheet" href="./assets/fonts/fontawesome-free-7.1.0-web/css/all.min.css">
</head>
<body>

<%
    /* ===== LẤY LỖI TỪ SERVLET (nếu có) ===== */
    String error = (String) request.getAttribute("error");
%>

<%-- Hiển thị lỗi --%>
<% if (error != null) { %>
    <p style="color:red; text-align:center"><%= error %></p>
<% } %>

<%--
    ====================================================
    FORM ĐĂNG KÝ
    action="register"  → POST /register → RegisterServlet.doPost()
    method="post"      → BẮT BUỘC, không có thì servlet không đọc được

    Các name= phải KHỚP với RegisterServlet:
      name="fullName"   → request.getParameter("fullName")
      name="email"      → request.getParameter("email")
      name="phone"      → request.getParameter("phone")
      name="password"   → request.getParameter("password")
    ====================================================
--%>
<form id="formRegister"
      method="post"
      action="<%= request.getContextPath() %>/register">

    <div class="modal">
        <div class="modal__overlay"></div>

        <div class="modal__body">
            <div class="auth-form">
                <div class="auth-form__container">
                    <div class="auth-form__header">
                        <h3 class="auth-form__heading">Đăng ký</h3>
                        <span class="auth-form__switch-btn">
                            <a href="<%= request.getContextPath() %>/login">Đăng nhập</a>
                        </span>
                    </div>

                    <div class="auth-form__form">

                        <%-- Họ và tên --%>
                        <div class="auth-form__group">
                            <input type="text"
                                   name="fullName"
                                   class="auth-form__input"
                                   placeholder="Nhập họ và tên...."
                                   required>
                        </div>

                        <%-- Email --%>
                        <div class="auth-form__group">
                            <input type="email"
                                   name="email"
                                   class="auth-form__input"
                                   placeholder="Nhập Email...."
                                   required>
                        </div>

                        <%-- Số điện thoại --%>
                        <div class="auth-form__group">
                            <input type="text"
                                   name="phone"
                                   class="auth-form__input"
                                   placeholder="Nhập số điện thoại...."
                                   required>
                        </div>

                        <%-- Mật khẩu --%>
                        <div class="auth-form__group">
                            <input type="password"
                                   name="password"
                                   id="password"
                                   class="auth-form__input"
                                   placeholder="Nhập mật khẩu...."
                                   required>
                        </div>

                        <%-- Nhập lại mật khẩu (chỉ validate phía client) --%>
                        <div class="auth-form__group">
                            <input type="password"
                                   id="confirmPassword"
                                   class="auth-form__input"
                                   placeholder="Nhập lại mật khẩu...."
                                   required>
                        </div>

                    </div>

                    <div class="auth-form__aside">
                        <p class="auth-form__policy-text">
                            Bằng việc đăng ký, bạn đã đồng ý với SafeMove về
                            <a href="" class="auth-form__text-link">Điều khoản dịch vụ</a> &amp;
                            <a href="" class="auth-form__text-link">Chính sách bảo mật.</a>
                        </p>
                    </div>

                    <div class="auth-form__controls">
                        <button type="button"
                                class="btn btn--nomal auth-form__controls-back"
                                onclick="window.history.back()">
                            TRỞ LẠI
                        </button>
                        <button type="submit"
                                class="btn btn--primary"
                                onclick="return validateForm()">
                            ĐĂNG KÝ
                        </button>
                    </div>

                </div>

                <div class="auth-form__socials">
                    <a href="" class="auth-form__socials--facebook btn btn-size-s btn--with-icon">
                        <i class="auth-form__socials-icon fa-brands fa-square-facebook"></i>
                        <span class="auth-form__socials-title">Kết nối với Facebook</span>
                    </a>
                    <a href="" class="auth-form__socials--google btn btn-size-s btn--with-icon">
                        <i class="auth-form__socials-icon fa-brands fa-google"></i>
                        <span class="auth-form__socials-title">Kết nối với Google</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</form>

<script>
    /* Kiểm tra mật khẩu khớp trước khi submit */
    function validateForm() {
        const pw  = document.getElementById('password').value;
        const cpw = document.getElementById('confirmPassword').value;
        if (pw !== cpw) {
            alert('Mật khẩu nhập lại không khớp!');
            return false;
        }
        if (pw.length < 6) {
            alert('Mật khẩu phải có ít nhất 6 ký tự!');
            return false;
        }
        return true;
    }
</script>

<jsp:include page="/Views/Chat/chatWidget.jsp"/>

</body>
</html>

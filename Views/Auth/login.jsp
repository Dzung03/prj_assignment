<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <link rel="stylesheet" href="./assets/css/main.css"/>
        <link rel="stylesheet" href="./assets/css/base.css"/>
        <link rel="stylesheet" href="./assets/fonts/fontawesome-free-7.1.0-web/css/all.min.css">
    </head>
    <jsp:include page="/Views/Chat/chatWidget.jsp"/>

    <body>
        <%
            String error = (String)request.getAttribute("error");
            if (error!=null){
        %>
        <p style="color: red"><%=error%></p>
        <%
            }

            String username = request.getParameter("identifier");
        %>

        <!-- FIX 1: thêm method POST + contextPath -->
        <form id="formLogin" method="post" action="<%=request.getContextPath()%>/login">

            <div class="modal">
                <div class="modal__overlay"></div>

                <div class="modal__body"> 
                    <!-- Login form -->
                    <div class="auth-form">
                        <div class="auth-form__container">
                            <div class="auth-form__header">
                                <h3 class="auth-form__heading">Đăng nhập</h3>
                                <span class="auth-form__switch-btn">
                                    <a href="./register">Đăng ký</a>
                                </span>
                            </div>

                            <div class="auth-form__form">
                                
                                <!-- FIX 2: thêm name="identifier" -->
                                <div class="auth-form__group">
                                    <input type="text"
                                           name="identifier"
                                           class="auth-form__input"
                                           placeholder="Nhập Email hoặc Phone...."
                                           value="<%=username==null?"":username%>"
                                           required>
                                </div>

                                <!-- FIX 3: thêm name="password" -->
                                <div class="auth-form__group">
                                    <input type="password"
                                           name="password"
                                           class="auth-form__input"
                                           placeholder="Nhập mật khẩu...."
                                           required>
                                </div>
                            </div>

                            <div class="auth-form__aside">
                                <div class="auth-form__help">
                                    <a href="" class="auth-form__help-link auth-form__help-forgot">Quên mật khẩu</a>
                                    <span class="auth-form__help-separate"></span>
                                    <a href="" class="auth-form__help-link">Cần trợ giúp?</a>
                                </div>
                            </div>

                            <div class="auth-form__controls">
                                
                                <!-- FIX 4: thêm type -->
                                <button type="button"
                                        class="btn btn--nomal auth-form__controls-back"
                                        onclick="window.location.href='<%=request.getContextPath()%>/'">
                                    TRỞ LẠI
                                </button>

                                <button type="submit"
                                        class="btn btn--primary">
                                    ĐĂNG NHẬP
                                </button>
                            </div>
                        </div>

                        <div class="auth-form__socials">
                            <a href="" class="auth-form__socials--facebook btn btn-size-s btn--with-icon">
                                <i class="auth-form__socials-icon fa-brands fa-square-facebook"></i>
                                <span class="auth-form__socials-title">
                                    Kết nối với Facebook
                                </span>
                            </a>

                            <a href="" class="auth-form__socials--google btn btn-size-s btn--with-icon">
                                <i class="auth-form__socials-icon fa-brands fa-google"></i>
                                <span class="auth-form__socials-title">
                                    Kết nối với Google
                                </span>
                            </a>
                        </div>
                    </div>
                </div>
            </div> 
        </form>
    </body>
</html>
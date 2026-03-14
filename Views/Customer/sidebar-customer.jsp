<%@ page contentType="text/html;charset=UTF-8" language="java" import="Model.User" %>

<%
String currentPage = request.getServletPath();
if(currentPage==null) currentPage="";

Object sessionUser = session.getAttribute("user");

String userName="Khách hàng";
String userEmail="";

if(sessionUser instanceof User){
    User u=(User)sessionUser;
    userName=u.getFullName()!=null?u.getFullName():"Khách hàng";
    userEmail=u.getEmail()!=null?u.getEmail():"";
}

String avatarText=userName.length()>=1
        ?userName.substring(0,1).toUpperCase()
        :"KH";
%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">

<aside class="sidebar" data-role="CUSTOMER">

    <!-- HEADER -->
    <div class="sb-header">

        <div class="sb-logo-icon">🏠</div>

        <div class="sb-logo-text">
            <div class="sb-logo-name">SafeMove</div>
            <div class="sb-logo-role">Khách hàng</div>
        </div>

    </div>


    <!-- MENU -->
    <nav class="sb-menu">

        <div class="sb-group-label">Tổng quan</div>

        <a href="${pageContext.request.contextPath}/home"
           class="sb-item <%=currentPage.contains("/home")?"active":""%>">

            <span class="sb-item-icon">⊞</span>
            <span class="sb-item-label">Dashboard</span>

        </a>


        <div class="sb-group-divider"></div>
        <div class="sb-group-label">Dịch vụ</div>

        <a href="${pageContext.request.contextPath}/package"
           class="sb-item <%=currentPage.contains("/package")?"active":""%>">

            <span class="sb-item-icon">📦</span>
            <span class="sb-item-label">Gói dịch vụ</span>

        </a>


        <a href="${pageContext.request.contextPath}/survey"
           class="sb-item <%=currentPage.contains("/survey")?"active":""%>">

            <span class="sb-item-icon">📝</span>
            <span class="sb-item-label">Yêu cầu khảo sát</span>

        </a>


        <a href="${pageContext.request.contextPath}/contract"
           class="sb-item <%=currentPage.contains("/contract")?"active":""%>">

            <span class="sb-item-icon">📄</span>
            <span class="sb-item-label">Hợp đồng của tôi</span>

        </a>


        <div class="sb-group-divider"></div>
        <div class="sb-group-label">Tiện ích</div>


        <a href="${pageContext.request.contextPath}/map"
           class="sb-item <%=currentPage.contains("/map")?"active":""%>">

            <span class="sb-item-icon">🗺️</span>
            <span class="sb-item-label">Bản đồ</span>

        </a>


        <a href="${pageContext.request.contextPath}/chat"
           class="sb-item <%=currentPage.contains("/chat")?"active":""%>">

            <span class="sb-item-icon">💬</span>
            <span class="sb-item-label">Hỗ trợ trực tuyến</span>

        </a>


        <div class="sb-group-divider"></div>
        <div class="sb-group-label">Tài khoản</div>


        <a href="${pageContext.request.contextPath}/profile"
           class="sb-item <%=currentPage.contains("/profile")?"active":""%>">

            <span class="sb-item-icon">👤</span>
            <span class="sb-item-label">Hồ sơ cá nhân</span>

        </a>


        <a href="${pageContext.request.contextPath}/logout"
           class="sb-item">

            <span class="sb-item-icon">🚪</span>
            <span class="sb-item-label">Đăng xuất</span>

        </a>

    </nav>


    <!-- FOOTER -->

    <div class="sb-footer">

        <div class="sb-avatar"><%=avatarText%></div>

        <div class="sb-user-info">

            <div class="sb-user-name"><%=userName%></div>
            <div class="sb-user-email"><%=userEmail%></div>

        </div>

    </div>

</aside>
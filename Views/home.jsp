<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SafeMove – Dịch vụ chuyển nhà chuyên nghiệp</title>

    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>

    <!-- CSS riêng của trang Home -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/home.css"/>
</head>
<body>
<%
    /* Kiểm tra lỗi login (servlet gửi về qua redirect) */
    String loginError = request.getParameter("loginError");
    String loginMsg   = request.getParameter("msg");
    if (loginMsg != null) {
        try { loginMsg = URLDecoder.decode(loginMsg, "UTF-8"); } catch (Exception e) { /* giữ nguyên */ }
    }
    /* Kiểm tra lỗi register */
    String registerError = request.getParameter("registerError");
    String registerMsg   = request.getParameter("registerMsg");
    if (registerMsg != null) {
        try { registerMsg = URLDecoder.decode(registerMsg, "UTF-8"); } catch (Exception e) { /* giữ nguyên */ }
    }
    /* Mở modal khi truy cập /login hoặc /register (GET) */
    String openLogin    = request.getParameter("openLogin");
    String openRegister = request.getParameter("openRegister");
%>

<!-- ===== NAVBAR ===== -->
<nav>
    <div class="nav-brand">Safe<span>Move</span></div>
    <div class="nav-links">
        <a href="#services">Dịch vụ</a>
        <a href="#map-section">Bản đồ</a>
        <a href="<%= request.getContextPath() %>/map/page">🗺️ Map đầy đủ</a>
        <a href="<%= request.getContextPath() %>/chat/page">🤖 AI Chat</a>
        <%-- Nút Đăng nhập / Đăng ký: mở modal thay vì chuyển trang --%>
        <a href="#" onclick="openLoginModal(); return false;">Đăng nhập</a>
        <a href="#" onclick="openRegisterModal(); return false;">Đăng ký</a>
        <a href="<%= request.getContextPath() %>/map/survey" class="nav-cta">Đặt lịch ngay</a>
    </div>
</nav>

<!-- ===== HERO ===== -->
<section class="hero">
    <div class="hero-content">
        <div class="hero-badge">
            <div class="dot"></div>
            Dịch vụ chuyển nhà tin cậy #1 VN
        </div>
        <h1>Chuyển nhà <span>an toàn</span><br>nhanh chóng, trọn gói</h1>
        <p>SafeMove cung cấp dịch vụ chuyển nhà, chuyển văn phòng chuyên nghiệp
           với đội xe hiện đại, nhân viên được đào tạo bài bản và giá cả cạnh tranh.</p>
        <div class="hero-btns">
            <a href="<%= request.getContextPath() %>/map/survey" class="btn-hero-primary">
                📝 Đặt lịch khảo sát
            </a>
            <a href="<%= request.getContextPath() %>/chat/page" class="btn-hero-outline">
                🤖 Hỏi AI tư vấn
            </a>
        </div>
        <div class="hero-stats">
            <div class="stat-item">
                <div class="num">5,000+</div>
                <div class="lbl">Khách hàng tin dùng</div>
            </div>
            <div class="stat-item">
                <div class="num">10+</div>
                <div class="lbl">Năm kinh nghiệm</div>
            </div>
            <div class="stat-item">
                <div class="num">100%</div>
                <div class="lbl">An toàn &amp; đúng hẹn</div>
            </div>
        </div>
    </div>
</section>

<!-- ===== SERVICES ===== -->
<section class="services" id="services">
    <div class="section-header">
        <div class="tag">🚀 Dịch vụ</div>
        <h2>Giải pháp chuyển dọn toàn diện</h2>
        <p>Từ căn hộ nhỏ đến văn phòng lớn – chúng tôi đều đáp ứng</p>
    </div>
    <div class="services-grid">
        <div class="service-card">
            <div class="icon">🏠</div>
            <h3>Chuyển nhà trọn gói</h3>
            <p>Đóng gói, vận chuyển, bốc xếp và lắp đặt tại nơi mới. An toàn tuyệt đối.</p>
        </div>
        <div class="service-card">
            <div class="icon">🏢</div>
            <h3>Chuyển văn phòng</h3>
            <p>Di chuyển thiết bị, đồ nội thất văn phòng nhanh chóng, không gián đoạn công việc.</p>
        </div>
        <div class="service-card">
            <div class="icon">🚛</div>
            <h3>Thuê xe tải</h3>
            <p>Đội xe từ 500kg đến 5 tấn, phục vụ mọi nhu cầu vận chuyển trong thành phố.</p>
        </div>
        <div class="service-card">
            <div class="icon">👷</div>
            <h3>Nhân viên bốc xếp</h3>
            <p>Đội ngũ bốc xếp chuyên nghiệp, có kinh nghiệm xử lý đồ dễ vỡ và đồ nặng.</p>
        </div>
    </div>
</section>

<!-- ===== MAP SECTION ===== -->
<section class="map-section" id="map-section">
    <div class="section-header">
        <div class="tag">📍 Vị trí</div>
        <h2>Khu vực phục vụ</h2>
        <p>Phủ sóng toàn Việt Nam</p>
    </div>
    <div class="map-container">
        <div class="map-info">
            <h3>📍 Thông tin liên hệ</h3>
            <div class="map-info-item">
                <span class="mi-icon">🏢</span>
                <div>
                    <div class="mi-title">Trụ sở chính</div>
                    <div class="mi-desc">97 Quan Hoa, Cầu Giấy, Hà Nội.</div>
                </div>
            </div>
            <div class="map-info-item">
                <span class="mi-icon">📞</span>
                <div>
                    <div class="mi-title">Hotline</div>
                    <div class="mi-desc">18003088 (miễn phí)</div>
                </div>
            </div>
            <div class="map-info-item">
                <span class="mi-icon">🕐</span>
                <div>
                    <div class="mi-title">Giờ làm việc</div>
                    <div class="mi-desc">7:00 – 21:00 (kể cả cuối tuần)</div>
                </div>
            </div>
            <div class="map-info-item">
                <span class="mi-icon">🗺️</span>
                <div>
                    <div class="mi-title">Vùng phủ sóng</div>
                    <div class="mi-desc">Toàn TP.HCM, Bình Dương, Hà Nội, Bắc Ninh</div>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/map/page" class="btn-view-map">
                🗺️ Xem bản đồ đầy đủ →
            </a>
        </div>
        <div id="homeMap"></div>
    </div>
</section>

<!-- ===== FOOTER ===== -->
<footer>
    <p>© 2024 SafeMove Vietnam. Dịch vụ chuyển nhà chuyên nghiệp.</p>
    <p style="margin-top:.4rem;">
        <a href="<%= request.getContextPath() %>/login">Đăng nhập</a> ·
        <a href="<%= request.getContextPath() %>/chat/page">AI Chat</a> ·
        <a href="<%= request.getContextPath() %>/map/page">Bản đồ</a> ·
        <a href="<%= request.getContextPath() %>/admin/dashboard">Admin</a>
    </p>
</footer>

<!-- Leaflet JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    // Mini-map trên trang Home
    const homeMap = L.map('homeMap', {
        center: [21.0332771,105.8008675],
        zoom: 11,
        zoomControl: false,
        scrollWheelZoom: false
    });

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(homeMap);

    // Marker HQ
    L.marker([21.0332771,105.8008675], {
        icon: L.divIcon({
            className: '',
            html: '<div style="font-size:22px;filter:drop-shadow(0 2px 4px rgba(0,0,0,.5))">🚚</div>',
            iconSize: [26, 26],
            iconAnchor: [13, 13]
        })
    }).addTo(homeMap)
      .bindPopup('<b>SafeMove HQ</b><br>97 Quan Hoa, HN.')
      .openPopup();

    // Vùng phủ sóng
    L.circle([21.0332771,105.8008675], {
        radius: 16000,
        color: '#3b82f6',
        fillColor: '#3b82f6',
        fillOpacity: 0.06,
        weight: 1.5,
        dashArray: '6 4'
    }).addTo(homeMap);
</script>

<!-- AI Chat Widget -->
<jsp:include page="/Views/Chat/chatWidget.jsp"/>

<!-- ===== LOGIN MODAL ===== -->
<div id="loginModal" class="modal-overlay">
    <div class="modal-card">

        <%-- Nút đóng --%>
        <button class="modal-close" onclick="closeLoginModal()" title="Đóng">✕</button>

        <div class="modal-logo">Safe<span>Move</span></div>
        <h2>Đăng nhập tài khoản</h2>

        <%-- Hiển thị lỗi (nếu servlet gửi về) --%>
        <% if (loginError != null && loginMsg != null) { %>
        <div class="modal-error">⚠️ <%= loginMsg %></div>
        <% } %>

        <form class="modal-form"
              method="post"
              action="<%= request.getContextPath() %>/login">

            <%-- Field ẩn: báo servlet biết request từ modal home --%>
            <input type="hidden" name="source" value="home">

            <div class="form-group">
                <label for="m-identifier">Email hoặc số điện thoại</label>
                <input type="text"
                       id="m-identifier"
                       name="identifier"
                       placeholder="example@email.com"
                       required
                       autocomplete="username">
            </div>

            <div class="form-group">
                <label for="m-password">Mật khẩu</label>
                <input type="password"
                       id="m-password"
                       name="password"
                       placeholder="••••••••"
                       required
                       autocomplete="current-password">
            </div>

            <button type="submit" class="modal-submit">🔐 Đăng nhập</button>
        </form>

        <div class="modal-divider">hoặc</div>

        <div class="modal-footer">
            Chưa có tài khoản?
            <a href="#" onclick="closeLoginModal(); openRegisterModal(); return false;">Đăng ký ngay →</a>
        </div>
    </div>
</div>

<!-- ===== REGISTER MODAL ===== -->
<div id="registerModal" class="modal-overlay">
    <div class="modal-card">

        <button class="modal-close" onclick="closeRegisterModal()" title="Đóng">✕</button>

        <div class="modal-logo">Safe<span>Move</span></div>
        <h2>Đăng ký tài khoản</h2>

        <%-- Hiển thị lỗi (nếu servlet gửi về) --%>
        <% if (registerError != null && registerMsg != null) { %>
        <div class="modal-error">⚠️ <%= registerMsg %></div>
        <% } %>

        <form class="modal-form"
              method="post"
              action="<%= request.getContextPath() %>/register"
              id="formRegister">

            <div class="form-group">
                <label for="m-fullName">Họ và tên</label>
                <input type="text" id="m-fullName" name="fullName"
                       placeholder="Nguyễn Văn A" required autocomplete="name">
            </div>

            <div class="form-group">
                <label for="m-email">Email</label>
                <input type="email" id="m-email" name="email"
                       placeholder="example@email.com" required autocomplete="email">
            </div>

            <div class="form-group">
                <label for="m-phone">Số điện thoại</label>
                <input type="tel" id="m-phone" name="phone"
                       placeholder="0901234567" required autocomplete="tel">
            </div>

            <div class="form-group">
                <label for="m-password-reg">Mật khẩu</label>
                <input type="password" id="m-password-reg" name="password"
                       placeholder="••••••••" required autocomplete="new-password"
                       minlength="6">
            </div>

            <div class="form-group">
                <label for="m-confirmPassword">Nhập lại mật khẩu</label>
                <input type="password" id="m-confirmPassword" name="confirmPassword"
                       placeholder="••••••••" required autocomplete="new-password">
            </div>

            <button type="submit" class="modal-submit">📝 Đăng ký</button>
        </form>

        <div class="modal-divider">hoặc</div>

        <div class="modal-footer">
            Đã có tài khoản?
            <a href="#" onclick="closeRegisterModal(); openLoginModal(); return false;">Đăng nhập ngay →</a>
        </div>
    </div>
</div>

<script>
    /* ===== LOGIN MODAL CONTROL ===== */
    const loginModal = document.getElementById('loginModal');

    function openLoginModal() {
        loginModal.classList.add('active');
        document.body.style.overflow = 'hidden';
        // Focus vào ô email sau khi mở
        setTimeout(() => document.getElementById('m-identifier').focus(), 150);
    }

    function closeLoginModal() {
        loginModal.classList.remove('active');
        document.body.style.overflow = '';
    }

    // Click vào overlay (ngoài card) → đóng
    loginModal.addEventListener('click', function(e) {
        if (e.target === loginModal) closeLoginModal();
    });

    // Phím ESC → đóng modal đang mở
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (registerModal.classList.contains('active')) closeRegisterModal();
            else closeLoginModal();
        }
    });

    // Auto-mở nếu servlet redirect về kèm lỗi hoặc openLogin
    <% if (loginError != null || openLogin != null) { %>
    window.addEventListener('load', openLoginModal);
    <% } %>

    /* ===== REGISTER MODAL CONTROL ===== */
    const registerModal = document.getElementById('registerModal');

    function openRegisterModal() {
        registerModal.classList.add('active');
        document.body.style.overflow = 'hidden';
        setTimeout(() => document.getElementById('m-fullName').focus(), 150);
    }

    function closeRegisterModal() {
        registerModal.classList.remove('active');
        document.body.style.overflow = '';
    }

    registerModal.addEventListener('click', function(e) {
        if (e.target === registerModal) closeRegisterModal();
    });

    <% if (registerError != null || openRegister != null) { %>
        window.addEventListener('load', openRegisterModal);
    <% } %>
</script>

</body>
</html>

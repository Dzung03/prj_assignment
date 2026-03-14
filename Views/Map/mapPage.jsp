<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SafeMove – Bản đồ dịch vụ</title>

    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/map.css"/>
</head>
<body>

<div class="sb-layout">

    <%-- Sidebar Customer dùng chung --%>
    <%@ include file="../sidebar-customer.jsp" %>

    <div class="sb-content">

        <div class="map-layout">

    <!-- SIDEBAR MAP -->
    <div class="map-sidebar">

        <!-- HQ Info -->
        <div class="map-sidebar-section">
            <h3>📍 SafeMove HQ</h3>
            <div class="hq-card">
                <div class="hq-badge">HEADQUARTERS</div>
                <div class="hq-name">SafeMove Vietnam</div>
                <div class="hq-addr">
                    123 Nguyễn Văn Linh, Quận 7<br>
                    TP. Hồ Chí Minh, Việt Nam<br>
                    📞 1800-SAFEMOVE
                </div>
            </div>
        </div>

        <!-- Stats -->
        <div class="map-sidebar-section">
            <h3>📊 Thống kê</h3>
            <div class="stats-grid">
                <div class="stat-mini"><div class="num">12</div><div class="lbl">Xe hoạt động</div></div>
                <div class="stat-mini"><div class="num">5</div><div class="lbl">Khu vực</div></div>
                <div class="stat-mini"><div class="num">48</div><div class="lbl">Chuyến/ngày</div></div>
                <div class="stat-mini"><div class="num">3</div><div class="lbl">Kho bãi</div></div>
            </div>
        </div>

        <!-- Locations -->
        <div class="map-sidebar-section">
            <h3>🏢 Chi nhánh & Kho bãi</h3>
            <div class="loc-item" onclick="flyTo(10.7284, 106.7218, 'Depot Quận 7')">
                <div class="loc-dot" style="background:#f97316"></div>
                <div>
                    <div class="loc-name">Kho Quận 7</div>
                    <div class="loc-addr">Đường Huỳnh Tấn Phát, Q.7</div>
                </div>
            </div>
            <div class="loc-item" onclick="flyTo(10.8028, 106.6494, 'Depot Bình Chánh')">
                <div class="loc-dot" style="background:#f97316"></div>
                <div>
                    <div class="loc-name">Kho Bình Chánh</div>
                    <div class="loc-addr">QL 50, Bình Chánh</div>
                </div>
            </div>
            <div class="loc-item" onclick="flyTo(10.8411, 106.7688, 'Chi nhánh Thủ Đức')">
                <div class="loc-dot" style="background:#8b5cf6"></div>
                <div>
                    <div class="loc-name">Chi nhánh Thủ Đức</div>
                    <div class="loc-addr">Xa lộ Hà Nội, Thủ Đức</div>
                </div>
            </div>
            <div class="loc-item" onclick="flyTo(10.7942, 106.6521, 'Chi nhánh Bình Tân')">
                <div class="loc-dot" style="background:#8b5cf6"></div>
                <div>
                    <div class="loc-name">Chi nhánh Bình Tân</div>
                    <div class="loc-addr">Kinh Dương Vương, Bình Tân</div>
                </div>
            </div>
        </div>

        <!-- Legend -->
        <div class="map-sidebar-section">
            <h3>🗂️ Chú thích</h3>
            <div class="legend-item"><div class="loc-dot" style="background:#3b82f6;border-radius:50%;width:10px;height:10px"></div> Trụ sở chính</div>
            <div class="legend-item"><div class="loc-dot" style="background:#f97316;border-radius:50%;width:10px;height:10px"></div> Kho bãi</div>
            <div class="legend-item"><div class="loc-dot" style="background:#8b5cf6;border-radius:50%;width:10px;height:10px"></div> Chi nhánh</div>
            <div class="legend-item"><div class="loc-dot" style="background:#22c55e;border-radius:50%;width:10px;height:10px"></div> Khu vực phục vụ</div>
        </div>

        <!-- CTA -->
        <div class="sidebar-section">
            <a href="<%= request.getContextPath() %>/map/survey" class="btn-cta">📝 Đặt lịch khảo sát</a>
            <a href="<%= request.getContextPath() %>/chat/page" class="btn-outline">🤖 Hỏi AI tư vấn</a>
        </div>

    </div><!-- /sidebar -->

    <!-- MAP -->
    <div id="map"></div>

        </div> <%-- /.map-layout --%>

    </div> <%-- /.sb-content --%>

</div> <%-- /.sb-layout --%>

<!-- Leaflet JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<script>
    // ===== INIT MAP =====
    const map = L.map('map', {
        center: [10.7284, 106.7218],
        zoom: 12,
        zoomControl: true
    });

    // Tile layer (OpenStreetMap – free, no key)
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '© <a href="https://openstreetmap.org">OpenStreetMap</a> contributors'
    }).addTo(map);

    // ===== CUSTOM ICONS =====
    function makeIcon(color) {
        return L.divIcon({
            className: '',
            html: `<div style="
                width:14px;height:14px;border-radius:50%;
                background:${color};
                border:2px solid #fff;
                box-shadow:0 2px 6px rgba(0,0,0,.4)
            "></div>`,
            iconSize: [14, 14],
            iconAnchor: [7, 7],
            popupAnchor: [0, -10]
        });
    }

    function makeHQIcon() {
        return L.divIcon({
            className: '',
            html: `<div style="
                width:22px;height:22px;border-radius:50%;
                background:#3b82f6;
                border:3px solid #fff;
                box-shadow:0 3px 10px rgba(59,130,246,.6);
                display:flex;align-items:center;justify-content:center;
                font-size:11px;
            ">🚚</div>`,
            iconSize: [22, 22],
            iconAnchor: [11, 11],
            popupAnchor: [0, -14]
        });
    }

    function popup(title, addr, badge, badgeClass) {
        return `<div class="custom-popup">
            <h4>${title}</h4>
            <p>${addr}</p>
            <span class="popup-badge ${badgeClass}">${badge}</span>
        </div>`;
    }

    // ===== HQ MARKER =====
    L.marker([10.7284, 106.7218], { icon: makeHQIcon() })
        .addTo(map)
        .bindPopup(popup('SafeMove – Trụ sở chính','123 Nguyễn Văn Linh, Quận 7, TP.HCM','HEADQUARTERS','badge-hq'))
        .openPopup();

    // ===== DEPOTS =====
    const depots = [
        { lat: 10.7180, lng: 106.6892, name: 'Kho Bình Chánh', addr: 'QL 50, Bình Chánh, TP.HCM' },
        { lat: 10.6780, lng: 106.7023, name: 'Kho Nhà Bè',     addr: 'Nguyễn Hữu Thọ, Nhà Bè' },
    ];
    depots.forEach(d => {
        L.marker([d.lat, d.lng], { icon: makeIcon('#f97316') })
            .addTo(map)
            .bindPopup(popup(d.name, d.addr, 'KHO BÃI', 'badge-depot'));
    });

    // ===== BRANCHES =====
    const branches = [
        { lat: 10.8411, lng: 106.7688, name: 'Chi nhánh Thủ Đức', addr: 'Xa lộ Hà Nội, Thủ Đức' },
        { lat: 10.7942, lng: 106.6521, name: 'Chi nhánh Bình Tân', addr: 'Kinh Dương Vương, Bình Tân' },
        { lat: 10.7764, lng: 106.6590, name: 'Chi nhánh Q.6',      addr: 'Hậu Giang, Quận 6' },
    ];
    branches.forEach(b => {
        L.marker([b.lat, b.lng], { icon: makeIcon('#8b5cf6') })
            .addTo(map)
            .bindPopup(popup(b.name, b.addr, 'CHI NHÁNH', 'badge-zone'));
    });

    // ===== SERVICE ZONES (circles) =====
    const zones = [
        { lat: 10.7630, lng: 106.6602, r: 3000, color: '#3b82f6', label: 'Vùng 1 – Nội thành' },
        { lat: 10.8200, lng: 106.7500, r: 4000, color: '#22c55e', label: 'Vùng 2 – Thủ Đức' },
        { lat: 10.7100, lng: 106.6500, r: 3500, color: '#22c55e', label: 'Vùng 3 – Nam Sài Gòn' },
    ];
    zones.forEach(z => {
        L.circle([z.lat, z.lng], {
            radius: z.r,
            color: z.color,
            fillColor: z.color,
            fillOpacity: 0.08,
            weight: 1.5,
            dashArray: '6 4'
        }).addTo(map).bindTooltip(z.label, { permanent: false });
    });

    // ===== FLY TO FUNCTION (sidebar click) =====
    function flyTo(lat, lng, name) {
        map.flyTo([lat, lng], 15, { duration: 1.2 });
    }
</script>

<!-- AI Widget -->
<jsp:include page="/Views/Chat/chatWidget.jsp"/>

</body>
</html>

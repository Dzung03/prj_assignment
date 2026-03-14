<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SafeMove – Đặt lịch khảo sát</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/sidebar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/survey-request.css">
</head>
<body>

<%
    String success = request.getParameter("success");
    String error   = request.getParameter("error");
%>

<div class="sb-layout">

    <%@ include file="/Views/Customer/sidebar-customer.jsp" %>

    <div class="sb-content">

<div class="survey-layout">

    <!-- FORM PANEL -->
    <div class="form-panel">
        <div class="form-header">
            <h2>📝 Đặt lịch khảo sát</h2>
            <p>Chọn địa chỉ trên bản đồ hoặc nhập thủ công</p>
        </div>

        <form class="form-body" id="surveyForm"
              method="post"
              action="<%= request.getContextPath() %>/survey">

            <div class="alert-success" id="successAlert" <%= (success != null ? "" : "style=\"display:none;\"") %>>
                ✅ Yêu cầu đã được gửi thành công! Chúng tôi sẽ liên hệ trong 24 giờ.
            </div>

            <div class="map-hint">📍 Click vào bản đồ để chọn địa chỉ tự động</div>

            <div class="form-group">
                <label>Họ và tên <span class="required">*</span></label>
                <input type="text" class="form-control"
                       id="fullName" name="fullName"
                       placeholder="Nguyễn Văn A">
            </div>

            <div class="form-group">
                <label>Số điện thoại <span class="required">*</span></label>
                <input type="tel" class="form-control"
                       id="phone" name="phone"
                       placeholder="0901 234 567">
            </div>

            <div class="form-group">
                <label>Địa chỉ điểm lấy hàng <span class="required">*</span></label>
                <div class="address-row">
                    <input type="text" class="form-control"
                           id="pickupAddr" name="pickupAddr"
                           placeholder="Click bản đồ hoặc nhập...">
                    <button type="button" class="btn-locate" onclick="locateMe()">📍 Vị trí</button>
                </div>
                <div class="coords-display" id="pickupCoords">Chưa chọn vị trí</div>
            </div>

            <div class="form-group">
                <label>Địa chỉ điểm giao hàng <span class="required">*</span></label>
                <input type="text" class="form-control"
                       id="dropAddr" name="dropAddr"
                       placeholder="Nhập địa chỉ giao hàng...">
            </div>

            <div class="form-group">
                <label>Gói dịch vụ</label>
                <select class="form-control" id="servicePackageId" name="servicePackageId">
                    <option value="">Chọn gói phù hợp...</option>
                    <%
                        java.util.List<Model.ServicePackage> pkgs =
                                (java.util.List<Model.ServicePackage>) request.getAttribute("packages");
                        if (pkgs != null) {
                            for (Model.ServicePackage p : pkgs) {
                    %>
                        <option value="<%= p.getId() %>">
                            <%= p.getName() %> - Cơ bản: <%= p.getDefaultBasePrice() %>₫, /km: <%= p.getPricePerKm() %>₫
                        </option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div class="form-group">
                <label>Thêm xe (ngoài số xe mặc định)</label>
                <input type="number" min="0" value="0"
                       class="form-control"
                       id="extraVehicle" name="extraVehicle">
            </div>

            <div class="form-group">
                <label>Thêm nhân viên (ngoài cấu hình mặc định)</label>
                <input type="number" min="0" value="0"
                       class="form-control"
                       id="extraStaff" name="extraStaff">
            </div>

            <div class="form-group">
                <label>Ngày chuyển mong muốn</label>
                <input type="date" class="form-control"
                       id="moveDate" name="moveDate">
            </div>

            <div class="form-group">
                <label>Ghi chú thêm</label>
                <textarea class="form-control"
                          id="notes" name="notes"
                          placeholder="Hàng dễ vỡ, cần thang máy, số tầng..."></textarea>
            </div>

            <input type="hidden" id="pickupLat" name="pickupLat">
            <input type="hidden" id="pickupLng" name="pickupLng">
            <input type="hidden" id="distanceKm" name="distanceKm">

        </form>

        <div class="form-footer">
            <button class="btn-submit" type="button" onclick="submitForm()">
                🚀 Gửi yêu cầu khảo sát
            </button>
        </div>
    </div>

    <!-- MAP -->
    <div id="map"></div>

</div> <%-- /.survey-layout --%>

    </div> <%-- /.sb-content --%>

</div> <%-- /.sb-layout --%>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    const CTX  = '<%= request.getContextPath() %>';
    let pickupMarker = null;
    let pickupLat = null, pickupLng = null;

    // Init map
    const map = L.map('map', { center: [10.7769, 106.7009], zoom: 12 });
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '© OpenStreetMap contributors'
    }).addTo(map);

    // SafeMove HQ marker (fixed)
    L.marker([10.7284, 106.7218], {
        icon: L.divIcon({
            className: '',
            html: '<div style="font-size:22px">🚚</div>',
            iconSize: [24, 24], iconAnchor: [12, 12]
        })
    }).addTo(map).bindTooltip('SafeMove HQ', { permanent: true, direction: 'right' });

    // Click map → set pickup address
    map.on('click', async function(e) {
        const { lat, lng } = e.latlng;

        // Update or create marker
        if (pickupMarker) {
            pickupMarker.setLatLng([lat, lng]);
        } else {
            pickupMarker = L.marker([lat, lng], {
                icon: L.divIcon({
                    className: '',
                    html: `<div style="
                        background:#ef4444;color:#fff;
                        border-radius:50%;width:20px;height:20px;
                        display:flex;align-items:center;justify-content:center;
                        font-size:12px;border:2px solid #fff;
                        box-shadow:0 2px 6px rgba(0,0,0,.4)
                    ">P</div>`,
                    iconSize: [20, 20], iconAnchor: [10, 10]
                }),
                draggable: true
            }).addTo(map);

            // Allow dragging
            pickupMarker.on('dragend', async function(ev) {
                const pos = ev.target.getLatLng();
                await reverseGeocode(pos.lat, pos.lng);
            });
        }

        pickupLat = lat;
        pickupLng = lng;
        document.getElementById('pickupCoords').textContent =
            `📍 Lat: ${lat.toFixed(5)}, Lng: ${lng.toFixed(5)}`;

        document.getElementById('pickupLat').value = lat;
        document.getElementById('pickupLng').value = lng;

        await reverseGeocode(lat, lng);
    });

    // Reverse geocoding via Nominatim (free, no key)
    async function reverseGeocode(lat, lng) {
        try {
            const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&accept-language=vi`;
            const res  = await fetch(url, { headers: { 'Accept-Language': 'vi' } });
            const data = await res.json();

            if (data && data.display_name) {
                document.getElementById('pickupAddr').value = data.display_name;
            }
        } catch (e) {
            console.warn('Geocoding failed:', e);
            document.getElementById('pickupAddr').value = `${lat.toFixed(5)}, ${lng.toFixed(5)}`;
        }
    }

    // Use browser location
    function locateMe() {
        if (!navigator.geolocation) {
            alert('Trình duyệt không hỗ trợ định vị.');
            return;
        }
        navigator.geolocation.getCurrentPosition(
            pos => {
                const { latitude: lat, longitude: lng } = pos.coords;
                map.flyTo([lat, lng], 16);
                map.fire('click', { latlng: L.latLng(lat, lng) });
            },
            err => alert('Không lấy được vị trí: ' + err.message)
        );
    }

    // Submit
    function submitForm() {
        const name  = document.getElementById('fullName').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const addr  = document.getElementById('pickupAddr').value.trim();

        if (!name || !phone || !addr) {
            alert('Vui lòng điền đầy đủ: Họ tên, Số điện thoại, Địa chỉ lấy hàng.');
            return;
        }

        document.getElementById('surveyForm').submit();
    }
</script>

<jsp:include page="/Views/Chat/chatWidget.jsp"/>
</body>
</html>

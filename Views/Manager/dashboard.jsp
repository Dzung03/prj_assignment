<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, Model.Vehicle, Model.User, Model.enums.VehicleStatus" %>
<%@ page import="java.util.List" %>
<%
    String section     = (String) request.getAttribute("section");
    if (section == null) section = "vehicle";

    List<Vehicle> vehicles  = (List<Vehicle>) request.getAttribute("vehicles");
    List<User>    staffList = (List<User>)   request.getAttribute("staffList");

    String successMsg = (String) session.getAttribute("adminSuccess");
    String errorMsg   = (String) session.getAttribute("adminError");
    if (successMsg != null) session.removeAttribute("adminSuccess");
    if (errorMsg   != null) session.removeAttribute("adminError");

    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SafeMove – Admin Dashboard</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/admin-dashboard.css"/>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/admin-map.css"/>
</head>
<body>

<!-- ================================================
     SIDEBAR
================================================ -->
<div class="sidebar-trigger"></div>
    <div class="sidebar">
        <div class="sidebar-logo">
            <div class="icon">🚚</div>
            <div>
                <div class="brand">SafeMove</div>
                <div class="sub">ADMIN PANEL</div>
            </div>
        </div>

        <nav class="sidebar-nav">
            <div class="nav-section-label">Management</div>

            <a href="<%= ctx %>/admin/dashboard?section=vehicle"
            class="nav-item <%= "vehicle".equals(section) ? "active" : "" %>">
                <span class="nav-icon">🚛</span> Vehicles
            </a>
            <a href="<%= ctx %>/admin/dashboard?section=contract"
            class="nav-item <%= "contract".equals(section) ? "active" : "" %>">
                <span class="nav-icon">📋</span> Contracts
            </a>
            <a href="<%= ctx %>/admin/dashboard?section=service"
            class="nav-item <%= "service".equals(section) ? "active" : "" %>">
                <span class="nav-icon">📝</span> Service Requests
            </a>
            <a href="<%= ctx %>/admin/dashboard?section=staff"
            class="nav-item <%= "staff".equals(section) ? "active" : "" %>">
                <span class="nav-icon">👷</span> Staff
            </a>

            <div class="nav-section-label" style="margin-top:.5rem;">Quick Links</div>
            <a href="<%= ctx %>/home" class="nav-item">
                <span class="nav-icon">🏠</span> Home
            </a>
            <a href="<%= ctx %>/chat/page" class="nav-item">
                <span class="nav-icon">🤖</span> AI Assistant
            </a>
        </nav>

        <div class="sidebar-footer">
            <div class="user-card">
                <div class="user-avatar">M</div>
                <div class="user-info">
                    <div class="name">Manager</div>
                    <div class="role">Admin Panel</div>
                </div>
            </div>
            <a href="<%= ctx %>/login" class="btn-logout">🚪 Logout</a>
        </div>
</div>


<!-- ================================================
     MAIN
================================================ -->
<div class="main">

    <!-- Top bar -->
    <div class="topbar">
        <div class="topbar-title">
            Admin <span>Dashboard</span>
        </div>
        <div class="topbar-right">
            <span class="topbar-badge">MANAGER</span>
        </div>
    </div>

    <!-- Content -->
    <div class="content">

        <!-- Alerts -->
        <% if (successMsg != null) { %>
            <div class="alert alert-success">✅ <%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="alert alert-danger">❌ <%= errorMsg %></div>
        <% } %>


        <!-- ================================================
             VEHICLE SECTION
        ================================================ -->
        <% if ("vehicle".equals(section)) {
            int total = (vehicles != null) ? vehicles.size() : 0;
            int available = 0, assigned = 0, maintenance = 0;
            if (vehicles != null) {
                for (Vehicle v : vehicles) {
                    switch (v.getStatus()) {
                        case AVAILABLE:
                            available++;
                            break;
                        case ASSIGNED:
                            assigned++;
                            break;
                        case MAINTENANCE:
                            maintenance++;
                            break;
                    }
                }
            }
        %>
        <div class="section-header">
            <div>
                <h1>🚛 Vehicles</h1>
                <div class="breadcrumb">Admin <span>/ Vehicles</span></div>
            </div>
            <button class="btn btn-primary" onclick="openPanel('add')">
                    ➕ Add Vehicle
            </button>
        </div>

        <!-- Stats -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-icon blue">🚛</div>
                <div>
                    <div class="stat-value"><%= total %></div>
                    <div class="stat-label">Total Vehicles</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">✅</div>
                <div>
                    <div class="stat-value"><%= available %></div>
                    <div class="stat-label">Available</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue">📦</div>
                <div>
                    <div class="stat-value"><%= assigned %></div>
                    <div class="stat-label">Assigned</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">🔧</div>
                <div>
                    <div class="stat-value"><%= maintenance %></div>
                    <div class="stat-label">Maintenance</div>
                </div>
            </div>
        </div>

        <!-- Table -->
        <div class="table-card">
            <div class="table-card-header">
                <h2>All Vehicles <span class="count">(<%= total %> records)</span></h2>
            </div>

            <% if (vehicles == null || vehicles.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🚛</div>
                    <p>No vehicles found. Click "Add Vehicle" to get started.</p>
                </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Plate Number</th>
                        <th>Type</th>
                        <th>Capacity (m³)</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% int i = 1; for (Vehicle v : vehicles) {
                        String badge, badgeCls;
                        switch (v.getStatus()) {
                            case AVAILABLE:
                                badge = "Available"; badgeCls = "badge-green";
                                break;
                            case ASSIGNED:
                                badge = "Assigned"; badgeCls = "badge-blue";
                                break;
                            default:
                                badge = "Maintenance"; badgeCls = "badge-orange";
                                break;
                        }
                    %>
                    <tr>
                        <td><%= i++ %></td>
                        <td class="td-bold"><%= v.getVehicleCode() %></td>
                        <td><%= v.getType() %></td>
                        <td><%= v.getCapacity() %></td>
                        <td><span class="badge <%= badgeCls %>"><%= badge %></span></td>
                        <td>
                            <div class="actions-cell">
                                <button class="btn btn-warning"
                                    onclick="openPanel('edit',
                                        '<%= v.getId() %>',
                                        '<%= v.getVehicleCode().replace("'","''") %>',
                                        '<%= v.getType().replace("'","''") %>',
                                        '<%= v.getCapacity() %>',
                                        '<%= v.getStatus().getValue() %>'
                                    )">
                                    ✏️ Edit
                                </button>
                                <form method="post" action="<%= ctx %>/admin/vehicle/delete"
                                      onsubmit="return confirm('Delete vehicle <%= v.getVehicleCode() %>?');"
                                      style="display:inline">
                                    <input type="hidden" name="id" value="<%= v.getId() %>">
                                    <button type="submit" class="btn btn-danger">🗑️ Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
        <% } /* end vehicle */ %>


        <!-- ================================================
             STAFF SECTION
        ================================================ -->
        <% if ("staff".equals(section)) {
            int total = (staffList != null) ? staffList.size() : 0;
        %>
        <div class="section-header">
            <div>
                <h1>👷 Staff</h1>
                <div class="breadcrumb">Admin <span>/ Staff</span></div>
            </div>
        </div>

        <div class="table-card">
            <div class="table-card-header">
                <h2>Staff Members <span class="count">(<%= total %> records)</span></h2>
            </div>

            <% if (staffList == null || staffList.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">👷</div>
                    <p>No staff members found.</p>
                </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% int j = 1; for (User u : staffList) {
                        String statusCls = "ACTIVE".equals(u.getStatus() != null ? u.getStatus().getValue() : "")
                            ? "badge-green" : "badge-red";
                        String statusLabel = u.getStatus() != null ? u.getStatus().getValue() : "—";
                    %>
                    <tr>
                        <td><%= j++ %></td>
                        <td class="td-bold"><%= u.getFullName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getPhone() %></td>
                        <td><span class="badge <%= statusCls %>"><%= statusLabel %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
        <% } /* end staff */ %>


        <!-- ================================================
             CONTRACT / SERVICE – COMING SOON
        ================================================ -->
        <% if ("contract".equals(section)) { %>
        <div class="section-header">
            <div>
                <h1>📋 Contracts</h1>
                <div class="breadcrumb">Admin <span>/ Contracts</span></div>
            </div>
        </div>
        <div class="coming-soon">
            <div class="icon">📋</div>
            <h3>Contracts Module</h3>
            <p>This section is under development. Coming soon!</p>
        </div>
        <% } %>

        <% if ("service".equals(section)) { %>
        <div class="section-header">
            <div>
                <h1>📝 Service Requests</h1>
                <div class="breadcrumb">Admin <span>/ Service Requests</span></div>
            </div>
        </div>
        <div class="coming-soon">
            <div class="icon">📝</div>
            <h3>Service Requests Module</h3>
            <p>This section is under development. Coming soon!</p>
        </div>
        <% } %>

        <!-- ================================================
             MAP SECTION
        ================================================ -->
        <% if ("map".equals(section)) { %>
        <div class="section-header">
            <div>
                <h1>🗺️ Map View</h1>
                <div class="breadcrumb">Admin <span>/ Map – Vehicle & Delivery Locations</span></div>
            </div>
            <a href="<%= ctx %>/map/page" class="btn btn-outline" target="_blank">🗺️ Full Map</a>
        </div>

        <div class="admin-map-wrap">
            <div id="adminMap"></div>
            <div class="map-legend-bar">
                <div class="litem"><div class="leg-dot" style="background:#3b82f6"></div> HQ</div>
                <div class="litem"><div class="leg-dot" style="background:#22c55e"></div> Available Vehicles</div>
                <div class="litem"><div class="leg-dot" style="background:#f97316"></div> Depots</div>
                <div class="litem"><div class="leg-dot" style="background:#8b5cf6"></div> Branches</div>
            </div>
        </div>
        <% } /* end map */ %>


    </div><!-- /content -->
</div><!-- /main -->


<!-- ================================================
     OVERLAY + SIDE PANEL (Add / Edit Vehicle)
================================================ -->
<div class="overlay" id="overlay" onclick="closePanel()"></div>

<div class="side-panel" id="sidePanel">
    <div class="panel-header">
        <h3 id="panelTitle">Add Vehicle</h3>
        <button class="panel-close" onclick="closePanel()">✕</button>
    </div>

    <form id="panelForm" method="post" action="<%= ctx %>/admin/vehicle/add">
        <div class="panel-body">
            <input type="hidden" id="vehicleId" name="id">

            <div class="form-group">
                <label for="plateNumber">Plate Number *</label>
                <input type="text" id="plateNumber" name="plateNumber"
                       class="form-control" placeholder="e.g. 51F-123.45"
                       maxlength="20" required>
            </div>

            <div class="form-group">
                <label for="type">Vehicle Type *</label>
                <input type="text" id="type" name="type"
                       class="form-control" placeholder="e.g. Truck 1 ton, Van"
                       maxlength="50" required>
            </div>

            <div class="form-group">
                <label for="capacity">Capacity (m³) *</label>
                <input type="number" id="capacity" name="capacity"
                       class="form-control" placeholder="e.g. 5"
                       min="1" max="9999" required>
            </div>

            <div class="form-group">
                <label for="status">Status *</label>
                <select id="status" name="status" class="form-control" required>
                    <option value="AVAILABLE">✅ Available</option>
                    <option value="ASSIGNED">📦 Assigned</option>
                    <option value="MAINTENANCE">🔧 Maintenance</option>
                </select>
            </div>
        </div>

        <div class="panel-footer">
            <button type="button" class="btn btn-outline" onclick="closePanel()">Cancel</button>
            <button type="submit" id="panelSubmitBtn" class="btn btn-primary">
                💾 Save Vehicle
            </button>
        </div>
    </form>
</div>

<!-- ================================================
     AI CHAT WIDGET
================================================ -->
<jsp:include page="/Views/Chat/chatWidget.jsp"/>


<script>
    const CTX = '<%= ctx %>';

    /* ===== PANEL CONTROL ===== */
    const panel   = document.getElementById('sidePanel');
    const overlay = document.getElementById('overlay');

    function openPanel(mode, id, plate, type, capacity, status) {
        const isEdit = mode === 'edit';

        document.getElementById('panelTitle').textContent = isEdit ? 'Edit Vehicle' : 'Add Vehicle';
        document.getElementById('panelForm').action = CTX + '/admin/vehicle/' + (isEdit ? 'edit' : 'add');
        document.getElementById('panelSubmitBtn').textContent = isEdit ? '💾 Update' : '💾 Save Vehicle';

        // Reset / pre-fill fields
        document.getElementById('vehicleId').value  = isEdit ? id       : '';
        document.getElementById('plateNumber').value = isEdit ? plate    : '';
        document.getElementById('type').value        = isEdit ? type     : '';
        document.getElementById('capacity').value    = isEdit ? capacity : '';
        document.getElementById('status').value      = isEdit ? status   : 'AVAILABLE';

        panel.classList.add('open');
        overlay.classList.add('show');
        document.getElementById('plateNumber').focus();
    }

    function closePanel() {
        panel.classList.remove('open');
        overlay.classList.remove('show');
    }

    /* ===== ESC KEY ===== */
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') closePanel();
    });

    /* ===== AUTO-DISMISS ALERTS ===== */
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(a => {
        setTimeout(() => { a.style.opacity = '0'; a.style.transition = 'opacity .5s'; }, 3500);
        setTimeout(() => { a.remove(); }, 4000);
    });
</script>

<!-- Leaflet JS (only used on Map section) -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    // Init admin map only when #adminMap exists
    const adminMapEl = document.getElementById('adminMap');
    if (adminMapEl) {
        const amap = L.map('adminMap', { center: [10.7420, 106.6900], zoom: 12 });
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19, attribution: '&copy; OpenStreetMap'
        }).addTo(amap);

        function mkIcon(color, emoji) {
            return L.divIcon({ className:'', iconSize:[18,18], iconAnchor:[9,9], popupAnchor:[0,-10],
                html:`<div style="width:18px;height:18px;border-radius:50%;background:${color};
                    border:2px solid #fff;box-shadow:0 2px 6px rgba(0,0,0,.35);
                    display:flex;align-items:center;justify-content:center;font-size:10px;">${emoji||''}</div>`
            });
        }

        // HQ
        L.marker([10.7284,106.7218], {icon: mkIcon('#3b82f6','🚚')}).addTo(amap)
         .bindPopup('<b>SafeMove HQ</b><br>Nguyễn Văn Linh, Q.7').openPopup();

        // Vehicles (Available)
        [[10.7630,106.6602,'51F-123.45'],[10.7900,106.7100,'51G-456.78'],
         [10.7400,106.7400,'51H-789.01'],[10.8100,106.6800,'51K-234.56']].forEach(v => {
            L.marker([v[0],v[1]], {icon: mkIcon('#22c55e','')}).addTo(amap)
             .bindPopup(`<b>Vehicle: ${v[2]}</b><br><span style="color:#166534;font-size:.75rem">✅ Available</span>`);
        });

        // Depots
        [[10.7180,106.6892,'Kho Bình Chánh'],[10.6780,106.7023,'Kho Nhà Bè']].forEach(d => {
            L.marker([d[0],d[1]], {icon: mkIcon('#f97316','')}).addTo(amap)
             .bindPopup(`<b>${d[2]}</b><br><span style="color:#c2410c;font-size:.75rem">📦 Depot</span>`);
        });

        // Service zone circle
        L.circle([10.7630,106.6602], {
            radius: 14000, color:'#3b82f6',
            fillColor:'#3b82f6', fillOpacity:0.06,
            weight: 1.5, dashArray:'6 4'
        }).addTo(amap).bindTooltip('Khu vực phục vụ HCM', {permanent:false});
    }
</script>

</body>
</html>


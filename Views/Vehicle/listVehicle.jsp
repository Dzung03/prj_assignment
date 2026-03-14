<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, Model.Vehicle, Model.enums.VehicleStatus" %>
<%
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    String reqError   = (String) request.getAttribute("error");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/Views/Chat/chatWidget.jsp"/>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SafeMove – Quản lý xe tải</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f8;
            color: #2d3748;
            min-height: 100vh;
        }

        /* TOP BAR */
        .topbar {
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
            color: #fff;
            padding: 0 2rem;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,.3);
        }
        .topbar .logo { font-size: 1.3rem; font-weight: 700; letter-spacing: 1px; color: #63b3ed; }
        .topbar nav a {
            color: #e2e8f0; text-decoration: none;
            margin-left: 1.5rem; font-size: .9rem; transition: color .2s;
        }
        .topbar nav a:hover { color: #63b3ed; }

        /* MAIN */
        .container { max-width: 1100px; margin: 2.5rem auto; padding: 0 1.5rem; }

        .page-header {
            display: flex; align-items: center;
            justify-content: space-between; margin-bottom: 1.5rem;
        }
        .page-header h1 { font-size: 1.6rem; font-weight: 700; color: #1a202c; }
        .page-header h1 span { color: #3182ce; }

        /* BUTTONS */
        .btn {
            display: inline-flex; align-items: center; gap: .4rem;
            padding: .55rem 1.2rem; border-radius: 8px; font-size: .88rem;
            font-weight: 600; cursor: pointer; border: none;
            text-decoration: none; transition: all .2s;
        }
        .btn-primary  { background: #3182ce; color: #fff; }
        .btn-primary:hover  { background: #2b6cb0; transform: translateY(-1px); }
        .btn-warning  { background: #dd6b20; color: #fff; }
        .btn-warning:hover  { background: #c05621; transform: translateY(-1px); }
        .btn-danger   { background: #e53e3e; color: #fff; }
        .btn-danger:hover   { background: #c53030; transform: translateY(-1px); }
        .btn-sm { padding: .35rem .85rem; font-size: .82rem; }

        /* ALERTS */
        .alert {
            padding: .85rem 1.2rem; border-radius: 8px; margin-bottom: 1.2rem;
            font-size: .9rem; font-weight: 500;
            display: flex; align-items: center; gap: .5rem;
        }
        .alert-success { background: #c6f6d5; color: #276749; border-left: 4px solid #38a169; }
        .alert-danger  { background: #fed7d7; color: #742a2a; border-left: 4px solid #e53e3e; }

        /* CARD / TABLE */
        .card { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,.08); overflow: hidden; }

        table { width: 100%; border-collapse: collapse; }
        thead { background: linear-gradient(135deg, #2b6cb0, #3182ce); color: #fff; }
        thead th {
            padding: 1rem 1.2rem; text-align: left; font-size: .85rem;
            font-weight: 600; letter-spacing: .5px; text-transform: uppercase;
        }
        tbody tr { border-bottom: 1px solid #edf2f7; transition: background .15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #ebf8ff; }
        tbody td { padding: .9rem 1.2rem; font-size: .9rem; vertical-align: middle; }

        /* STATUS BADGES */
        .badge {
            display: inline-block; padding: .25rem .75rem; border-radius: 20px;
            font-size: .78rem; font-weight: 700; letter-spacing: .3px;
        }
        .badge-available   { background: #c6f6d5; color: #276749; }
        .badge-assigned    { background: #bee3f8; color: #2b6cb0; }
        .badge-maintenance { background: #feebc8; color: #c05621; }

        /* EMPTY STATE */
        .empty-state { text-align: center; padding: 4rem 2rem; color: #718096; }
        .empty-state .icon { font-size: 3.5rem; margin-bottom: 1rem; }
        .empty-state p { font-size: 1rem; margin-bottom: 1rem; }

        .actions { display: flex; gap: .5rem; }
    </style>
</head>
<body>

<!-- TOP BAR -->
<div class="topbar">
    <div class="logo">🚚 SafeMove</div>
    <nav>
        <a href="<%= request.getContextPath() %>/home">Trang chủ</a>
        <a href="<%= request.getContextPath() %>/vehicle/list">Xe tải</a>
    </nav>
</div>

<!-- MAIN -->
<div class="container">

    <div class="page-header">
        <h1>Quản lý <span>Xe tải</span></h1>
        <a href="<%= request.getContextPath() %>/vehicle/add" class="btn btn-primary">
            ➕ Thêm xe mới
        </a>
    </div>

    <!-- Flash messages -->
    <% if (successMsg != null) { %>
        <div class="alert alert-success">✅ <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="alert alert-danger">❌ <%= errorMsg %></div>
    <% } %>
    <% if (reqError != null) { %>
        <div class="alert alert-danger">❌ <%= reqError %></div>
    <% } %>

    <!-- Table -->
    <div class="card">
        <% if (vehicles == null || vehicles.isEmpty()) { %>
            <div class="empty-state">
                <div class="icon">🚛</div>
                <p>Chưa có xe nào được thêm vào hệ thống.</p>
                <a href="<%= request.getContextPath() %>/vehicle/add" class="btn btn-primary">
                    ➕ Thêm xe đầu tiên
                </a>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Biển số</th>
                        <th>Loại xe</th>
                        <th>Sức chứa (m³)</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% int i = 1;
                       for (Vehicle v : vehicles) {
                           String badgeClass;
                           switch (v.getStatus()) {
                               case AVAILABLE:   badgeClass = "badge-available";   break;
                               case ASSIGNED:    badgeClass = "badge-assigned";    break;
                               default:          badgeClass = "badge-maintenance"; break;
                           }
                    %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong><%= v.getVehicleCode() %></strong></td>
                        <td><%= v.getType() %></td>
                        <td><%= v.getCapacity() %></td>
                        <td>
                            <span class="badge <%= badgeClass %>">
                                <%= v.getStatus().getLabel() %>
                            </span>
                        </td>
                        <td>
                            <div class="actions">
                                <a href="<%= request.getContextPath() %>/vehicle/edit?id=<%= v.getId() %>"
                                   class="btn btn-warning btn-sm">✏️ Sửa</a>

                                <form method="post"
                                      action="<%= request.getContextPath() %>/vehicle/delete"
                                      onsubmit="return confirm('Bạn có chắc muốn xoá xe <%= v.getVehicleCode() %>?');">
                                    <input type="hidden" name="id" value="<%= v.getId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm">🗑️ Xoá</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>

</div>

<!-- ===== AI CHAT WIDGET ===== -->
<jsp:include page="/Views/Chat/chatWidget.jsp"/>

</body>
</html>

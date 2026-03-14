<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Model.Vehicle" %>
<%
    Vehicle vehicle  = (Vehicle) request.getAttribute("vehicle");
    String error     = (String)  request.getAttribute("error");
    String capacity  = (String)  request.getAttribute("capacity");   // giá trị lỗi user nhập
    String status    = (String)  request.getAttribute("status");     // giá trị lỗi user nhập

    // Nếu không có lỗi thì lấy từ vehicle object
    String capValue    = (capacity != null) ? capacity : (vehicle != null ? String.valueOf(vehicle.getCapacity()) : "");
    String statusValue = (status   != null) ? status   : (vehicle != null ? vehicle.getStatus().getValue() : "AVAILABLE");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/Views/Chat/chatWidget.jsp"/>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SafeMove – Chỉnh sửa xe</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f8; color: #2d3748; min-height: 100vh;
        }

        .topbar {
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
            color: #fff; padding: 0 2rem; height: 60px;
            display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,.3);
        }
        .topbar .logo { font-size: 1.3rem; font-weight: 700; letter-spacing: 1px; color: #63b3ed; }
        .topbar nav a {
            color: #e2e8f0; text-decoration: none;
            margin-left: 1.5rem; font-size: .9rem; transition: color .2s;
        }
        .topbar nav a:hover { color: #63b3ed; }

        .container { max-width: 600px; margin: 3rem auto; padding: 0 1.5rem; }

        .card { background: #fff; border-radius: 14px; box-shadow: 0 4px 20px rgba(0,0,0,.1); overflow: hidden; }
        .card-header {
            background: linear-gradient(135deg, #744210, #dd6b20);
            color: #fff; padding: 1.4rem 1.8rem;
        }
        .card-header h1 { font-size: 1.25rem; font-weight: 700; }
        .card-header p  { font-size: .85rem; opacity: .85; margin-top: .25rem; }
        .card-body { padding: 1.8rem; }

        .vehicle-id-badge {
            display: inline-block; background: rgba(255,255,255,.2);
            padding: .15rem .6rem; border-radius: 20px;
            font-size: .78rem; margin-left: .5rem; font-weight: 600;
        }

        .alert {
            padding: .8rem 1rem; border-radius: 8px; margin-bottom: 1.2rem;
            font-size: .88rem; font-weight: 500; border-left: 4px solid;
        }
        .alert-danger { background: #fed7d7; color: #742a2a; border-color: #e53e3e; }

        .form-group { margin-bottom: 1.2rem; }
        .form-group label { display: block; font-size: .85rem; font-weight: 600; color: #4a5568; margin-bottom: .4rem; }
        .form-group label .required { color: #e53e3e; margin-left: 2px; }

        .form-control {
            width: 100%; padding: .65rem .9rem;
            border: 1.5px solid #e2e8f0; border-radius: 8px;
            font-size: .9rem; color: #2d3748; outline: none;
            transition: border-color .2s, box-shadow .2s; background: #f7fafc;
        }
        .form-control:focus {
            border-color: #dd6b20;
            box-shadow: 0 0 0 3px rgba(221,107,32,.2);
            background: #fff;
        }
        select.form-control { cursor: pointer; }

        .form-actions { display: flex; gap: 1rem; margin-top: 1.8rem; }
        .btn {
            flex: 1; padding: .7rem 1rem; border-radius: 8px; font-size: .92rem;
            font-weight: 600; cursor: pointer; border: none; text-align: center;
            text-decoration: none; display: inline-flex; align-items: center;
            justify-content: center; gap: .4rem; transition: all .2s;
        }
        .btn-warning   { background: #dd6b20; color: #fff; }
        .btn-warning:hover   { background: #c05621; transform: translateY(-1px); }
        .btn-secondary { background: #edf2f7; color: #4a5568; }
        .btn-secondary:hover { background: #e2e8f0; }

        .hint { font-size: .78rem; color: #718096; margin-top: .3rem; }
    </style>
</head>
<body>

<div class="topbar">
    <div class="logo">🚚 SafeMove</div>
    <nav>
        <a href="<%= request.getContextPath() %>/home">Trang chủ</a>
        <a href="<%= request.getContextPath() %>/vehicle/list">← Danh sách xe</a>
    </nav>
</div>

<div class="container">
    <div class="card">
        <div class="card-header">
            <h1>✏️ Chỉnh sửa xe
                <% if (vehicle != null) { %>
                    <span class="vehicle-id-badge">#<%= vehicle.getId() %></span>
                <% } %>
            </h1>
            <p>Cập nhật thông tin phương tiện trong hệ thống</p>
        </div>
        <div class="card-body">

            <% if (error != null) { %>
                <div class="alert alert-danger">❌ <%= error %></div>
            <% } %>

            <% if (vehicle != null) { %>
            <form method="post" action="<%= request.getContextPath() %>/vehicle/edit">
                <input type="hidden" name="id" value="<%= vehicle.getId() %>">

                <div class="form-group">
                    <label for="plateNumber">Biển số xe <span class="required">*</span></label>
                    <input type="text" id="plateNumber" name="plateNumber" class="form-control"
                           placeholder="VD: 51F-123.45"
                           value="<%= vehicle.getVehicleCode() %>"
                           maxlength="20" required>
                    <div class="hint">Biển số phải là duy nhất trong hệ thống.</div>
                </div>

                <div class="form-group">
                    <label for="type">Loại xe <span class="required">*</span></label>
                    <input type="text" id="type" name="type" class="form-control"
                           placeholder="VD: Xe tải 1 tấn, Xe van"
                           value="<%= vehicle.getType() %>"
                           maxlength="50" required>
                </div>

                <div class="form-group">
                    <label for="capacity">Sức chứa (m³) <span class="required">*</span></label>
                    <input type="number" id="capacity" name="capacity" class="form-control"
                           value="<%= capValue %>"
                           min="1" max="9999" required>
                </div>

                <div class="form-group">
                    <label for="status">Trạng thái <span class="required">*</span></label>
                    <select id="status" name="status" class="form-control" required>
                        <option value="AVAILABLE"   <%= "AVAILABLE".equals(statusValue)   ? "selected" : "" %>>✅ Sẵn sàng</option>
                        <option value="ASSIGNED"    <%= "ASSIGNED".equals(statusValue)    ? "selected" : "" %>>📦 Đã phân công</option>
                        <option value="MAINTENANCE" <%= "MAINTENANCE".equals(statusValue) ? "selected" : "" %>>🔧 Bảo trì</option>
                    </select>
                </div>

                <div class="form-actions">
                    <a href="<%= request.getContextPath() %>/vehicle/list" class="btn btn-secondary">
                        ← Huỷ
                    </a>
                    <button type="submit" class="btn btn-warning">
                        💾 Cập nhật
                    </button>
                </div>

            </form>
            <% } else { %>
                <p style="color:#718096;">Không tìm thấy xe để chỉnh sửa.
                   <a href="<%= request.getContextPath() %>/vehicle/list">← Quay lại danh sách</a>
                </p>
            <% } %>

        </div>
    </div>
</div>

</body>
</html>

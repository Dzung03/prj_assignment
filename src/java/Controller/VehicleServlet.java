package Controller;

import Service.VehicleService;
import Model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * VehicleServlet – xử lý CRUD xe tải
 *
 *  URL pattern: /vehicle/*
 *  GET  /vehicle/list      → danh sách
 *  GET  /vehicle/add       → form thêm mới
 *  POST /vehicle/add       → lưu xe mới
 *  GET  /vehicle/edit?id=X → form chỉnh sửa
 *  POST /vehicle/edit      → lưu chỉnh sửa
 *  POST /vehicle/delete    → xoá xe
 */
public class VehicleServlet extends HttpServlet {

    private final VehicleService vehicleService = new VehicleService();

    // ============================================================
    // GET
    // ============================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        switch (action) {
            case "add"  -> showAddForm(request, response);
            case "edit" -> showEditForm(request, response);
            default     -> showList(request, response);   // "list" hoặc bất kỳ
        }
    }

    // ============================================================
    // POST
    // ============================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = getAction(request);

        switch (action) {
            case "add"    -> handleAdd(request, response);
            case "edit"   -> handleEdit(request, response);
            case "delete" -> handleDelete(request, response);
            default       -> response.sendRedirect(request.getContextPath() + "/vehicle/list");
        }
    }

    // ============================================================
    // HELPERS – lấy action từ pathInfo
    // ============================================================
    private String getAction(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();    // e.g. "/list", "/add", "/edit"
        if (pathInfo == null || pathInfo.equals("/")) return "list";
        return pathInfo.substring(1);               // bỏ dấu "/"
    }

    // ============================================================
    // SHOW LIST
    // ============================================================
    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Vehicle> vehicles = vehicleService.getAllVehicles();
        request.setAttribute("vehicles", vehicles);
        request.getRequestDispatcher("/Views/Vehicle/listVehicle.jsp")
               .forward(request, response);
    }

    // ============================================================
    // SHOW ADD FORM
    // ============================================================
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/Views/Vehicle/addVehicle.jsp")
               .forward(request, response);
    }

    // ============================================================
    // SHOW EDIT FORM
    // ============================================================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/vehicle/list");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Vehicle vehicle = vehicleService.getById(id);

            if (vehicle == null) {
                request.setAttribute("error", "Không tìm thấy xe ID = " + id);
                showList(request, response);
                return;
            }

            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("/Views/Vehicle/editVehicle.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/vehicle/list");
        }
    }

    // ============================================================
    // HANDLE ADD
    // ============================================================
    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String plateNumber = request.getParameter("plateNumber");
        String type        = request.getParameter("type");
        String capacity    = request.getParameter("capacity");
        String status      = request.getParameter("status");

        String error = vehicleService.addVehicle(plateNumber, type, capacity, status);

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("plateNumber", plateNumber);
            request.setAttribute("type", type);
            request.setAttribute("capacity", capacity);
            request.setAttribute("status", status);
            request.getRequestDispatcher("/Views/Vehicle/addVehicle.jsp")
                   .forward(request, response);
        } else {
            request.getSession().setAttribute("successMsg", "Thêm xe thành công!");
            response.sendRedirect(request.getContextPath() + "/vehicle/list");
        }
    }

    // ============================================================
    // HANDLE EDIT
    // ============================================================
    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam     = request.getParameter("id");
        String plateNumber = request.getParameter("plateNumber");
        String type        = request.getParameter("type");
        String capacity    = request.getParameter("capacity");
        String status      = request.getParameter("status");

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/vehicle/list");
            return;
        }

        String error = vehicleService.updateVehicle(id, plateNumber, type, capacity, status);

        if (error != null) {
            Vehicle vehicle = vehicleService.getById(id);
            if (vehicle != null) {
                // Giữ lại giá trị user vừa nhập
                vehicle.setVehicleCode(plateNumber);
                vehicle.setType(type);
            }
            request.setAttribute("vehicle", vehicle);
            request.setAttribute("error", error);
            request.setAttribute("capacity", capacity);
            request.setAttribute("status", status);
            request.getRequestDispatcher("/Views/Vehicle/editVehicle.jsp")
                   .forward(request, response);
        } else {
            request.getSession().setAttribute("successMsg", "Cập nhật xe thành công!");
            response.sendRedirect(request.getContextPath() + "/vehicle/list");
        }
    }

    // ============================================================
    // HANDLE DELETE
    // ============================================================
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        try {
            int id = Integer.parseInt(idParam);
            String error = vehicleService.deleteVehicle(id);

            if (error != null) {
                request.getSession().setAttribute("errorMsg", error);
            } else {
                request.getSession().setAttribute("successMsg", "Xoá xe thành công!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "ID xe không hợp lệ.");
        }

        response.sendRedirect(request.getContextPath() + "/vehicle/list");
    }
}

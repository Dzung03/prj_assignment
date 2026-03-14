package Controller;

import DAO.UserDAO;
import DAO.VehicleDAO;
import Model.User;
import Model.Vehicle;
import Service.VehicleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * AdminServlet – quản lý dashboard cho Admin/Manager
 *
 *  URL pattern : /admin/*
 *  GET  /admin/dashboard?section=vehicle  → danh sách xe
 *  GET  /admin/dashboard?section=staff    → danh sách staff
 *  GET  /admin/dashboard?section=contract → (coming soon)
 *  GET  /admin/dashboard?section=service  → (coming soon)
 *
 *  POST /admin/vehicle/add    → thêm xe
 *  POST /admin/vehicle/edit   → sửa xe
 *  POST /admin/vehicle/delete → xoá xe
 */
public class AdminServlet extends HttpServlet {

    private final VehicleService vehicleService = new VehicleService();
    private final UserDAO        userDAO        = new UserDAO();

    // ============================================================
    // GET
    // ============================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) pathInfo = "/dashboard";

        switch (pathInfo) {
            case "/dashboard" -> handleDashboard(request, response);
            default           -> handleDashboard(request, response);
        }
    }

    // ============================================================
    // POST
    // ============================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "";

        switch (pathInfo) {
            case "/vehicle/add" -> {
                String error = vehicleService.addVehicle(
                        request.getParameter("plateNumber"),
                        request.getParameter("type"),
                        request.getParameter("capacity"),
                        request.getParameter("status")
                );
                if (error != null) {
                    request.getSession().setAttribute("adminError", error);
                } else {
                    request.getSession().setAttribute("adminSuccess", "Vehicle added successfully!");
                }
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?section=vehicle");
            }
            case "/vehicle/edit" -> {
                int id = parseId(request.getParameter("id"));
                String error = vehicleService.updateVehicle(id,
                        request.getParameter("plateNumber"),
                        request.getParameter("type"),
                        request.getParameter("capacity"),
                        request.getParameter("status")
                );
                if (error != null) {
                    request.getSession().setAttribute("adminError", error);
                } else {
                    request.getSession().setAttribute("adminSuccess", "Vehicle updated successfully!");
                }
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?section=vehicle");
            }
            case "/vehicle/delete" -> {
                int id = parseId(request.getParameter("id"));
                String error = vehicleService.deleteVehicle(id);
                if (error != null) {
                    request.getSession().setAttribute("adminError", error);
                } else {
                    request.getSession().setAttribute("adminSuccess", "Vehicle deleted successfully!");
                }
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?section=vehicle");
            }
            default -> response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    // ============================================================
    // HANDLE DASHBOARD
    // ============================================================
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String section = request.getParameter("section");
        if (section == null || section.isEmpty()) section = "vehicle";

        request.setAttribute("section", section);

        switch (section) {
            case "vehicle" -> {
                List<Vehicle> vehicles = vehicleService.getAllVehicles();
                request.setAttribute("vehicles", vehicles);
            }
            case "staff" -> {
                List<User> staffList = userDAO.findAllByRole("STAFF");
                request.setAttribute("staffList", staffList);
            }
        }

        request.getRequestDispatcher("/Views/Manager/dashboard.jsp")
               .forward(request, response);
    }

    // ============================================================
    // HELPER
    // ============================================================
    private int parseId(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
    }
}

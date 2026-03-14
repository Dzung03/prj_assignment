package Controller;

import Model.ServicePackage;
import Service.PackageService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PackageServlet", urlPatterns = {
        "/packages",
        "/package-detail",
        "/admin/packages",
        "/admin/package-delete"
})
public class PackageServlet extends HttpServlet {

    private PackageService packageService;

    @Override
    public void init() {
        packageService = new PackageService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {

            // =========================
            // CUSTOMER VIEW PACKAGES
            // =========================
            case "/packages":

                List<ServicePackage> packages =
                        packageService.getActivePackages();

                request.setAttribute("packages", packages);

                request.getRequestDispatcher("/packages.jsp")
                        .forward(request, response);

                break;

            // =========================
            // PACKAGE DETAIL
            // =========================
            case "/package-detail":

                int id = Integer.parseInt(request.getParameter("id"));

                ServicePackage pkg =
                        packageService.getPackageById(id);

                request.setAttribute("package", pkg);

                request.getRequestDispatcher("/package-detail.jsp")
                        .forward(request, response);

                break;

            // =========================
            // ADMIN LIST PACKAGES
            // =========================
            case "/admin/packages":

                List<ServicePackage> allPackages =
                        packageService.getAllPackages();

                request.setAttribute("packages", allPackages);

                request.getRequestDispatcher("/admin-packages.jsp")
                        .forward(request, response);

                break;

            // =========================
            // DELETE PACKAGE
            // =========================
            case "/admin/package-delete":

                int deleteId =
                        Integer.parseInt(request.getParameter("id"));

                packageService.deletePackage(deleteId);

                response.sendRedirect("packages");

                break;
        }
    }
}
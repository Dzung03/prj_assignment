/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import DAO.SurveyDAO;
import DAO.ServicePackageDAO;
import Model.SurveyRequest;
import Model.User;
import Model.ServicePackage;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;

/**
 *
 * @author ASUS
 */
public class SurveyServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SurveyServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SurveyServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ServicePackageDAO pkgDao = new ServicePackageDAO();
        request.setAttribute("packages", pkgDao.findActive());

        request.getRequestDispatcher("/Views/Customer/surveyRequest.jsp")
               .forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pickupAddr    = request.getParameter("pickupAddr");
        String dropAddr      = request.getParameter("dropAddr");
        String distanceStr   = request.getParameter("distanceKm");
        String packageIdStr  = request.getParameter("servicePackageId");
        String extraStaffStr = request.getParameter("extraStaff");
        String extraVehStr   = request.getParameter("extraVehicle");

        double distanceKm = 0;
        if (distanceStr != null && !distanceStr.isBlank()) {
            try {
                distanceKm = Double.parseDouble(distanceStr);
            } catch (NumberFormatException ignored) {
                distanceKm = 0;
            }
        }

        int packageId = 0;
        if (packageIdStr != null && !packageIdStr.isBlank()) {
            try {
                packageId = Integer.parseInt(packageIdStr);
            } catch (NumberFormatException ignored) {
                packageId = 0;
            }
        }

        int extraStaff = 0;
        if (extraStaffStr != null && !extraStaffStr.isBlank()) {
            try {
                extraStaff = Integer.parseInt(extraStaffStr);
            } catch (NumberFormatException ignored) {
                extraStaff = 0;
            }
        }

        int extraVehicle = 0;
        if (extraVehStr != null && !extraVehStr.isBlank()) {
            try {
                extraVehicle = Integer.parseInt(extraVehStr);
            } catch (NumberFormatException ignored) {
                extraVehicle = 0;
            }
        }

        double totalPrice = 0;
        if (packageId > 0) {
            ServicePackageDAO pkgDao = new ServicePackageDAO();
            ServicePackage pkg = pkgDao.findById(packageId);
            if (pkg != null) {
                totalPrice = pkg.getDefaultBasePrice()
                        + distanceKm * pkg.getPricePerKm()
                        + extraStaff * pkg.getExtraStaffPrice()
                        + extraVehicle * pkg.getExtraVehiclePrice();
            }
        }

        SurveyRequest s = new SurveyRequest();
        s.setCustomerId(user.getId());
        s.setServicePackageId(packageId);
        s.setPickupAddress(pickupAddr);
        s.setDeliveryAddress(dropAddr);
        s.setDistanceKm(distanceKm);
        s.setExtraStaff(extraStaff);
        s.setExtraVehicle(extraVehicle);
        s.setTotalPrice(totalPrice);

        SurveyDAO dao = new SurveyDAO();
        boolean ok = dao.create(s);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/survey?success=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/survey?error=1");
        }
    }
}


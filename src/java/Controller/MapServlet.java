    package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * MapServlet – phục vụ các trang bản đồ
 *  GET /map/page    → trang bản đồ đầy đủ
 *  GET /map/survey  → form yêu cầu khảo sát + address picker
 */
public class MapServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "/page";

        switch (pathInfo) {
            case "/survey" ->
                request.getRequestDispatcher("/Views/Customer/surveyRequest.jsp")
                       .forward(request, response);
            default ->
                request.getRequestDispatcher("/Views/Map/mapPage.jsp")
                       .forward(request, response);
        }
    }
}

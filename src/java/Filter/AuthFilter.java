package Filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        HttpSession session = req.getSession(false);

        boolean loggedIn = (session != null &&
                            session.getAttribute("user") != null);

        // ===== Các URL KHÔNG cần login =====
        boolean publicResource =
                uri.equals(contextPath + "/home") ||
                uri.equals(contextPath + "/") ||
                uri.endsWith("login") ||
                uri.endsWith("register") ||
                uri.contains("css") ||
                uri.contains("js") ||
                uri.contains("images");

        if (loggedIn || publicResource) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(contextPath + "/login");
        }
    }
}
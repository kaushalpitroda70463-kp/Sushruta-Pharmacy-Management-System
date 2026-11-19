package filter;

import model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication & Role Authorization Filter
 * Protects /manager/* and /pharmacist/* endpoints from unauthenticated access
 * and enforces role-based separation of privileges.
 */
@WebFilter(urlPatterns = {"/manager/*", "/pharmacist/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Prevent browser caching of sensitive authenticated pages
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();

        // 1. Check if user is authenticated
        if (currentUser == null) {
            response.sendRedirect(contextPath + "/login.jsp?error=unauthorized");
            return;
        }

        if (session != null && session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
        }

        // 2. Role-Based Access Control
        boolean isManagerRoute = uri.contains("/manager/");
        boolean isPharmacistRoute = uri.contains("/pharmacist/");

        if (isManagerRoute && !currentUser.isInventoryManager()) {
            // A Pharmacist attempting to access Inventory Manager routes
            response.sendRedirect(contextPath + "/pharmacist/dashboard.jsp?error=forbidden");
            return;
        }

        if (isPharmacistRoute && !currentUser.isPharmacist() && !currentUser.isInventoryManager()) {
            response.sendRedirect(contextPath + "/login.jsp?error=unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

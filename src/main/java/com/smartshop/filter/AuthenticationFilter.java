package com.smartshop.filter;

import com.smartshop.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Security filter enforcing Role-Based Access Control (RBAC).
 * Enforces authorization policies across Buyer, Seller, and Admin routes.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
        "/cart", "/checkout", "/orders", "/review/*",
        "/seller/*", "/admin/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        // 1. Unauthenticated users trying to access protected paths
        if (loggedUser == null) {
            session = httpRequest.getSession(true);
            session.setAttribute("authMessage", "Please login with your account to access that page.");
            httpResponse.sendRedirect(contextPath + "/login?redirect=" + java.net.URLEncoder.encode(path, "UTF-8"));
            return;
        }

        // 2. Seller role authorization check
        if (path.startsWith("/seller")) {
            if (!loggedUser.isSeller() && !loggedUser.isAdmin()) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Seller privileges required.");
                return;
            }
        }

        // 3. Admin role authorization check
        if (path.startsWith("/admin")) {
            if (!loggedUser.isAdmin()) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Administrator privileges required.");
                return;
            }
        }

        // User is authenticated and authorized for the requested path
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

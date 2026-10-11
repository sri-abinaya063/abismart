package com.smartshop.controller;

import com.smartshop.dao.CartDAO;
import com.smartshop.dao.UserDAO;
import com.smartshop.model.User;
import com.smartshop.util.PasswordUtil;
import com.smartshop.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller handling user authentication, session creation, and role redirection.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;
    private CartDAO cartDAO;

    @Override
    public void init() {
        this.userDAO = new UserDAO();
        this.cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            User user = (User) session.getAttribute("loggedUser");
            redirectByUserRole(request, response, user);
            return;
        }

        String redirect = request.getParameter("redirect");
        request.setAttribute("redirectUrl", redirect);
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirectUrl = request.getParameter("redirectUrl");

        if (!ValidationUtil.isValidEmail(email) || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Please provide a valid email address and password.");
            request.setAttribute("email", email);
            request.setAttribute("redirectUrl", redirectUrl);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByEmail(email);

        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
            // Protect against session fixation
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("loggedUser", user);

            if (user.isBuyer()) {
                int cartCount = cartDAO.getCartItemCount(user.getId());
                newSession.setAttribute("cartCount", cartCount);
            }

            if (redirectUrl != null && !redirectUrl.trim().isEmpty() && !redirectUrl.contains("login") && !redirectUrl.contains("register")) {
                response.sendRedirect(request.getContextPath() + redirectUrl);
            } else {
                redirectByUserRole(request, response, user);
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
            request.setAttribute("email", email);
            request.setAttribute("redirectUrl", redirectUrl);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    private void redirectByUserRole(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String context = request.getContextPath();
        if (user.isAdmin()) {
            response.sendRedirect(context + "/admin/dashboard");
        } else if (user.isSeller()) {
            response.sendRedirect(context + "/seller/dashboard");
        } else {
            response.sendRedirect(context + "/home");
        }
    }
}

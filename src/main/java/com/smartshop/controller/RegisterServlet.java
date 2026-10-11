package com.smartshop.controller;

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
 * Controller handling new Buyer and Seller account registration.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // Normalize role
        if (!"seller".equalsIgnoreCase(role)) {
            role = "buyer";
        }

        // Validate fields
        if (fullName == null || fullName.trim().isEmpty()) {
            forwardWithError(request, response, "Please enter your full name.", fullName, email, role);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            forwardWithError(request, response, "Please enter a valid email address.", fullName, email, role);
            return;
        }

        if (!ValidationUtil.isValidPassword(password)) {
            forwardWithError(request, response, "Password must be at least 6 characters long.", fullName, email, role);
            return;
        }

        if (!password.equals(confirmPassword)) {
            forwardWithError(request, response, "Passwords do not match.", fullName, email, role);
            return;
        }

        // Check if email already registered
        if (userDAO.findByEmail(email) != null) {
            forwardWithError(request, response, "An account with this email address already exists.", fullName, email, role);
            return;
        }

        // Hash password and persist user
        String hashedPassword = PasswordUtil.hashPassword(password);
        User newUser = new User(fullName.trim(), email.trim().toLowerCase(), hashedPassword, role.toLowerCase());

        boolean created = userDAO.create(newUser);
        if (created) {
            // Auto login user into session
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedUser", newUser);
            session.setAttribute("flashSuccess", "Registration successful! Welcome to SmartShop.");

            if ("seller".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/seller/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            forwardWithError(request, response, "An error occurred during registration. Please try again.", fullName, email, role);
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response,
                                  String message, String fullName, String email, String role)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("role", role);
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
}

package com.smartshop.controller;

import com.smartshop.dao.UserDAO;
import com.smartshop.model.User;
import com.smartshop.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Administrator User Management (view, role edit, account deletion).
 */
@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users"})
public class AdminUserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (admin == null || !admin.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<User> users = userDAO.findAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (admin == null || !admin.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int targetUserId = ValidationUtil.parseInt(request.getParameter("userId"), -1);

        if ("delete".equalsIgnoreCase(action)) {
            if (targetUserId == admin.getId()) {
                session.setAttribute("flashError", "You cannot delete your own administrator account.");
            } else {
                userDAO.delete(targetUserId);
                session.setAttribute("flashSuccess", "User account removed successfully.");
            }
        } else if ("updateRole".equalsIgnoreCase(action)) {
            String newRole = request.getParameter("role");
            User targetUser = userDAO.findById(targetUserId);
            if (targetUser != null && ("buyer".equals(newRole) || "seller".equals(newRole) || "admin".equals(newRole))) {
                targetUser.setRole(newRole);
                userDAO.update(targetUser);
                session.setAttribute("flashSuccess", "User role changed to '" + newRole + "'.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}

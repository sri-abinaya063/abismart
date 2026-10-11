package com.smartshop.controller;

import com.smartshop.dao.OrderDAO;
import com.smartshop.model.Order;
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
 * Controller for Administrator Order Fulfillment and Status Management.
 */
@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders"})
public class AdminOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        this.orderDAO = new OrderDAO();
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

        List<Order> orders = orderDAO.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
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

        int orderId = ValidationUtil.parseInt(request.getParameter("orderId"), -1);
        String status = request.getParameter("status");

        if (orderId > 0 && status != null && ("PENDING".equalsIgnoreCase(status) || 
                "SHIPPED".equalsIgnoreCase(status) || "DELIVERED".equalsIgnoreCase(status))) {
            orderDAO.updateOrderStatus(orderId, status);
            session.setAttribute("flashSuccess", "Order #" + orderId + " status updated to " + status.toUpperCase() + ".");
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}

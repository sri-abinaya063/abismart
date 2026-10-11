package com.smartshop.controller;

import com.smartshop.dao.CartDAO;
import com.smartshop.dao.OrderDAO;
import com.smartshop.model.CartItem;
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
import java.sql.SQLException;
import java.util.List;

/**
 * Controller executing ACID transactional Checkout flow and Order Confirmation.
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout", "/order-success"})
public class CheckoutServlet extends HttpServlet {

    private CartDAO cartDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        this.cartDAO = new CartDAO();
        this.orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/checkout");
            return;
        }

        String path = request.getServletPath();

        // Handle Order Success Page
        if ("/order-success".equals(path)) {
            int orderId = ValidationUtil.parseInt(request.getParameter("orderId"), -1);
            if (orderId > 0) {
                Order order = orderDAO.getOrderById(orderId);
                if (order != null && (order.getBuyerId() == user.getId() || user.isAdmin())) {
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/WEB-INF/views/order-success.jsp").forward(request, response);
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        // Handle Checkout Form View
        List<CartItem> cartItems = cartDAO.getCartByBuyerId(user.getId());
        if (cartItems.isEmpty()) {
            session.setAttribute("flashError", "Your shopping cart is empty.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double subtotal = 0.0;
        for (CartItem item : cartItems) {
            subtotal += item.getSubtotal();
        }

        double shipping = (subtotal > 0 && subtotal < 50.0) ? 9.99 : 0.0;
        double tax = Math.round(subtotal * 0.08 * 100.0) / 100.0;
        double grandTotal = Math.round((subtotal + shipping + tax) * 100.0) / 100.0;

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shipping", shipping);
        request.setAttribute("tax", tax);
        request.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartByBuyerId(user.getId());
        if (cartItems.isEmpty()) {
            session.setAttribute("flashError", "Your cart is empty. Please add items before checking out.");
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        // Form fields for address & payment
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String zip = request.getParameter("zip");
        String paymentMethod = request.getParameter("paymentMethod");

        if (address == null || address.trim().isEmpty() || city == null || city.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please provide a complete shipping address.");
            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
            return;
        }

        double subtotal = 0.0;
        for (CartItem item : cartItems) {
            subtotal += item.getSubtotal();
        }
        double shipping = (subtotal > 0 && subtotal < 50.0) ? 9.99 : 0.0;
        double tax = Math.round(subtotal * 0.08 * 100.0) / 100.0;
        double grandTotal = Math.round((subtotal + shipping + tax) * 100.0) / 100.0;

        try {
            int orderId = orderDAO.placeOrder(user.getId(), cartItems, grandTotal);
            if (orderId > 0) {
                session.setAttribute("cartCount", 0);
                response.sendRedirect(request.getContextPath() + "/order-success?orderId=" + orderId);
            } else {
                session.setAttribute("flashError", "Checkout could not be completed. Please review your cart.");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } catch (SQLException e) {
            session.setAttribute("flashError", "Order placement failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}

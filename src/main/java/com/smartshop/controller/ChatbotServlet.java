package com.smartshop.controller;

import com.google.gson.Gson;
import com.smartshop.dao.OrderDAO;
import com.smartshop.dao.ProductDAO;
import com.smartshop.model.Order;
import com.smartshop.model.Product;
import com.smartshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.*;

/**
 * Intelligent AI Chatbot Assistant endpoint answering customer queries dynamically in JSON.
 */
@WebServlet(name = "ChatbotServlet", urlPatterns = {"/api/chatbot"})
public class ChatbotServlet extends HttpServlet {

    private final Gson gson = new Gson();
    private OrderDAO orderDAO;
    private ProductDAO productDAO;

    @Override
    public void init() {
        this.orderDAO = new OrderDAO();
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String msg = request.getParameter("message");
        processMessage(msg, request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String message = null;

        // Try reading JSON body first
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        if (sb.length() > 0) {
            try {
                Map<String, String> body = gson.fromJson(sb.toString(), Map.class);
                if (body != null) {
                    message = body.get("message");
                }
            } catch (Exception ignored) {
            }
        }

        if (message == null || message.trim().isEmpty()) {
            message = request.getParameter("message");
        }

        processMessage(message, request, response);
    }

    private void processMessage(String message, HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        String query = (message != null) ? message.trim().toLowerCase() : "";

        String reply;
        List<String> quickReplies = new ArrayList<>();

        if (query.isEmpty() || query.contains("hello") || query.contains("hi") || query.contains("hey")) {
            String userName = (user != null) ? user.getFullName() : "there";
            reply = "Hello " + userName + "! 👋 I'm your SmartShop AI Assistant. How can I help you today?";
            quickReplies.addAll(Arrays.asList("Where is my order?", "Recommend products", "Return policy", "Payment methods"));

        } else if (query.contains("order") || query.contains("track") || query.contains("delivery") || query.contains("status")) {
            if (user != null) {
                List<Order> orders = orderDAO.getOrdersByBuyerId(user.getId());
                if (!orders.isEmpty()) {
                    Order latest = orders.get(0);
                    reply = "📦 <strong>Order #" + latest.getId() + "</strong> is currently <strong>" + latest.getStatus() + 
                            "</strong>.<br>Placed on " + latest.getCreatedAt() + " for a total of $" + String.format("%.2f", latest.getTotalAmount()) + 
                            ". <a href='" + request.getContextPath() + "/orders' class='text-primary fw-bold'>View all orders &rarr;</a>";
                } else {
                    reply = "You don't have any past orders yet. Browse our catalog to place your first order!";
                }
            } else {
                reply = "To check your order status, please <a href='" + request.getContextPath() + "/login' class='text-primary fw-bold'>Log In</a> to your account, or provide your Order ID.";
            }
            quickReplies.addAll(Arrays.asList("Delivery times", "Return policy", "Browse Deals"));

        } else if (query.contains("return") || query.contains("refund") || query.contains("exchange")) {
            reply = "🔄 <strong>30-Day Hassle-Free Returns</strong>:<br>" +
                    "• Returns are accepted within 30 days of delivery.<br>" +
                    "• Items must be in original condition and packaging.<br>" +
                    "• Refunds are processed to the original payment method within 3-5 business days.";
            quickReplies.addAll(Arrays.asList("Payment methods", "Contact support", "Recommend products"));

        } else if (query.contains("payment") || query.contains("pay") || query.contains("card") || query.contains("upi") || query.contains("cod")) {
            reply = "💳 <strong>Accepted Payment Methods</strong>:<br>" +
                    "• Credit & Debit Cards (Visa, MasterCard, Amex)<br>" +
                    "• Net Banking & UPI / Instant Transfers<br>" +
                    "• Cash on Delivery (COD) for eligible locations.<br>" +
                    "All transactions are secured with 256-bit SSL encryption.";
            quickReplies.addAll(Arrays.asList("Return policy", "Where is my order?", "Recommend products"));

        } else if (query.contains("recommend") || query.contains("suggest") || query.contains("laptop") || 
                   query.contains("headphone") || query.contains("popular") || query.contains("best")) {
            List<Product> featured = productDAO.getFeaturedProducts(3);
            StringBuilder sb = new StringBuilder("⭐ <strong>Top Recommendations For You:</strong><ul class='list-unstyled mt-2 mb-0'>");
            for (Product p : featured) {
                sb.append("<li class='mb-2'>• <a href='").append(request.getContextPath())
                  .append("/product?id=").append(p.getId()).append("' class='text-decoration-none fw-bold'>")
                  .append(p.getName()).append("</a> - $").append(String.format("%.2f", p.getPrice()))
                  .append(" (★ ").append(p.getAverageRating()).append(")</li>");
            }
            sb.append("</ul>");
            reply = sb.toString();
            quickReplies.addAll(Arrays.asList("Electronics", "Fashion", "Where is my order?"));

        } else if (query.contains("shipping") || query.contains("delivery time") || query.contains("free shipping")) {
            reply = "🚚 <strong>Shipping Policy</strong>:<br>" +
                    "• <strong>Free standard shipping</strong> on orders over $50.00!<br>" +
                    "• Standard delivery arrives in 3-5 business days.<br>" +
                    "• Express 2-day delivery is available at checkout.";
            quickReplies.addAll(Arrays.asList("Track Order", "Payment methods", "Return policy"));

        } else if (query.contains("contact") || query.contains("support") || query.contains("help") || query.contains("phone")) {
            reply = "📞 <strong>SmartShop Customer Support</strong>:<br>" +
                    "• Email: support@smartshop.com<br>" +
                    "• Phone: +1 (800) 555-SMART (Mon-Fri 9am-6pm EST)<br>" +
                    "• Live Chat: Available 24/7 right here!";
            quickReplies.addAll(Arrays.asList("Where is my order?", "Return policy", "Recommend products"));

        } else {
            reply = "I'm here to help with order tracking, product recommendations, payment methods, returns, and store policies. What would you like to know?";
            quickReplies.addAll(Arrays.asList("Where is my order?", "Recommend products", "Return policy", "Payment methods"));
        }

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("reply", reply);
        jsonResponse.put("quickReplies", quickReplies);
        jsonResponse.put("timestamp", System.currentTimeMillis());

        response.getWriter().write(gson.toJson(jsonResponse));
    }
}

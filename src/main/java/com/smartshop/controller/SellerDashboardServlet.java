package com.smartshop.controller;

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

import java.io.IOException;
import java.util.List;

/**
 * Controller for Seller Dashboard showing inventory overview, low stock alerts, and orders.
 */
@WebServlet(name = "SellerDashboardServlet", urlPatterns = {"/seller/dashboard"})
public class SellerDashboardServlet extends HttpServlet {

    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        this.productDAO = new ProductDAO();
        this.orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User seller = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (seller == null || (!seller.isSeller() && !seller.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Product> products = productDAO.findBySellerId(seller.getId());
        List<Order> orders = orderDAO.getOrdersBySellerId(seller.getId());

        int lowStockCount = 0;
        int totalUnits = 0;
        for (Product p : products) {
            totalUnits += p.getStock();
            if (p.getStock() <= 10) {
                lowStockCount++;
            }
        }

        request.setAttribute("products", products);
        request.setAttribute("orders", orders);
        request.setAttribute("totalProducts", products.size());
        request.setAttribute("totalUnits", totalUnits);
        request.setAttribute("lowStockCount", lowStockCount);

        request.getRequestDispatcher("/WEB-INF/views/seller/dashboard.jsp").forward(request, response);
    }
}

package com.smartshop.controller;

import com.smartshop.dao.CartDAO;
import com.smartshop.dao.ProductDAO;
import com.smartshop.model.CartItem;
import com.smartshop.model.Product;
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
 * Controller managing Buyer active shopping cart operations (add, update, remove, view).
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() {
        this.cartDAO = new CartDAO();
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/cart");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartByBuyerId(user.getId());
        double subtotal = 0.0;
        for (CartItem item : cartItems) {
            subtotal += item.getSubtotal();
        }

        double shipping = (subtotal > 0 && subtotal < 50.0) ? 9.99 : 0.0;
        double tax = Math.round(subtotal * 0.08 * 100.0) / 100.0; // 8% sales tax
        double grandTotal = Math.round((subtotal + shipping + tax) * 100.0) / 100.0;

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shipping", shipping);
        request.setAttribute("tax", tax);
        request.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/cart");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "add";
        }

        switch (action) {
            case "add": {
                int productId = ValidationUtil.parseInt(request.getParameter("productId"), -1);
                int quantity = ValidationUtil.parseInt(request.getParameter("quantity"), 1);
                if (quantity < 1) quantity = 1;

                Product product = productDAO.findById(productId);
                if (product != null && product.getStock() >= quantity) {
                    cartDAO.addToCart(user.getId(), productId, quantity);
                    int newCount = cartDAO.getCartItemCount(user.getId());
                    session.setAttribute("cartCount", newCount);
                    session.setAttribute("flashSuccess", "Added '" + product.getName() + "' to cart.");
                } else {
                    session.setAttribute("flashError", "Requested quantity exceeds available stock.");
                }

                String referer = request.getHeader("referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
                break;
            }

            case "update": {
                int cartId = ValidationUtil.parseInt(request.getParameter("cartId"), -1);
                int quantity = ValidationUtil.parseInt(request.getParameter("quantity"), 1);
                cartDAO.updateQuantity(cartId, user.getId(), quantity);

                int newCount = cartDAO.getCartItemCount(user.getId());
                session.setAttribute("cartCount", newCount);
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
            }

            case "remove": {
                int cartId = ValidationUtil.parseInt(request.getParameter("cartId"), -1);
                cartDAO.removeFromCart(cartId, user.getId());

                int newCount = cartDAO.getCartItemCount(user.getId());
                session.setAttribute("cartCount", newCount);
                session.setAttribute("flashSuccess", "Item removed from cart.");
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
        }
    }
}

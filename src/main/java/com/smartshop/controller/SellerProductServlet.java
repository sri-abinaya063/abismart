package com.smartshop.controller;

import com.smartshop.dao.ProductDAO;
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

/**
 * Controller for Seller Product CRUD actions (Create, Read, Update, Delete).
 */
@WebServlet(name = "SellerProductServlet", urlPatterns = {"/seller/product"})
public class SellerProductServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        this.productDAO = new ProductDAO();
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

        String action = request.getParameter("action");
        if (action == null) {
            action = "new";
        }

        switch (action) {
            case "new": {
                request.setAttribute("product", new Product());
                request.setAttribute("isEdit", false);
                request.setAttribute("categories", productDAO.findAllCategories());
                request.getRequestDispatcher("/WEB-INF/views/seller/product-form.jsp").forward(request, response);
                break;
            }

            case "edit": {
                int id = ValidationUtil.parseInt(request.getParameter("id"), -1);
                Product product = productDAO.findById(id);
                if (product != null && (product.getSellerId() == seller.getId() || seller.isAdmin())) {
                    request.setAttribute("product", product);
                    request.setAttribute("isEdit", true);
                    request.setAttribute("categories", productDAO.findAllCategories());
                    request.getRequestDispatcher("/WEB-INF/views/seller/product-form.jsp").forward(request, response);
                } else {
                    session.setAttribute("flashError", "Product not found or unauthorized.");
                    response.sendRedirect(request.getContextPath() + "/seller/dashboard");
                }
                break;
            }

            case "delete": {
                int id = ValidationUtil.parseInt(request.getParameter("id"), -1);
                Product product = productDAO.findById(id);
                if (product != null && (product.getSellerId() == seller.getId() || seller.isAdmin())) {
                    productDAO.delete(id);
                    session.setAttribute("flashSuccess", "Product successfully deleted.");
                } else {
                    session.setAttribute("flashError", "Failed to delete product.");
                }
                response.sendRedirect(request.getContextPath() + "/seller/dashboard");
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/seller/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User seller = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (seller == null || (!seller.isSeller() && !seller.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int id = ValidationUtil.parseInt(request.getParameter("id"), 0);
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String imageUrl = request.getParameter("imageUrl");

        double price = ValidationUtil.parseDouble(priceStr, -1.0);
        int stock = ValidationUtil.parseInt(stockStr, -1);

        if (name == null || name.trim().isEmpty() || category == null || category.trim().isEmpty() ||
                price < 0 || stock < 0 || description == null || description.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please provide all required product details with positive price and stock.");
            Product p = new Product();
            p.setId(id);
            p.setName(name);
            p.setCategory(category);
            p.setDescription(description);
            p.setPrice(price > 0 ? price : 0.0);
            p.setStock(stock > 0 ? stock : 0);
            p.setImageUrl(imageUrl);
            request.setAttribute("product", p);
            request.setAttribute("isEdit", id > 0);
            request.setAttribute("categories", productDAO.findAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/seller/product-form.jsp").forward(request, response);
            return;
        }

        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            imageUrl = "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80"; // standard default image
        }

        if (id > 0) {
            // Edit existing product
            Product existing = productDAO.findById(id);
            if (existing != null && (existing.getSellerId() == seller.getId() || seller.isAdmin())) {
                existing.setName(name.trim());
                existing.setCategory(category.trim());
                existing.setDescription(description.trim());
                existing.setPrice(price);
                existing.setStock(stock);
                existing.setImageUrl(imageUrl.trim());
                productDAO.update(existing);
                session.setAttribute("flashSuccess", "Product updated successfully.");
            } else {
                session.setAttribute("flashError", "Unauthorized to update this product.");
            }
        } else {
            // Create new product
            Product newProduct = new Product();
            newProduct.setSellerId(seller.getId());
            newProduct.setName(name.trim());
            newProduct.setCategory(category.trim());
            newProduct.setDescription(description.trim());
            newProduct.setPrice(price);
            newProduct.setStock(stock);
            newProduct.setImageUrl(imageUrl.trim());

            productDAO.create(newProduct);
            session.setAttribute("flashSuccess", "Product listing published successfully.");
        }

        response.sendRedirect(request.getContextPath() + "/seller/dashboard");
    }
}

package com.smartshop.controller;

import com.smartshop.dao.ProductDAO;
import com.smartshop.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for the Homepage & Featured Catalog Showcase.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home", "/index"})
public class HomeServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Product> featuredProducts = productDAO.getFeaturedProducts(8);
        List<Product> latestProducts = productDAO.findAll();
        List<String> categories = productDAO.findAllCategories();

        // Limit latest to 8 if more
        if (latestProducts.size() > 8) {
            latestProducts = latestProducts.subList(0, 8);
        }

        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("latestProducts", latestProducts);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }
}

package com.smartshop.controller;

import com.smartshop.dao.ProductDAO;
import com.smartshop.model.Product;
import com.smartshop.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for product catalog search, category filtering, and sorting.
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        String category = request.getParameter("category");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String sortBy = request.getParameter("sort");

        Double minPrice = (minPriceStr != null && !minPriceStr.trim().isEmpty()) ?
                ValidationUtil.parseDouble(minPriceStr, 0.0) : null;
        Double maxPrice = (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) ?
                ValidationUtil.parseDouble(maxPriceStr, Double.MAX_VALUE) : null;

        List<Product> products = productDAO.searchAndFilter(query, category, minPrice, maxPrice, sortBy);
        List<String> categories = productDAO.findAllCategories();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedQuery", query);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedMinPrice", minPriceStr);
        request.setAttribute("selectedMaxPrice", maxPriceStr);
        request.setAttribute("selectedSort", sortBy);

        request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
    }
}

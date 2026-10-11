package com.smartshop.controller;

import com.smartshop.dao.ProductDAO;
import com.smartshop.dao.ReviewDAO;
import com.smartshop.model.Product;
import com.smartshop.model.Review;
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
 * Controller displaying full Product Details, verified reviews, and ratings.
 */
@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product"})
public class ProductDetailServlet extends HttpServlet {

    private ProductDAO productDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        this.productDAO = new ProductDAO();
        this.reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = ValidationUtil.parseInt(request.getParameter("id"), -1);
        if (productId <= 0) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        Product product = productDAO.findById(productId);
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found.");
            return;
        }

        List<Review> reviews = reviewDAO.getReviewsByProductId(productId);

        // Check verified buyer review eligibility
        boolean canReview = false;
        boolean alreadyReviewed = false;
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser != null && loggedUser.isBuyer()) {
            boolean hasPurchased = reviewDAO.hasBuyerOrderedProduct(loggedUser.getId(), productId);
            alreadyReviewed = reviewDAO.hasBuyerReviewedProduct(loggedUser.getId(), productId);
            canReview = hasPurchased && !alreadyReviewed;
        }

        request.setAttribute("product", product);
        request.setAttribute("reviews", reviews);
        request.setAttribute("canReview", canReview);
        request.setAttribute("alreadyReviewed", alreadyReviewed);

        request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(request, response);
    }
}

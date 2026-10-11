package com.smartshop.controller;

import com.smartshop.dao.ReviewDAO;
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

/**
 * Controller handling product rating and review submissions.
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review/add"})
public class ReviewServlet extends HttpServlet {

    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        this.reviewDAO = new ReviewDAO();
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

        int productId = ValidationUtil.parseInt(request.getParameter("productId"), -1);
        int rating = ValidationUtil.parseInt(request.getParameter("rating"), 5);
        String comment = request.getParameter("comment");

        if (productId <= 0 || rating < 1 || rating > 5 || comment == null || comment.trim().isEmpty()) {
            session.setAttribute("flashError", "Please provide a valid rating (1-5 stars) and comment.");
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
            return;
        }

        // Verify buyer purchased this product
        if (!reviewDAO.hasBuyerOrderedProduct(user.getId(), productId)) {
            session.setAttribute("flashError", "Only verified buyers who have purchased this item can leave a review.");
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
            return;
        }

        if (reviewDAO.hasBuyerReviewedProduct(user.getId(), productId)) {
            session.setAttribute("flashError", "You have already submitted a review for this product.");
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
            return;
        }

        Review review = new Review();
        review.setProductId(productId);
        review.setBuyerId(user.getId());
        review.setRating(rating);
        review.setComment(comment.trim());

        boolean success = reviewDAO.addReview(review);
        if (success) {
            session.setAttribute("flashSuccess", "Thank you! Your verified review has been published.");
        } else {
            session.setAttribute("flashError", "Could not submit review at this time.");
        }

        response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
    }
}

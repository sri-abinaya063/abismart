<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="pt-5 pb-4 mt-5">
    <div class="container">
        <div class="row g-4">
            <!-- Brand Column -->
            <div class="col-lg-4 col-md-6">
                <h5 class="text-white fw-bold d-flex align-items-center gap-2 mb-3">
                    <i class="bi bi-bag-check-fill text-primary"></i> SmartShop
                </h5>
                <p class="small text-secondary">
                    Your premier multi-vendor e-commerce marketplace powered by enterprise Jakarta EE architecture. Fast, secure, and intuitive online shopping experience.
                </p>
                <div class="d-flex gap-3 text-secondary">
                    <a href="#" class="fs-5 text-secondary"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="fs-5 text-secondary"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="fs-5 text-secondary"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="fs-5 text-secondary"><i class="bi bi-linkedin"></i></a>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white fw-semibold mb-3">Shop Categories</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="${pageContext.request.contextPath}/products?category=Electronics">Electronics</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=Fashion">Fashion & Apparel</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=Home">Home & Living</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=Sports">Sports & Fitness</a></li>
                </ul>
            </div>

            <!-- Customer Care -->
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white fw-semibold mb-3">Customer Care</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="${pageContext.request.contextPath}/orders">Order Tracking</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart">Shopping Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Sign In / Register</a></li>
                    <li><a href="javascript:void(0)" onclick="document.getElementById('chatbotToggler').click()">AI Assistant Support</a></li>
                </ul>
            </div>

            <!-- Security & Guarantee -->
            <div class="col-lg-4 col-md-6">
                <h6 class="text-white fw-semibold mb-3">Security & Trust</h6>
                <p class="small text-secondary mb-3">
                    Every order is protected by 256-bit SSL encryption and strict ACID transactional guarantees.
                </p>
                <div class="d-flex align-items-center gap-3 text-white fs-4">
                    <i class="fa-brands fa-cc-visa" title="Visa"></i>
                    <i class="fa-brands fa-cc-mastercard" title="MasterCard"></i>
                    <i class="fa-brands fa-cc-amex" title="American Express"></i>
                    <i class="fa-solid fa-shield-halved text-success" title="Secure Payment"></i>
                </div>
            </div>
        </div>

        <hr class="border-secondary my-4">

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center gap-2 small text-secondary">
            <div>&copy; 2026 SmartShop E-Commerce System. All rights reserved. Capstone Project.</div>
            <div class="d-flex gap-3">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Seller Agreement</a>
            </div>
        </div>
    </div>
</footer>

<!-- Include AI Chatbot Widget -->
<jsp:include page="chatbot.jsp" />

<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom App Scripts -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/chatbot.js"></script>

</body>
</html>

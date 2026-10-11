<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="SmartShop - Home & Featured Catalog" />
</jsp:include>

<jsp:include page="includes/navbar.jsp" />

<main class="container my-4">
    <!-- Hero Banner -->
    <div class="hero-banner mb-5 shadow-lg">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <span class="badge bg-light text-primary px-3 py-2 rounded-pill fw-bold mb-3 shadow-sm">
                    🚀 Next-Gen Multi-Vendor Marketplace
                </span>
                <h1 class="display-4 fw-extrabold text-white mb-3">Discover Quality Products At Honest Prices</h1>
                <p class="lead text-white-50 mb-4">
                    Explore curated electronics, premium fashion, home appliances, and athletic gear from verified sellers worldwide.
                </p>
                <div class="d-flex flex-wrap gap-3">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-light btn-lg rounded-pill px-4 fw-bold text-primary shadow">
                        Shop Catalog <i class="bi bi-arrow-right ms-2"></i>
                    </a>
                    <a href="javascript:void(0)" onclick="document.getElementById('chatbotToggler').click()" class="btn btn-outline-light btn-lg rounded-pill px-4 fw-semibold">
                        <i class="bi bi-chat-dots-fill me-2"></i> Ask AI Assistant
                    </a>
                </div>
            </div>
            <div class="col-lg-5 text-center d-none d-lg-block">
                <img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80" 
                     alt="E-Commerce Showcase" class="img-fluid rounded-4 shadow-lg border border-4 border-white-50" style="max-height: 320px; object-fit: cover;">
            </div>
        </div>
    </div>

    <!-- Value Propositions -->
    <div class="row g-4 mb-5 text-center">
        <div class="col-md-4">
            <div class="stat-card h-100">
                <div class="stat-icon bg-primary-subtle text-primary mx-auto mb-3">
                    <i class="bi bi-truck"></i>
                </div>
                <h5 class="fw-bold mb-2">Fast & Free Shipping</h5>
                <p class="text-muted small mb-0">Free expedited shipping on orders exceeding $50.00 with tracked delivery.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card h-100">
                <div class="stat-icon bg-success-subtle text-success mx-auto mb-3">
                    <i class="bi bi-shield-check"></i>
                </div>
                <h5 class="fw-bold mb-2">100% Secure Checkout</h5>
                <p class="text-muted small mb-0">Bank-level encryption and transactional database rollback for zero risk.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card h-100">
                <div class="stat-icon bg-warning-subtle text-warning mx-auto mb-3">
                    <i class="bi bi-arrow-counterclockwise"></i>
                </div>
                <h5 class="fw-bold mb-2">30 Days Easy Returns</h5>
                <p class="text-muted small mb-0">Hassle-free return policy with automated refund reconciliation.</p>
            </div>
        </div>
    </div>

    <!-- Category Shortcuts -->
    <div class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold mb-0">Shop by Category</h3>
            <a href="${pageContext.request.contextPath}/products" class="text-primary text-decoration-none fw-semibold">View All &rarr;</a>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-dark rounded-pill px-4">All Products</a>
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/products?category=${cat}" class="btn btn-outline-primary rounded-pill px-4">
                    ${cat}
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- Featured Products Spotlight -->
    <div class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Featured Best Sellers</h3>
                <p class="text-muted small mb-0">Hand-picked top-rated products with verified customer reviews</p>
            </div>
            <a href="${pageContext.request.contextPath}/products?sort=rating_desc" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                See Top Rated &rarr;
            </a>
        </div>

        <div class="row g-4">
            <c:forEach var="prod" items="${featuredProducts}">
                <div class="col-xl-3 col-lg-4 col-md-6">
                    <div class="card product-card">
                        <div class="product-image-container">
                            <img src="${prod.imageUrl}" class="product-image" alt="${prod.name}">
                            <span class="position-absolute top-0 start-0 m-3 badge badge-category">${prod.category}</span>
                            <c:choose>
                                <c:when test="${prod.stock > 10}">
                                    <span class="position-absolute top-0 end-0 m-3 badge bg-success badge-stock">In Stock</span>
                                </c:when>
                                <c:when test="${prod.stock > 0}">
                                    <span class="position-absolute top-0 end-0 m-3 badge bg-warning text-dark badge-stock">Only ${prod.stock} left</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="position-absolute top-0 end-0 m-3 badge bg-danger badge-stock">Out of Stock</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-1 mb-2">
                                <span class="star-rating">
                                    <i class="bi bi-star-fill text-warning"></i>
                                    <span class="fw-bold text-dark ms-1">${prod.averageRating}</span>
                                </span>
                                <span class="text-muted small">(${prod.reviewCount})</span>
                                <span class="text-muted small ms-auto text-truncate" style="max-width: 100px;">
                                    by ${prod.sellerName}
                                </span>
                            </div>
                            <h5 class="product-title">
                                <a href="${pageContext.request.contextPath}/product?id=${prod.id}">${prod.name}</a>
                            </h5>
                            <div class="mt-auto d-flex justify-content-between align-items-center pt-2">
                                <div class="product-price">
                                    $<fmt:formatNumber value="${prod.price}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                                </div>
                                <c:choose>
                                    <c:when test="${prod.stock > 0}">
                                        <form action="${pageContext.request.contextPath}/cart" method="POST" class="m-0">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${prod.id}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill px-3" title="Add to Cart">
                                                <i class="bi bi-cart-plus me-1"></i> Add
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-secondary btn-sm rounded-pill px-3" disabled>Sold Out</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</main>

<jsp:include page="includes/footer.jsp" />

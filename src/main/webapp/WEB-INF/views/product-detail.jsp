<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="${product.name} - SmartShop" />
</jsp:include>

<jsp:include page="includes/navbar.jsp" />

<main class="container my-4">
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products?category=${product.category}">${product.category}</a></li>
            <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
        </ol>
    </nav>

    <!-- Product Showcase Card -->
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 mb-5">
        <div class="row g-5 align-items-center">
            <!-- Product Image -->
            <div class="col-lg-6">
                <div class="rounded-4 overflow-hidden border bg-light position-relative" style="max-height: 480px;">
                    <img src="${product.imageUrl}" class="w-100 h-100 object-fit-cover" alt="${product.name}" style="min-height: 380px;">
                    <span class="position-absolute top-0 start-0 m-3 badge badge-category fs-6">${product.category}</span>
                </div>
            </div>

            <!-- Product Purchase Details -->
            <div class="col-lg-6">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="star-rating fs-5">
                        <i class="bi bi-star-fill text-warning"></i>
                        <span class="fw-bold text-dark ms-1">${product.averageRating}</span>
                    </span>
                    <span class="text-muted">(${product.reviewCount} customer reviews)</span>
                </div>

                <h1 class="fw-bold mb-3">${product.name}</h1>
                <p class="text-muted mb-4">
                    Sold and shipped by <span class="badge bg-light text-primary border fw-semibold">${product.sellerName}</span>
                </p>

                <div class="display-5 fw-bold text-dark mb-4">
                    $<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                </div>

                <!-- Stock status -->
                <div class="mb-4">
                    <c:choose>
                        <c:when test="${product.stock > 10}">
                            <span class="badge bg-success-subtle text-success fs-6 px-3 py-2 rounded-pill">
                                <i class="bi bi-check-circle-fill me-1"></i> In Stock (${product.stock} units available)
                            </span>
                        </c:when>
                        <c:when test="${product.stock > 0}">
                            <span class="badge bg-warning-subtle text-warning-emphasis fs-6 px-3 py-2 rounded-pill">
                                <i class="bi bi-exclamation-triangle-fill me-1"></i> Low Stock - Only ${product.stock} left!
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger-subtle text-danger fs-6 px-3 py-2 rounded-pill">
                                <i class="bi bi-x-circle-fill me-1"></i> Currently Out of Stock
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Description -->
                <div class="mb-4">
                    <h5 class="fw-bold mb-2">About this product</h5>
                    <p class="text-secondary leading-relaxed">${product.description}</p>
                </div>

                <!-- Add To Cart Form -->
                <c:choose>
                    <c:when test="${product.stock > 0}">
                        <form action="${pageContext.request.contextPath}/cart" method="POST" class="d-flex flex-wrap gap-3 align-items-center">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.id}">
                            
                            <div class="input-group" style="width: 140px;">
                                <button class="btn btn-outline-secondary btn-quantity-decrease" type="button">-</button>
                                <input type="number" name="quantity" class="form-control text-center quantity-input" value="1" min="1" max="${product.stock}" required>
                                <button class="btn btn-outline-secondary btn-quantity-increase" type="button">+</button>
                            </div>

                            <button type="submit" class="btn btn-primary btn-lg rounded-pill px-4 flex-grow-1">
                                <i class="bi bi-cart-plus me-2"></i> Add to Cart
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-secondary btn-lg rounded-pill px-5 w-100" disabled>
                            Out of Stock
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Customer Reviews & Ratings Section -->
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Customer Reviews</h3>
                <p class="text-muted small mb-0">Verified feedback from SmartShop buyers</p>
            </div>
            <div class="text-end">
                <span class="display-6 fw-bold text-dark">${product.averageRating}</span>
                <span class="text-muted">/ 5.0</span>
                <div class="text-warning small">
                    <c:forEach begin="1" end="5" var="i">
                        <i class="bi ${i <= product.averageRating ? 'bi-star-fill' : 'bi-star'}"></i>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Add Review Form (Verified Buyers Only) -->
        <c:choose>
            <c:when test="${canReview}">
                <div class="card bg-light border-0 rounded-3 p-4 mb-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-pencil-square me-2 text-primary"></i> Leave a Verified Review</h5>
                    <form action="${pageContext.request.contextPath}/review/add" method="POST">
                        <input type="hidden" name="productId" value="${product.id}">
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Rating (1 to 5 Stars)</label>
                            <select name="rating" class="form-select w-auto" required>
                                <option value="5" selected>⭐⭐⭐⭐⭐ - 5 Stars (Excellent)</option>
                                <option value="4">⭐⭐⭐⭐ - 4 Stars (Good)</option>
                                <option value="3">⭐⭐⭐ - 3 Stars (Average)</option>
                                <option value="2">⭐⭐ - 2 Stars (Poor)</option>
                                <option value="1">⭐ - 1 Star (Terrible)</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Your Review</label>
                            <textarea name="comment" class="form-control" rows="3" placeholder="Share your experience with this item..." required></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary rounded-pill px-4">Submit Review</button>
                    </form>
                </div>
            </c:when>
            <c:when test="${alreadyReviewed}">
                <div class="alert alert-info rounded-3 mb-4">
                    <i class="bi bi-check-circle-fill me-2"></i> You have already reviewed this product. Thank you for your feedback!
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-light border rounded-3 text-muted small mb-4">
                    <i class="bi bi-shield-check me-2 text-success"></i> 
                    To protect marketplace authenticity, only verified customers who purchased this product can leave a review.
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Reviews List -->
        <div class="d-flex flex-column gap-3">
            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach var="rev" items="${reviews}">
                        <div class="border-bottom pb-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <div class="d-flex align-items-center gap-2">
                                    <strong class="text-dark">${rev.buyerName}</strong>
                                    <span class="badge bg-success-subtle text-success small"><i class="bi bi-patch-check-fill me-1"></i>Verified Purchase</span>
                                </div>
                                <small class="text-muted">${rev.createdAt}</small>
                            </div>
                            <div class="text-warning small mb-2">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="bi ${i <= rev.rating ? 'bi-star-fill' : 'bi-star'}"></i>
                                </c:forEach>
                            </div>
                            <p class="text-secondary mb-0">${rev.comment}</p>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-muted fst-italic">No reviews yet for this product. Be the first verified buyer to leave feedback!</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="includes/footer.jsp" />

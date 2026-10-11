<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Product Catalog - SmartShop" />
</jsp:include>

<jsp:include page="includes/navbar.jsp" />

<main class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Catalog</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- Filter & Search Sidebar -->
        <div class="col-lg-3">
            <div class="card border-0 shadow-sm rounded-4 p-3 sticky-lg-top" style="top: 80px;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-funnel me-1 text-primary"></i> Filters</h5>
                    <a href="${pageContext.request.contextPath}/products" class="small text-decoration-none text-muted">Clear All</a>
                </div>

                <form action="${pageContext.request.contextPath}/products" method="GET">
                    <!-- Search input -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Search Keyword</label>
                        <input type="text" name="q" class="form-control form-control-sm" placeholder="e.g. Headphones" value="${selectedQuery}">
                    </div>

                    <!-- Category selection -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Category</label>
                        <select name="category" class="form-select form-select-sm">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Price range -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Price Range ($)</label>
                        <div class="d-flex gap-2 align-items-center">
                            <input type="number" step="0.01" name="minPrice" class="form-control form-control-sm" placeholder="Min" value="${selectedMinPrice}">
                            <span class="text-muted">-</span>
                            <input type="number" step="0.01" name="maxPrice" class="form-control form-control-sm" placeholder="Max" value="${selectedMaxPrice}">
                        </div>
                    </div>

                    <!-- Sort -->
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted">Sort By</label>
                        <select name="sort" class="form-select form-select-sm">
                            <option value="newest" ${selectedSort == 'newest' ? 'selected' : ''}>Newest Arrivals</option>
                            <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                            <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                            <option value="rating_desc" ${selectedSort == 'rating_desc' ? 'selected' : ''}>Customer Rating</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 rounded-pill btn-sm fw-bold">
                        Apply Filters
                    </button>
                </form>
            </div>
        </div>

        <!-- Product Listing Grid -->
        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-bold mb-0">Products</h4>
                <span class="text-muted small">Showing <strong>${products.size()}</strong> items</span>
            </div>

            <c:choose>
                <c:when test="${not empty products}">
                    <div class="row g-4">
                        <c:forEach var="prod" items="${products}">
                            <div class="col-md-6 col-xl-4">
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
                                            <span class="text-muted small ms-auto text-truncate" style="max-width: 90px;">
                                                ${prod.sellerName}
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
                </c:when>
                <c:otherwise>
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center">
                        <div class="mb-3 text-muted display-4">
                            <i class="bi bi-search"></i>
                        </div>
                        <h4 class="fw-bold mb-2">No Products Found</h4>
                        <p class="text-muted mb-4">We couldn't find any products matching your filter criteria. Try adjusting your search keyword or price range.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4">Reset All Filters</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="includes/footer.jsp" />

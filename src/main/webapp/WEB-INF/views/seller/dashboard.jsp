<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Seller Hub - SmartShop" />
</jsp:include>

<jsp:include page="../includes/navbar.jsp" />

<main class="container my-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-shop text-success me-2"></i> Seller Hub Dashboard</h2>
            <p class="text-muted small mb-0">Manage your product catalog, monitor inventory, and track incoming buyer orders</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/seller/product?action=new" class="btn btn-success rounded-pill px-4 fw-bold shadow-sm">
                <i class="bi bi-plus-circle me-2"></i> List New Product
            </a>
        </div>
    </div>

    <!-- Inventory Stat Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase">Listed Products</span>
                        <h3 class="fw-bold text-dark mt-1 mb-0">${totalProducts}</h3>
                    </div>
                    <div class="stat-icon bg-primary-subtle text-primary">
                        <i class="bi bi-box-seam"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase">Total Inventory Units</span>
                        <h3 class="fw-bold text-dark mt-1 mb-0">${totalUnits}</h3>
                    </div>
                    <div class="stat-icon bg-info-subtle text-info">
                        <i class="bi bi-stack"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase">Low Stock Alert</span>
                        <h3 class="fw-bold ${lowStockCount > 0 ? 'text-danger' : 'text-success'} mt-1 mb-0">${lowStockCount}</h3>
                    </div>
                    <div class="stat-icon ${lowStockCount > 0 ? 'bg-danger-subtle text-danger' : 'bg-success-subtle text-success'}">
                        <i class="bi bi-exclamation-triangle"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Product Catalog Management Table -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-5">
        <div class="card-header bg-white py-3 px-4 d-flex justify-content-between align-items-center">
            <h5 class="fw-bold mb-0">My Product Listings</h5>
            <span class="badge bg-light text-dark border">${products.size()} Items Listed</span>
        </div>
        <div class="table-responsive">
            <table class="table align-middle mb-0 table-hover">
                <thead class="table-light">
                    <tr>
                        <th scope="col" class="ps-4">Product</th>
                        <th scope="col">Category</th>
                        <th scope="col">Price</th>
                        <th scope="col">Stock</th>
                        <th scope="col">Rating</th>
                        <th scope="col" class="text-end pe-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${p.imageUrl}" alt="${p.name}" class="rounded-3 object-fit-cover" style="width: 52px; height: 52px;">
                                            <div>
                                                <h6 class="mb-0 fw-bold">
                                                    <a href="${pageContext.request.contextPath}/product?id=${p.id}" class="text-dark text-decoration-none" target="_blank">
                                                        ${p.name}
                                                    </a>
                                                </h6>
                                                <small class="text-muted">ID: #${p.id}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-light text-primary border">${p.category}</span></td>
                                    <td class="fw-bold">$<fmt:formatNumber value="${p.price}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.stock > 10}">
                                                <span class="badge bg-success-subtle text-success">${p.stock} in stock</span>
                                            </c:when>
                                            <c:when test="${p.stock > 0}">
                                                <span class="badge bg-warning-subtle text-warning-emphasis">Low: ${p.stock} left</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger-subtle text-danger">Out of stock</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="text-warning small"><i class="bi bi-star-fill"></i> ${p.averageRating}</span>
                                        <span class="text-muted small">(${p.reviewCount})</span>
                                    </td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/seller/product?action=edit&id=${p.id}" class="btn btn-sm btn-outline-primary rounded-pill me-1" title="Edit Product">
                                            <i class="bi bi-pencil-square"></i> Edit
                                        </a>
                                        <a href="${pageContext.request.contextPath}/seller/product?action=delete&id=${p.id}" class="btn btn-sm btn-outline-danger rounded-pill" onclick="return confirm('Are you sure you want to delete product #${p.id}?');" title="Delete Product">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-box-seam display-4 d-block mb-3"></i>
                                    You have not listed any products yet. Click "List New Product" above to begin selling!
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Recent Orders for Seller's Products -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="card-header bg-white py-3 px-4">
            <h5 class="fw-bold mb-0">Recent Orders Containing Your Items</h5>
        </div>
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Order ID</th>
                        <th>Buyer</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Placed At</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td class="ps-4 fw-bold">#${o.id}</td>
                                    <td>
                                        <div class="fw-semibold">${o.buyerName}</div>
                                        <small class="text-muted">${o.buyerEmail}</small>
                                    </td>
                                    <td class="fw-bold text-primary">$<fmt:formatNumber value="${o.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td>
                                        <span class="badge bg-secondary">${o.status}</span>
                                    </td>
                                    <td class="small text-muted">${o.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">No orders received yet.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../includes/footer.jsp" />

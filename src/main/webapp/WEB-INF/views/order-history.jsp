<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="My Orders - SmartShop" />
</jsp:include>

<jsp:include page="includes/navbar.jsp" />

<main class="container my-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-box-seam text-primary me-2"></i> My Order History</h2>
            <p class="text-muted small mb-0">Track shipments, view receipts, and monitor order fulfillment</p>
        </div>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary rounded-pill btn-sm px-3">
            <i class="bi bi-cart me-1"></i> Continue Shopping
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="d-flex flex-column gap-4">
                <c:forEach var="order" items="${orders}">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                        <!-- Order Header -->
                        <div class="card-header bg-light py-3 px-4 d-flex flex-wrap justify-content-between align-items-center gap-2">
                            <div class="d-flex flex-wrap align-items-center gap-3">
                                <div>
                                    <span class="text-muted small d-block">Order Placed</span>
                                    <strong class="small text-dark">${order.createdAt}</strong>
                                </div>
                                <div class="border-start ps-3">
                                    <span class="text-muted small d-block">Total Paid</span>
                                    <strong class="small text-primary">$<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></strong>
                                </div>
                                <div class="border-start ps-3">
                                    <span class="text-muted small d-block">Order #</span>
                                    <strong class="small text-dark">${order.id}</strong>
                                </div>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${order.status == 'DELIVERED'}">
                                        <span class="badge bg-success-subtle text-success fs-6 px-3 py-2 rounded-pill">
                                            <i class="bi bi-check-circle-fill me-1"></i> Delivered
                                        </span>
                                    </c:when>
                                    <c:when test="${order.status == 'SHIPPED'}">
                                        <span class="badge bg-info-subtle text-info-emphasis fs-6 px-3 py-2 rounded-pill">
                                            <i class="bi bi-truck me-1"></i> Shipped
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning-subtle text-warning-emphasis fs-6 px-3 py-2 rounded-pill">
                                            <i class="bi bi-clock-history me-1"></i> Processing
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Order Items List -->
                        <div class="card-body p-4">
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="item" items="${order.items}">
                                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${item.productImageUrl}" alt="${item.productName}" 
                                                 class="rounded-3 object-fit-cover" style="width: 56px; height: 56px;">
                                            <div>
                                                <h6 class="mb-1 fw-bold">
                                                    <a href="${pageContext.request.contextPath}/product?id=${item.productId}" class="text-decoration-none text-dark">
                                                        ${item.productName}
                                                    </a>
                                                </h6>
                                                <small class="text-muted">Quantity: ${item.quantity} &times; $<fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" maxFractionDigits="2" /></small>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <span class="fw-bold text-dark d-block">
                                                $<fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                                            </span>
                                            <a href="${pageContext.request.contextPath}/product?id=${item.productId}" class="btn btn-sm btn-link text-primary p-0 text-decoration-none small">
                                                Leave Review / Buy Again &rarr;
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center">
                <div class="display-3 text-muted mb-3"><i class="bi bi-receipt"></i></div>
                <h4 class="fw-bold mb-2">No Past Orders Found</h4>
                <p class="text-muted mb-4">You haven't placed any orders yet. Discover high quality products in our catalog.</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4">Browse Catalog</a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="includes/footer.jsp" />

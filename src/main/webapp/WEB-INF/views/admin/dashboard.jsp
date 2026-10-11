<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Administrator Control Center - SmartShop" />
</jsp:include>

<jsp:include page="../includes/navbar.jsp" />

<main class="container my-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-shield-lock-fill text-danger me-2"></i> Administrator Dashboard</h2>
            <p class="text-muted small mb-0">Platform overview, user accounts, revenue analytics, and catalog governance</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary rounded-pill btn-sm px-3">
                <i class="bi bi-people me-1"></i> Users
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary rounded-pill btn-sm px-3">
                <i class="bi bi-tags me-1"></i> Catalog
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary rounded-pill btn-sm px-3">
                <i class="bi bi-receipt me-1"></i> Orders
            </a>
        </div>
    </div>

    <!-- Platform KPI Metrics Grid -->
    <div class="row g-4 mb-4">
        <!-- Revenue -->
        <div class="col-xl-3 col-md-6">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase">Total Revenue</span>
                        <h3 class="fw-bold text-success mt-1 mb-0">$<fmt:formatNumber value="${totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2" /></h3>
                    </div>
                    <div class="stat-icon bg-success-subtle text-success">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Orders -->
        <div class="col-xl-3 col-md-6">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase">Total Orders</span>
                        <h3 class="fw-bold text-primary mt-1 mb-0">${totalOrders}</h3>
                    </div>
                    <div class="stat-icon bg-primary-subtle text-primary">
                        <i class="bi bi-cart-check"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Users (Buyers vs Sellers) -->
        <div class="col-xl-3 col-md-6">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase">Registered Users</span>
                        <h3 class="fw-bold text-dark mt-1 mb-0">${totalUsers}</h3>
                        <small class="text-muted">${totalBuyers} Buyers &bull; ${totalSellers} Sellers</small>
                    </div>
                    <div class="stat-icon bg-info-subtle text-info">
                        <i class="bi bi-people-fill"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Catalog Listings -->
        <div class="col-xl-3 col-md-6">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-bold text-uppercase">Catalog Items</span>
                        <h3 class="fw-bold text-warning-emphasis mt-1 mb-0">${totalProducts}</h3>
                    </div>
                    <div class="stat-icon bg-warning-subtle text-warning">
                        <i class="bi bi-box-seam-fill"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Platform Orders Table -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
        <div class="card-header bg-white py-3 px-4 d-flex justify-content-between align-items-center">
            <h5 class="fw-bold mb-0">Recent Platform Transactions</h5>
            <a href="${pageContext.request.contextPath}/admin/orders" class="small text-primary text-decoration-none fw-semibold">
                View All Orders &rarr;
            </a>
        </div>
        <div class="table-responsive">
            <table class="table align-middle mb-0 table-hover">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Order ID</th>
                        <th>Buyer</th>
                        <th>Items Count</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th class="text-end pe-4">Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty recentOrders}">
                            <c:forEach var="ord" items="${recentOrders}">
                                <tr>
                                    <td class="ps-4 fw-bold">#${ord.id}</td>
                                    <td>
                                        <div class="fw-semibold">${ord.buyerName}</div>
                                        <small class="text-muted">${ord.buyerEmail}</small>
                                    </td>
                                    <td>${ord.items.size()} items</td>
                                    <td class="fw-bold text-primary">$<fmt:formatNumber value="${ord.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ord.status == 'DELIVERED'}"><span class="badge bg-success-subtle text-success">Delivered</span></c:when>
                                            <c:when test="${ord.status == 'SHIPPED'}"><span class="badge bg-info-subtle text-info-emphasis">Shipped</span></c:when>
                                            <c:otherwise><span class="badge bg-warning-subtle text-warning-emphasis">Pending</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4 small text-muted">${ord.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">No transactions found.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../includes/footer.jsp" />

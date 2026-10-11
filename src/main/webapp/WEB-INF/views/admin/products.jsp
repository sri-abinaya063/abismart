<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Product Catalog Governance - SmartShop Admin" />
</jsp:include>

<jsp:include page="../includes/navbar.jsp" />

<main class="container my-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-tags-fill text-warning-emphasis me-2"></i> Marketplace Catalog Moderation</h2>
            <p class="text-muted small mb-0">Oversee seller listings, enforce product compliance, and manage platform inventory</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary rounded-pill btn-sm px-3">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table align-middle mb-0 table-hover">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Product ID</th>
                        <th>Listing Details</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Seller</th>
                        <th class="text-end pe-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td class="ps-4 fw-bold">#${p.id}</td>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <img src="${p.imageUrl}" alt="${p.name}" class="rounded-3 object-fit-cover" style="width: 48px; height: 48px;">
                                    <div>
                                        <a href="${pageContext.request.contextPath}/product?id=${p.id}" target="_blank" class="fw-bold text-dark text-decoration-none">
                                            ${p.name}
                                        </a>
                                        <div class="text-warning small">
                                            <i class="bi bi-star-fill"></i> ${p.averageRating} (${p.reviewCount} reviews)
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge bg-light text-primary border">${p.category}</span></td>
                            <td class="fw-bold">$<fmt:formatNumber value="${p.price}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                            <td>
                                <span class="badge ${p.stock > 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}">
                                    ${p.stock} units
                                </span>
                            </td>
                            <td>
                                <span class="fw-semibold text-secondary">${p.sellerName}</span>
                            </td>
                            <td class="text-end pe-4">
                                <a href="${pageContext.request.contextPath}/product?id=${p.id}" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill me-1">
                                    <i class="bi bi-eye"></i> View
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/products" method="POST" class="d-inline">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" 
                                            onclick="return confirm('Remove listing #${p.id} from marketplace for compliance reasons?');">
                                        <i class="bi bi-trash"></i> Remove
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../includes/footer.jsp" />

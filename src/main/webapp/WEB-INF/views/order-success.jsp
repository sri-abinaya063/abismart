<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Order Confirmed! - SmartShop" />
</jsp:include>

<jsp:include page="includes/navbar.jsp" />

<main class="container my-5">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 mx-auto" style="max-width: 760px;">
        <div class="text-center mb-4">
            <div class="rounded-circle bg-success-subtle text-success d-inline-flex align-items-center justify-content-center p-4 mb-3" style="width: 80px; height: 80px;">
                <i class="bi bi-check2-circle display-4"></i>
            </div>
            <h2 class="fw-bold text-dark">Thank You For Your Order!</h2>
            <p class="text-muted">Your order has been placed and is currently being processed by our seller network.</p>
            <span class="badge bg-primary fs-6 px-3 py-2 rounded-pill">Order Reference #${order.id}</span>
        </div>

        <div class="card bg-light border-0 rounded-3 p-4 mb-4">
            <div class="row g-3 small">
                <div class="col-sm-6">
                    <span class="text-muted d-block">Order Date:</span>
                    <strong>${order.createdAt}</strong>
                </div>
                <div class="col-sm-6 text-sm-end">
                    <span class="text-muted d-block">Fulfillment Status:</span>
                    <span class="badge bg-warning text-dark">${order.status}</span>
                </div>
            </div>
        </div>

        <h5 class="fw-bold mb-3">Itemized Order Summary</h5>
        <div class="table-responsive mb-4">
            <table class="table align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Item</th>
                        <th class="text-center">Qty</th>
                        <th class="text-end">Price</th>
                        <th class="text-end">Total</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.items}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <img src="${item.productImageUrl}" class="rounded-2 object-fit-cover" style="width: 40px; height: 40px;" alt="">
                                    <span class="fw-semibold small">${item.productName}</span>
                                </div>
                            </td>
                            <td class="text-center small">${item.quantity}</td>
                            <td class="text-end small">$<fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                            <td class="text-end fw-bold small">$<fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                        </tr>
                    </c:forEach>
                    <tr class="table-light">
                        <td colspan="3" class="fw-bold text-end">Total Paid:</td>
                        <td class="text-end fw-bold text-primary fs-6">
                            $<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="d-flex flex-wrap gap-3 justify-content-center">
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-primary rounded-pill px-4">
                <i class="bi bi-box-seam me-2"></i> View Order History
            </a>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4 fw-bold">
                Continue Shopping <i class="bi bi-arrow-right ms-2"></i>
            </a>
        </div>
    </div>
</main>

<jsp:include page="includes/footer.jsp" />

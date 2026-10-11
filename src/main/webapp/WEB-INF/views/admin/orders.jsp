<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="Platform Orders Fulfillment - SmartShop Admin" />
</jsp:include>

<jsp:include page="../includes/navbar.jsp" />

<main class="container my-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-receipt text-success me-2"></i> Order Fulfillment Operations</h2>
            <p class="text-muted small mb-0">Track platform-wide order lifecycle states and trigger shipping status updates</p>
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
                        <th class="ps-4">Order ID</th>
                        <th>Buyer Information</th>
                        <th>Purchased Items</th>
                        <th>Total Paid</th>
                        <th>Placement Date</th>
                        <th>Fulfillment Status</th>
                        <th class="text-end pe-4">Update Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ord" items="${orders}">
                        <tr>
                            <td class="ps-4 fw-bold">#${ord.id}</td>
                            <td>
                                <div class="fw-semibold">${ord.buyerName}</div>
                                <small class="text-muted">${ord.buyerEmail}</small>
                            </td>
                            <td>
                                <ul class="list-unstyled mb-0 small">
                                    <c:forEach var="item" items="${ord.items}">
                                        <li>• ${item.productName} (x${item.quantity})</li>
                                    </c:forEach>
                                </ul>
                            </td>
                            <td class="fw-bold text-primary">
                                $<fmt:formatNumber value="${ord.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                            </td>
                            <td class="small text-muted">${ord.createdAt}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${ord.status == 'DELIVERED'}"><span class="badge bg-success-subtle text-success">DELIVERED</span></c:when>
                                    <c:when test="${ord.status == 'SHIPPED'}"><span class="badge bg-info-subtle text-info-emphasis">SHIPPED</span></c:when>
                                    <c:otherwise><span class="badge bg-warning-subtle text-warning-emphasis">PENDING</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end pe-4">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="d-flex align-items-center justify-content-end gap-2 m-0">
                                    <input type="hidden" name="orderId" value="${ord.id}">
                                    <select name="status" class="form-select form-select-sm" style="width: 130px;">
                                        <option value="PENDING" ${ord.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                        <option value="SHIPPED" ${ord.status == 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                                        <option value="DELIVERED" ${ord.status == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-outline-primary">Update</button>
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

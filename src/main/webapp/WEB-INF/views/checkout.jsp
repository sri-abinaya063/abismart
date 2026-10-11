<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Secure Checkout - SmartShop" />
</jsp:include>

<jsp:include page="includes/navbar.jsp" />

<main class="container my-4">
    <h2 class="fw-bold mb-4"><i class="bi bi-shield-check text-success me-2"></i> Express Checkout</h2>

    <form action="${pageContext.request.contextPath}/checkout" method="POST">
        <div class="row g-4">
            <!-- Checkout Form Details -->
            <div class="col-lg-7">
                <!-- Shipping Details -->
                <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-geo-alt-fill text-primary me-2"></i> Shipping Address</h5>
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Full Recipient Name</label>
                            <input type="text" class="form-control" name="fullName" value="${sessionScope.loggedUser.fullName}" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Street Address</label>
                            <input type="text" class="form-control" name="address" placeholder="123 Innovation Way, Suite 400" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">City</label>
                            <input type="text" class="form-control" name="city" placeholder="San Francisco" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-bold text-muted">State</label>
                            <input type="text" class="form-control" name="state" placeholder="CA" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-bold text-muted">ZIP / Postal</label>
                            <input type="text" class="form-control" name="zip" placeholder="94105" required>
                        </div>
                    </div>
                </div>

                <!-- Payment Details -->
                <div class="card border-0 shadow-sm rounded-4 p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-credit-card-2-front-fill text-primary me-2"></i> Payment Method</h5>
                    
                    <div class="form-check p-3 border rounded-3 mb-2 bg-light">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="payCard" value="CARD" checked>
                        <label class="form-check-label fw-semibold" for="payCard">
                            Credit / Debit Card (Visa, MasterCard, Amex)
                        </label>
                    </div>

                    <div class="form-check p-3 border rounded-3 mb-2">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="payUPI" value="UPI">
                        <label class="form-check-label fw-semibold" for="payUPI">
                            Instant UPI / Net Banking Transfer
                        </label>
                    </div>

                    <div class="form-check p-3 border rounded-3 mb-4">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="payCOD" value="COD">
                        <label class="form-check-label fw-semibold" for="payCOD">
                            Cash on Delivery (Pay upon receipt)
                        </label>
                    </div>

                    <div class="alert alert-secondary small d-flex align-items-center gap-2 mb-0">
                        <i class="bi bi-lock-fill text-dark fs-5"></i>
                        <span>Transactions are processed via end-to-end encrypted gateways with simulated instantaneous authorization for testing.</span>
                    </div>
                </div>
            </div>

            <!-- Order Summary Sidebar -->
            <div class="col-lg-5">
                <div class="card border-0 shadow-sm rounded-4 p-4 sticky-lg-top" style="top: 80px;">
                    <h5 class="fw-bold mb-3">Order Items (${cartItems.size()})</h5>

                    <div class="d-flex flex-column gap-3 mb-3 overflow-auto" style="max-height: 280px;">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center gap-2">
                                    <img src="${item.productImageUrl}" alt="${item.productName}" 
                                         class="rounded-2 object-fit-cover" style="width: 44px; height: 44px;">
                                    <div>
                                        <h6 class="mb-0 small fw-bold text-truncate" style="max-width: 170px;">${item.productName}</h6>
                                        <small class="text-muted">Qty: ${item.quantity} &times; $<fmt:formatNumber value="${item.productPrice}" type="number" minFractionDigits="2" maxFractionDigits="2" /></small>
                                    </div>
                                </div>
                                <span class="fw-semibold small">$<fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                            </div>
                        </c:forEach>
                    </div>

                    <hr class="my-2">

                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">Subtotal</span>
                        <span>$<fmt:formatNumber value="${subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                    </div>

                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">Shipping</span>
                        <span>
                            <c:choose>
                                <c:when test="${shipping == 0.0}"><span class="badge bg-success-subtle text-success">FREE</span></c:when>
                                <c:otherwise>$<fmt:formatNumber value="${shipping}" type="number" minFractionDigits="2" maxFractionDigits="2" /></c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="d-flex justify-content-between mb-3 small">
                        <span class="text-muted">Estimated Tax (8%)</span>
                        <span>$<fmt:formatNumber value="${tax}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                    </div>

                    <div class="d-flex justify-content-between mb-4 pt-2 border-top">
                        <span class="fs-5 fw-bold">Order Total</span>
                        <span class="fs-4 fw-bold text-primary">$<fmt:formatNumber value="${grandTotal}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                    </div>

                    <button type="submit" class="btn btn-success btn-lg rounded-pill w-100 fw-bold shadow">
                        <i class="bi bi-lock-fill me-2"></i> Confirm & Place Order
                    </button>

                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/cart" class="small text-muted text-decoration-none">
                            <i class="bi bi-arrow-left me-1"></i> Return to Shopping Cart
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</main>

<jsp:include page="includes/footer.jsp" />

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Shopping Cart - SmartShop" />
</jsp:include>

<jsp:include page="includes/navbar.jsp" />

<main class="container my-4">
    <h2 class="fw-bold mb-4"><i class="bi bi-cart3 text-primary me-2"></i> Shopping Cart</h2>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="row g-4">
                <!-- Cart Items Table -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col" class="ps-4">Product</th>
                                        <th scope="col">Price</th>
                                        <th scope="col" style="width: 140px;">Quantity</th>
                                        <th scope="col">Subtotal</th>
                                        <th scope="col" class="text-end pe-4">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cartItems}">
                                        <tr>
                                            <td class="ps-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <img src="${item.productImageUrl}" alt="${item.productName}" 
                                                         class="rounded-3 object-fit-cover" style="width: 64px; height: 64px;">
                                                    <div>
                                                        <h6 class="mb-1">
                                                            <a href="${pageContext.request.contextPath}/product?id=${item.productId}" class="text-decoration-none text-dark fw-bold">
                                                                ${item.productName}
                                                            </a>
                                                        </h6>
                                                        <span class="badge bg-light text-muted border">${item.productCategory}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="fw-semibold">
                                                $<fmt:formatNumber value="${item.productPrice}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/cart" method="POST" class="auto-update-form m-0">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="cartId" value="${item.id}">
                                                    <div class="input-group input-group-sm">
                                                        <button class="btn btn-outline-secondary btn-quantity-decrease" type="button">-</button>
                                                        <input type="number" name="quantity" class="form-control text-center quantity-input" 
                                                               value="${item.quantity}" min="1" max="${item.stockAvailable}" required>
                                                        <button class="btn btn-outline-secondary btn-quantity-increase" type="button">+</button>
                                                    </div>
                                                </form>
                                            </td>
                                            <td class="fw-bold text-primary">
                                                $<fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                                            </td>
                                            <td class="text-end pe-4">
                                                <form action="${pageContext.request.contextPath}/cart" method="POST" class="d-inline">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="cartId" value="${item.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger border-0 rounded-circle" title="Remove Item">
                                                        <i class="bi bi-trash3-fill"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary rounded-pill px-4">
                            <i class="bi bi-arrow-left me-2"></i> Continue Shopping
                        </a>
                    </div>
                </div>

                <!-- Order Summary Card -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 sticky-lg-top" style="top: 80px;">
                        <h5 class="fw-bold mb-4">Order Summary</h5>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Subtotal</span>
                            <span class="fw-semibold">$<fmt:formatNumber value="${subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Estimated Shipping</span>
                            <span>
                                <c:choose>
                                    <c:when test="${shipping == 0.0}">
                                        <span class="badge bg-success-subtle text-success">FREE</span>
                                    </c:when>
                                    <c:otherwise>
                                        $<fmt:formatNumber value="${shipping}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-muted">Estimated Tax (8%)</span>
                            <span class="fw-semibold">$<fmt:formatNumber value="${tax}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                        </div>

                        <c:if test="${subtotal < 50.0 && subtotal > 0}">
                            <div class="alert alert-warning py-2 small mb-3">
                                <i class="bi bi-info-circle me-1"></i> Add <strong>$<fmt:formatNumber value="${50.0 - subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2" /></strong> more to get <strong>FREE SHIPPING</strong>!
                            </div>
                        </c:if>

                        <hr class="my-3">

                        <div class="d-flex justify-content-between mb-4">
                            <span class="fs-5 fw-bold">Total</span>
                            <span class="fs-4 fw-bold text-primary">$<fmt:formatNumber value="${grandTotal}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                        </div>

                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg rounded-pill w-100 fw-bold">
                            Proceed to Checkout <i class="bi bi-arrow-right ms-2"></i>
                        </a>

                        <div class="d-flex justify-content-center gap-3 text-muted mt-3 small">
                            <span><i class="bi bi-shield-lock me-1"></i> SSL Encrypted</span>
                            <span>&bull;</span>
                            <span><i class="bi bi-arrow-counterclockwise me-1"></i> 30-Day Returns</span>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center my-4">
                <div class="display-3 text-muted mb-3">
                    <i class="bi bi-cart-x"></i>
                </div>
                <h3 class="fw-bold mb-2">Your Shopping Cart is Empty</h3>
                <p class="text-muted mb-4">Looks like you haven't added anything to your cart yet. Explore our featured products and discover great deals.</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg rounded-pill px-5 fw-bold">
                        Browse Products
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="includes/footer.jsp" />

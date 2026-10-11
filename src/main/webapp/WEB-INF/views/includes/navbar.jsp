<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="sticky-top bg-white border-bottom shadow-sm">
    <nav class="navbar navbar-expand-lg navbar-light py-2">
        <div class="container">
            <!-- Brand Logo -->
            <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
                <i class="bi bi-bag-check-fill text-primary fs-3"></i>
                <span>SmartShop</span>
            </a>

            <!-- Navbar Toggler for Mobile -->
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent"
                    aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Nav Content -->
            <div class="collapse navbar-collapse" id="navbarContent">
                <!-- Search Bar -->
                <form class="d-flex mx-lg-4 my-2 my-lg-0 flex-grow-1" action="${pageContext.request.contextPath}/products" method="GET" style="max-width: 500px;">
                    <div class="input-group">
                        <input class="form-control border-end-0 rounded-start-pill ps-3 bg-light" type="search" name="q" 
                               placeholder="Search laptops, headphones, fashion..." value="${selectedQuery}" aria-label="Search">
                        <button class="btn btn-outline-secondary border-start-0 rounded-end-pill pe-3 bg-light text-muted" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>

                <!-- Navigation Links -->
                <ul class="navbar-nav ms-auto align-items-lg-center gap-2">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">
                            <i class="bi bi-grid me-1"></i> Catalog
                        </a>
                    </li>

                    <c:choose>
                        <%-- When user is logged in --%>
                        <c:when test="${not empty sessionScope.loggedUser}">
                            <%-- Admin Links --%>
                            <c:if test="${sessionScope.loggedUser.admin}">
                                <li class="nav-item">
                                    <a class="nav-link text-danger fw-semibold" href="${pageContext.request.contextPath}/admin/dashboard">
                                        <i class="bi bi-shield-lock-fill me-1"></i> Admin Panel
                                    </a>
                                </li>
                            </c:if>

                            <%-- Seller Links --%>
                            <c:if test="${sessionScope.loggedUser.seller}">
                                <li class="nav-item">
                                    <a class="nav-link text-success fw-semibold" href="${pageContext.request.contextPath}/seller/dashboard">
                                        <i class="bi bi-shop me-1"></i> Seller Hub
                                    </a>
                                </li>
                            </c:if>

                            <%-- Buyer Cart & Orders --%>
                            <c:if test="${sessionScope.loggedUser.buyer}">
                                <li class="nav-item">
                                    <a class="nav-link position-relative pe-3" href="${pageContext.request.contextPath}/cart">
                                        <i class="bi bi-cart3 fs-5"></i>
                                        <span class="position-absolute top-1 start-100 translate-middle badge rounded-pill bg-primary" id="navbarCartBadge">
                                            ${sessionScope.cartCount != null ? sessionScope.cartCount : 0}
                                        </span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/orders">
                                        <i class="bi bi-receipt me-1"></i> My Orders
                                    </a>
                                </li>
                            </c:if>

                            <!-- User Account Dropdown -->
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 0.85rem; font-weight: 700;">
                                        ${sessionScope.loggedUser.fullName.substring(0, 1).toUpperCase()}
                                    </div>
                                    <span class="fw-semibold text-truncate" style="max-width: 120px;">${sessionScope.loggedUser.fullName}</span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow border-0" aria-labelledby="userDropdown">
                                    <li class="dropdown-header text-uppercase small fw-bold text-muted">
                                        Role: <span class="badge bg-secondary">${sessionScope.loggedUser.role}</span>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <c:if test="${sessionScope.loggedUser.buyer}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders"><i class="bi bi-box-seam me-2"></i>My Orders</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/cart"><i class="bi bi-cart me-2"></i>Cart</a></li>
                                    </c:if>
                                    <c:if test="${sessionScope.loggedUser.seller}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/seller/dashboard"><i class="bi bi-speedometer2 me-2"></i>Seller Dashboard</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/seller/product?action=new"><i class="bi bi-plus-circle me-2"></i>Add Product</a></li>
                                    </c:if>
                                    <c:if test="${sessionScope.loggedUser.admin}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer me-2"></i>Dashboard</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2"></i>Manage Users</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-tags me-2"></i>Manage Catalog</a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                            <i class="bi bi-box-arrow-right me-2"></i>Log Out
                                        </a>
                                    </li>
                                </ul>
                            </li>
                        </c:when>

                        <%-- Guest User --%>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">Sign In</a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-primary rounded-pill px-3" href="${pageContext.request.contextPath}/register">Get Started</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>
</header>

<!-- Global Flash Message Notifications -->
<div class="container mt-3">
    <c:if test="${not empty sessionScope.flashSuccess}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.flashSuccess}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashSuccess" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.flashError}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.flashError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashError" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.authMessage}">
        <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-shield-lock-fill me-2"></i> ${sessionScope.authMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="authMessage" scope="session" />
    </c:if>
</div>

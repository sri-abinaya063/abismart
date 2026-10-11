<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Sign In - SmartShop" />
</jsp:include>

<jsp:include page="includes/navbar.jsp" />

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-5">
            <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center p-3 mb-2">
                        <i class="bi bi-person-fill-lock fs-2"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Welcome Back</h3>
                    <p class="text-muted small">Sign in to your SmartShop account</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-2"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <input type="hidden" name="redirectUrl" value="${redirectUrl}">

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                            <input type="email" class="form-control border-start-0 ps-0 bg-light" name="email" id="loginEmail" 
                                   value="${email}" placeholder="name@example.com" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <label class="form-label small fw-bold text-muted mb-0">Password</label>
                        </div>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-lock text-muted"></i></span>
                            <input type="password" class="form-control border-start-0 ps-0 bg-light" name="password" id="loginPassword" 
                                   placeholder="••••••••" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-bold mt-2 shadow-sm">
                        Sign In
                    </button>
                </form>

                <!-- Quick Demo Login Helpers for Testing -->
                <div class="card bg-light border-0 rounded-3 p-3 mt-4">
                    <span class="small fw-bold text-secondary d-block mb-2 text-center">⚡ Capstone One-Click Demo Credentials:</span>
                    <div class="d-flex flex-wrap gap-2 justify-content-center">
                        <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-2" onclick="setDemo('admin@smartshop.com', 'password123')">
                            Admin
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-success rounded-pill px-2" onclick="setDemo('seller.tech@smartshop.com', 'password123')">
                            Seller
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-2" onclick="setDemo('alice@buyer.com', 'password123')">
                            Buyer
                        </button>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <span class="small text-muted">Don't have an account? </span>
                    <a href="${pageContext.request.contextPath}/register" class="small fw-bold text-primary text-decoration-none">
                        Create Account
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    function setDemo(email, pass) {
        document.getElementById('loginEmail').value = email;
        document.getElementById('loginPassword').value = pass;
    }
</script>

<jsp:include page="includes/footer.jsp" />

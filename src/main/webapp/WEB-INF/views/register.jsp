<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Create Account - SmartShop" />
</jsp:include>

<jsp:include page="includes/navbar.jsp" />

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center p-3 mb-2">
                        <i class="bi bi-person-plus-fill fs-2"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Join SmartShop</h3>
                    <p class="text-muted small">Register as a Buyer or Seller on our marketplace</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-2"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="POST">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Full Legal Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-person text-muted"></i></span>
                            <input type="text" class="form-control border-start-0 ps-0 bg-light" name="fullName" 
                                   value="${fullName}" placeholder="John Doe" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                            <input type="email" class="form-control border-start-0 ps-0 bg-light" name="email" 
                                   value="${email}" placeholder="name@example.com" required>
                        </div>
                    </div>

                    <!-- Role Choice -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted d-block">Account Type</label>
                        <div class="row g-2">
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="role" id="roleBuyer" value="buyer" ${role != 'seller' ? 'checked' : ''}>
                                <label class="btn btn-outline-primary w-100 py-2 rounded-3 text-start" for="roleBuyer">
                                    <div class="fw-bold small"><i class="bi bi-bag me-1"></i> Buyer</div>
                                    <small class="text-muted" style="font-size: 0.75rem;">Shop & review</small>
                                </label>
                            </div>
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="role" id="roleSeller" value="seller" ${role == 'seller' ? 'checked' : ''}>
                                <label class="btn btn-outline-success w-100 py-2 rounded-3 text-start" for="roleSeller">
                                    <div class="fw-bold small"><i class="bi bi-shop me-1"></i> Seller</div>
                                    <small class="text-muted" style="font-size: 0.75rem;">List & sell products</small>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Password</label>
                            <input type="password" class="form-control bg-light" name="password" placeholder="Min 6 characters" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Confirm Password</label>
                            <input type="password" class="form-control bg-light" name="confirmPassword" placeholder="Repeat password" required>
                        </div>
                    </div>

                    <div class="form-check mb-4">
                        <input class="form-check-input" type="checkbox" id="termsCheck" required checked>
                        <label class="form-check-label small text-muted" for="termsCheck">
                            I agree to the SmartShop Terms of Service and Privacy Policy
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-bold shadow-sm">
                        Create Account
                    </button>
                </form>

                <div class="text-center mt-4">
                    <span class="small text-muted">Already have an account? </span>
                    <a href="${pageContext.request.contextPath}/login" class="small fw-bold text-primary text-decoration-none">
                        Sign In
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="includes/footer.jsp" />

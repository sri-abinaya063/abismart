<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="403 - Forbidden Access" />
</jsp:include>

<jsp:include page="../includes/navbar.jsp" />

<main class="container my-5 text-center">
    <div class="card border-0 shadow-sm rounded-4 p-5 mx-auto" style="max-width: 600px;">
        <div class="display-1 fw-extrabold text-danger mb-3"><i class="bi bi-shield-x"></i></div>
        <h3 class="fw-bold mb-2">Access Denied (403 Forbidden)</h3>
        <p class="text-muted mb-4">You do not have the required role privileges (Seller or Administrator) to access this protected resource.</p>
        <div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary rounded-pill px-4">
                <i class="bi bi-house me-2"></i> Return to Marketplace
            </a>
        </div>
    </div>
</main>

<jsp:include page="../includes/footer.jsp" />

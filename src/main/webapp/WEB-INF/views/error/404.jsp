<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="404 - Page Not Found" />
</jsp:include>

<jsp:include page="../includes/navbar.jsp" />

<main class="container my-5 text-center">
    <div class="card border-0 shadow-sm rounded-4 p-5 mx-auto" style="max-width: 600px;">
        <div class="display-1 fw-extrabold text-primary mb-3">404</div>
        <h3 class="fw-bold mb-2">Oops! Page Not Found</h3>
        <p class="text-muted mb-4">The page or product you were looking for doesn't exist or may have been moved.</p>
        <div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary rounded-pill px-4">
                <i class="bi bi-house me-2"></i> Return to Home
            </a>
        </div>
    </div>
</main>

<jsp:include page="../includes/footer.jsp" />

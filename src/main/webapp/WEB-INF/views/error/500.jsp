<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="500 - Server Error" />
</jsp:include>

<jsp:include page="../includes/navbar.jsp" />

<main class="container my-5 text-center">
    <div class="card border-0 shadow-sm rounded-4 p-5 mx-auto" style="max-width: 600px;">
        <div class="display-1 fw-extrabold text-warning mb-3">500</div>
        <h3 class="fw-bold mb-2">Internal Server Error</h3>
        <p class="text-muted mb-4">Something unexpected went wrong on our end. Our engineering team has been alerted.</p>
        <div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary rounded-pill px-4">
                <i class="bi bi-house me-2"></i> Return to Safety
            </a>
        </div>
    </div>
</main>

<jsp:include page="../includes/footer.jsp" />

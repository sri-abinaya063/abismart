<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="User Account Governance - SmartShop Admin" />
</jsp:include>

<jsp:include page="../includes/navbar.jsp" />

<main class="container my-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-people-fill text-primary me-2"></i> User Account Management</h2>
            <p class="text-muted small mb-0">Inspect user accounts, assign authorization privileges, or revoke access</p>
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
                        <th class="ps-4">User ID</th>
                        <th>User Name</th>
                        <th>Email Address</th>
                        <th>Current Role</th>
                        <th>Change Role</th>
                        <th>Registered Date</th>
                        <th class="text-end pe-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td class="ps-4 fw-bold">#${u.id}</td>
                            <td class="fw-semibold">${u.fullName}</td>
                            <td>${u.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.role == 'admin'}"><span class="badge bg-danger">ADMIN</span></c:when>
                                    <c:when test="${u.role == 'seller'}"><span class="badge bg-success">SELLER</span></c:when>
                                    <c:otherwise><span class="badge bg-primary">BUYER</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="d-flex align-items-center gap-2 m-0">
                                    <input type="hidden" name="action" value="updateRole">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <select name="role" class="form-select form-select-sm" style="width: 110px;">
                                        <option value="buyer" ${u.role == 'buyer' ? 'selected' : ''}>Buyer</option>
                                        <option value="seller" ${u.role == 'seller' ? 'selected' : ''}>Seller</option>
                                        <option value="admin" ${u.role == 'admin' ? 'selected' : ''}>Admin</option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-outline-secondary">Save</button>
                                </form>
                            </td>
                            <td class="small text-muted">${u.createdAt}</td>
                            <td class="text-end pe-4">
                                <c:choose>
                                    <c:when test="${u.id == sessionScope.loggedUser.id}">
                                        <span class="badge bg-light text-muted border">Current User</span>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" 
                                                    onclick="return confirm('Are you sure you want to permanently remove user #${u.id} (${u.email})?');">
                                                <i class="bi bi-trash"></i> Delete
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../includes/footer.jsp" />

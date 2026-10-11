<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="${isEdit ? 'Edit Product' : 'Add New Product'} - SmartShop" />
</jsp:include>

<jsp:include page="../includes/navbar.jsp" />

<main class="container my-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold mb-1">${isEdit ? 'Edit Product Listing' : 'Create New Product Listing'}</h3>
                        <p class="text-muted small mb-0">Fill in the details below to list your item in the marketplace catalog</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn btn-outline-secondary rounded-pill btn-sm px-3">
                        <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
                    </a>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/seller/product" method="POST">
                    <input type="hidden" name="id" value="${product.id}">

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Product Name</label>
                        <input type="text" name="name" class="form-control" value="${product.name}" 
                               placeholder="e.g. Wireless Noise-Cancelling Headphones" required>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Category</label>
                            <input type="text" name="category" class="form-control" list="categoryOptions" 
                                   value="${product.category}" placeholder="Select or type category" required>
                            <datalist id="categoryOptions">
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat}">
                                </c:forEach>
                                <option value="Electronics">
                                <option value="Fashion">
                                <option value="Home">
                                <option value="Sports">
                                <option value="Books">
                                <option value="Beauty">
                            </datalist>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-bold text-muted">Price ($ USD)</label>
                            <input type="number" step="0.01" min="0.01" name="price" class="form-control" 
                                   value="${product.price}" placeholder="49.99" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-bold text-muted">Stock Inventory</label>
                            <input type="number" min="0" name="stock" class="form-control" 
                                   value="${product.stock}" placeholder="50" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Image URL (Web or Unsplash Link)</label>
                        <input type="url" name="imageUrl" id="imageUrlInput" class="form-control" 
                               value="${product.imageUrl}" placeholder="https://images.unsplash.com/..." 
                               oninput="document.getElementById('imagePreview').src = this.value">
                        <small class="text-muted">Enter a direct image URL to show in the catalog.</small>
                    </div>

                    <!-- Live Image Preview -->
                    <div class="mb-3 text-center p-3 bg-light rounded-3 border">
                        <span class="small text-muted d-block mb-2">Image Preview:</span>
                        <img id="imagePreview" src="${not empty product.imageUrl ? product.imageUrl : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80'}" 
                             alt="Preview" class="rounded-3 shadow-sm object-fit-cover" style="max-height: 180px; max-width: 100%;">
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted">Product Description</label>
                        <textarea name="description" class="form-control" rows="5" 
                                  placeholder="Provide detailed specifications, features, dimensions, warranty..." required>${product.description}</textarea>
                    </div>

                    <div class="d-flex gap-3">
                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold flex-grow-1">
                            ${isEdit ? 'Update Product' : 'Publish Product Listing'}
                        </button>
                        <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn btn-outline-secondary rounded-pill px-4">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../includes/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>HotWheelsNepal - Add Product</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<header>
    <h1>HotWheelsNepal <span class="admin-tag">ADMIN</span></h1>
    <nav>
        <a href="${pageContext.request.contextPath}/AdminDashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/AdminProducts" class="active">Products</a>
        <a href="${pageContext.request.contextPath}/AdminUsers">Users</a>
        <a href="${pageContext.request.contextPath}/Home">View Site</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </nav>
</header>

<div class="admin-wrapper">
    <aside class="sidebar">
        <div class="admin-profile">
            <div class="avatar">A</div>
            <div>
                <div class="admin-name"><%= session.getAttribute("username") %></div>
                <div class="admin-role">Administrator</div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/AdminDashboard" class="nav-item">Dashboard</a>
            <a href="${pageContext.request.contextPath}/AdminProducts" class="nav-item">Manage Products</a>
            <a href="${pageContext.request.contextPath}/AddProduct" class="nav-item active">Add Product</a>
            <a href="${pageContext.request.contextPath}/AdminUsers" class="nav-item">Manage Users</a>
            <a href="${pageContext.request.contextPath}/Home" class="nav-item">View Site</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout">Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-heading">
            <h2>Add New Product</h2>
            <a href="${pageContext.request.contextPath}/AdminProducts" class="btn-back">&larr; Back to Products</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        </c:if>

        <div class="section-card">
            <div class="section-header"><h3>Product Details</h3></div>
            <div class="form-body">
                <form action="${pageContext.request.contextPath}/AddProduct" method="post" enctype="multipart/form-data">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Product Name *</label>
                            <input type="text" name="name" placeholder="e.g. Bone Shaker" required
                                   value="<%= request.getAttribute("valName") != null ? request.getAttribute("valName") : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Series</label>
                            <input type="text" name="series" placeholder="e.g. Treasure Hunt"
                                   value="<%= request.getAttribute("valSeries") != null ? request.getAttribute("valSeries") : "" %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Description *</label>
                        <textarea name="description" rows="3" placeholder="Describe the product..." required><%= request.getAttribute("valDescription") != null ? request.getAttribute("valDescription") : "" %></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Price (NPR) *</label>
                            <input type="number" name="price" placeholder="0.00" step="0.01" min="0" required
                                   value="<%= request.getAttribute("valPrice") != null ? request.getAttribute("valPrice") : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Stock Quantity *</label>
                            <input type="number" name="stock" placeholder="0" min="0" required
                                   value="<%= request.getAttribute("valStock") != null ? request.getAttribute("valStock") : "" %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Product Image</label>
                        <label class="file-pill-wrap" id="uploadZone">
                            <input type="file" name="productImage" accept="image/*" id="productImageInput">
                            <span class="file-pill-btn">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                    <polyline points="17 8 12 3 7 8"/>
                                    <line x1="12" y1="3" x2="12" y2="15"/>
                                </svg>
                                Choose File
                            </span>
                            <span class="file-pill-name" id="chosenFileName">No file chosen</span>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">Add Product</button>
                        <a href="${pageContext.request.contextPath}/AdminProducts" class="btn-cancel">Cancel</a>
                    </div>
                </form>
                <script>
                (function () {
                    var input    = document.getElementById('productImageInput');
                    var nameSpan = document.getElementById('chosenFileName');
                    input.addEventListener('change', function () {
                        if (input.files && input.files[0]) {
                            nameSpan.textContent = input.files[0].name;
                            nameSpan.classList.add('has-file');
                        }
                    });
                })();
                </script>
            </div>
        </div>
    </main>
</div>

<footer><p>&copy; 2026 HotWheelsNepal Admin Panel</p></footer>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" import="com.hotwheelsnepal.model.ProductModel" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>HotWheels Nepal | Edit Product</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>
<body>

<header>
    <h1>HotWheelsNepal <span class="admin-tag">ADMIN</span></h1>
    <nav>
        <a href="<%= request.getContextPath() %>/AdminDashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/AdminProducts" class="active">Products</a>
        <a href="<%= request.getContextPath() %>/AdminUsers">Users</a>
        <a href="<%= request.getContextPath() %>/Home">View Site</a>
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
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
            <a href="<%= request.getContextPath() %>/AdminDashboard" class="nav-item">Dashboard</a>
            <a href="<%= request.getContextPath() %>/AdminProducts" class="nav-item active">Manage Products</a>
            <a href="<%= request.getContextPath() %>/AddProduct" class="nav-item">Add Product</a>
            <a href="<%= request.getContextPath() %>/AdminUsers" class="nav-item">Manage Users</a>
            <a href="<%= request.getContextPath() %>/Home" class="nav-item">View Site</a>
            <a href="<%= request.getContextPath() %>/logout" class="nav-item logout">Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-heading">
            <h2>Edit Product</h2>
            <a href="<%= request.getContextPath() %>/AdminProducts" class="btn-back">&larr; Back</a>
        </div>

        <c:choose>
            <c:when test="${empty product}">
                <div class="alert alert-error">Product not found.</div>
            </c:when>
            <c:otherwise>
        <div class="section-card">
            <div class="section-header"><h3>Editing: <%= ((ProductModel)request.getAttribute("product")).getName() %></h3></div>
            <div class="form-body">
                <form action="<%= request.getContextPath() %>/EditProduct" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="productId" value="<%= ((ProductModel)request.getAttribute("product")).getProductId() %>">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Product Name *</label>
                            <input type="text" name="name" required value="<%= ((ProductModel)request.getAttribute("product")).getName() %>">
                        </div>
                        <div class="form-group">
                            <label>Series</label>
                            <input type="text" name="series" value="<%= ((ProductModel)request.getAttribute("product")).getSeries() != null ? ((ProductModel)request.getAttribute("product")).getSeries() : "" %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Description *</label>
                        <textarea name="description" rows="3" required><%= ((ProductModel)request.getAttribute("product")).getDescription() != null ? ((ProductModel)request.getAttribute("product")).getDescription() : "" %></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Price (NPR) *</label>
                            <input type="number" name="price" step="0.01" min="0" required value="<%= ((ProductModel)request.getAttribute("product")).getPrice() %>">
                        </div>
                        <div class="form-group">
                            <label>Stock Quantity *</label>
                            <input type="number" name="stock" min="0" required value="<%= ((ProductModel)request.getAttribute("product")).getStock() %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Product Image <span style="color:#555;font-weight:400;text-transform:none;letter-spacing:0;">(leave blank to keep current)</span></label>

                        <%-- Current image preview --%>
                        <% String currentImage = ((ProductModel)request.getAttribute("product")).getImageName(); %>
                        <% if (currentImage != null && !currentImage.isEmpty()) { %>
                        <div style="margin-bottom:0.9rem;display:flex;align-items:center;gap:1rem;">
                            <img id="imgPreview"
                                 src="<%= request.getContextPath() %>/images/products/<%= currentImage %>"
                                 alt="Current product image"
                                 style="width:80px;height:80px;border-radius:8px;border:1px solid #2a0000;object-fit:contain;background:#0d0d0d;padding:4px;">
                            <div>
                                <div style="font-size:0.7rem;text-transform:uppercase;letter-spacing:0.08em;color:#555;font-weight:700;">Current Image</div>
                                <div style="font-size:0.78rem;color:#888;margin-top:3px;word-break:break-all;"><%= currentImage %></div>
                            </div>
                        </div>
                        <% } else { %>
                        <div style="margin-bottom:0.9rem;display:none;" id="previewWrap">
                            <img id="imgPreview" src="" alt=""
                                 style="width:80px;height:80px;border-radius:8px;border:1px solid #2a0000;object-fit:contain;background:#0d0d0d;padding:4px;">
                        </div>
                        <% } %>

                        <%-- Pill-style file picker --%>
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

                        <c:if test="${not empty errImage}">
                            <span class="field-error" style="display:block;margin-top:0.5rem;"><c:out value="${errImage}"/></span>
                        </c:if>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">Save Changes</button>
                        <a href="<%= request.getContextPath() %>/AdminProducts" class="btn-cancel">Cancel</a>
                    </div>
                </form>
                <script>
                (function () {
                    var input       = document.getElementById('productImageInput');
                    var nameSpan    = document.getElementById('chosenFileName');
                    var preview     = document.getElementById('imgPreview');
                    var previewWrap = document.getElementById('previewWrap');

                    input.addEventListener('change', function () {
                        if (!input.files || !input.files[0]) return;
                        var file = input.files[0];

                        nameSpan.textContent = file.name;
                        nameSpan.classList.add('has-file');

                        var reader = new FileReader();
                        reader.onload = function (e) {
                            if (preview) {
                                preview.src = e.target.result;
                                preview.style.display = 'block';
                            }
                            if (previewWrap) previewWrap.style.display = 'flex';
                        };
                        reader.readAsDataURL(file);
                    });
                })();
                </script>
            </div>
        </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<footer><p>&copy; <%= new java.util.GregorianCalendar().get(java.util.Calendar.YEAR) %> HotWheels Nepal Admin Panel</p></footer>
</body>
</html>

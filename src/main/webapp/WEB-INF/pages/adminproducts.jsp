<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>HotWheelsNepal - Manage Products</title>
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
            <a href="${pageContext.request.contextPath}/AdminProducts" class="nav-item active">Manage Products</a>
            <a href="${pageContext.request.contextPath}/AddProduct" class="nav-item">Add Product</a>
            <a href="${pageContext.request.contextPath}/AdminUsers" class="nav-item">Manage Users</a>
            <a href="${pageContext.request.contextPath}/Home" class="nav-item">View Site</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout">Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-heading">
            <h2>Manage Products</h2>
            <a href="${pageContext.request.contextPath}/AddProduct" class="btn-add">+ Add New Product</a>
        </div>

        <c:if test="${param.success eq 'added'}"><div class="alert alert-success">Product added successfully.</div></c:if>
        <c:if test="${param.success eq 'updated'}"><div class="alert alert-success">Product updated successfully.</div></c:if>
        <c:if test="${param.success eq 'deleted'}"><div class="alert alert-success">Product deleted successfully.</div></c:if>
        <c:if test="${not empty param.error}"><div class="alert alert-error">${param.error}</div></c:if>

        <div class="section-card">
            <div class="section-header"><h3>All Products (<%= request.getAttribute("products") != null ? ((List)request.getAttribute("products")).size() : 0 %>)</h3></div>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>#</th><th>Product Name</th><th>Series</th><th>Price</th><th>Stock</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty products}">
                                <tr><td colspan="6" class="empty-row">No products found. <a href="${pageContext.request.contextPath}/AddProduct">Add one now</a>.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${products}">
                                <tr>
                                    <td>${p.productId}</td>
                                    <td>
                                        <strong>${p.name}</strong><br>
                                        <small>
                                            <c:choose>
                                                <c:when test="${not empty p.description and fn:length(p.description) > 50}">
                                                    ${fn:substring(p.description, 0, 50)}...
                                                </c:when>
                                                <c:otherwise>${p.description}</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </td>
                                    <td><span class="badge">${not empty p.series ? p.series : '—'}</span></td>
                                    <td class="price-cell">Rs. <c:out value="${p.price}"/></td>
                                    <td><span class="stock-badge ${p.stock > 0 ? 'in-stock' : 'out-stock'}">${p.stock}</span></td>
                                    <td class="actions-cell">
                                        <a href="${pageContext.request.contextPath}/EditProduct?id=${p.productId}" class="btn-edit">Edit</a>
                                        <form action="${pageContext.request.contextPath}/DeleteProduct" method="post" style="display:inline;" onsubmit="return confirm('Delete this product?')">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <button type="submit" class="btn-delete">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<footer><p>&copy; 2026 HotWheelsNepal Admin Panel</p></footer>
</body>
</html>

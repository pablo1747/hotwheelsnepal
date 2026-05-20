<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>HotWheelsNepal - Admin Dashboard</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<header>
    <h1>HotWheelsNepal <span class="admin-tag">ADMIN</span></h1>
    <nav>
        <a href="${pageContext.request.contextPath}/AdminDashboard" class="active">Dashboard</a>
        <a href="${pageContext.request.contextPath}/AdminProducts">Products</a>
        <a href="${pageContext.request.contextPath}/AdminUsers">Users</a>
        <a href="${pageContext.request.contextPath}/Home">View Site</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </nav>
</header>

<div class="admin-wrapper">
    <aside class="sidebar">
        <div class="admin-profile">
            <% if (session.getAttribute("imagePath") != null && !session.getAttribute("imagePath").toString().isEmpty()) { %>
                <div class="avatar" style="padding:0;overflow:hidden;">
                    <img src="<%= request.getContextPath() %>/<%= session.getAttribute("imagePath") %>"
                         alt="avatar" style="width:100%;height:100%;object-fit:cover;border-radius:50%;">
                </div>
            <% } else { %>
                <div class="avatar">A</div>
            <% } %>
            <div>
                <div class="admin-name"><%= session.getAttribute("username") %></div>
                <div class="admin-role">Administrator</div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/AdminDashboard" class="nav-item active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/AdminProducts" class="nav-item">Manage Products</a>
            <a href="${pageContext.request.contextPath}/AddProduct" class="nav-item">Add Product</a>
            <a href="${pageContext.request.contextPath}/AdminUsers" class="nav-item">Manage Users</a>
            <a href="${pageContext.request.contextPath}/EditProfile" class="nav-item">Edit Profile</a>
            <a href="${pageContext.request.contextPath}/Home" class="nav-item">View Site</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout">Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <c:if test="${param.profileUpdated eq 'true'}">
            <div style="background:rgba(0,200,80,0.08);border:1px solid rgba(0,200,80,0.25);color:#00c850;padding:0.8rem 1.2rem;border-radius:8px;font-size:0.88rem;margin-bottom:1.5rem;">
                Profile updated successfully!
            </div>
        </c:if>

        <div class="page-heading">
            <div>
                <h2>Dashboard Overview</h2>
                <p>Welcome back, <strong><%= session.getAttribute("username") %></strong></p>
            </div>
            <a href="${pageContext.request.contextPath}/EditProfile" class="btn-add" style="background:#1a1a1a;border:1px solid #333;color:#aaa;">Edit Profile</a>
        </div>

        <%-- ===== KEY STATS ===== --%>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon-text">Users</div>
                <div class="stat-value"><%= request.getAttribute("totalUsers") %></div>
                <div class="stat-label">Registered Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-text">Products</div>
                <div class="stat-value"><%= request.getAttribute("totalProducts") %></div>
                <div class="stat-label">Total Products</div>
            </div>
            <div class="stat-card stat-card--green">
                <div class="stat-icon-text">In Stock</div>
                <div class="stat-value"><%= request.getAttribute("inStock") %></div>
                <div class="stat-label">Available Products</div>
            </div>
            <div class="stat-card stat-card--red">
                <div class="stat-icon-text">Sold Out</div>
                <div class="stat-value"><%= request.getAttribute("outOfStock") %></div>
                <div class="stat-label">Out of Stock</div>
            </div>
            <div class="stat-card stat-card--gold">
                <div class="stat-icon-text">Stock Value</div>
                <div class="stat-value stat-value--sm"><%= request.getAttribute("totalStockValueFmt") %></div>
                <div class="stat-label">Total Stock Value</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-text">Avg Price</div>
                <div class="stat-value stat-value--sm"><%= request.getAttribute("avgPriceFmt") %></div>
                <div class="stat-label">Average Product Price</div>
            </div>
        </div>

        <%-- ===== STOCK LEVELS CHART ===== --%>
        <div class="section-card">
            <div class="section-header">
                <h3>Stock Levels by Product</h3>
                <a href="${pageContext.request.contextPath}/AdminProducts" class="btn-add" style="font-size:0.78rem; padding:0.4rem 0.9rem;">Manage</a>
            </div>
            <div class="chart-body">
                <c:choose>
                    <c:when test="${empty allProducts}">
                        <p style="color:#555; padding:2rem; text-align:center;">No products found. <a href="${pageContext.request.contextPath}/AddProduct" style="color:#ff4444;">Add one</a></p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${allProducts}">
                            <div class="chart-row">
                                <div class="chart-label">
                                    <span class="chart-name"><c:out value="${p.name}"/></span>
                                    <span class="chart-series"><c:out value="${p.series}"/></span>
                                </div>
                                <div class="chart-bar-wrap">
                                    <c:set var="pct" value="${maxStock > 0 ? (p.stock * 100 / maxStock) : 0}"/>
                                    <div class="chart-bar ${p.stock == 0 ? 'bar-empty' : (pct < 25 ? 'bar-low' : 'bar-ok')}"
                                         style="width:${p.stock == 0 ? 100 : pct}%"></div>
                                </div>
                                <div class="chart-qty ${p.stock == 0 ? 'qty-zero' : ''}">${p.stock}</div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- ===== PRICE TABLE ===== --%>
        <div class="section-card">
            <div class="section-header"><h3>Product Price Overview</h3></div>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Series</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Value</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty allProducts}">
                                <tr><td colspan="5" class="empty-row">No products yet. <a href="${pageContext.request.contextPath}/AddProduct">Add one</a></td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${allProducts}">
                                    <tr>
                                        <td><strong><c:out value="${p.name}"/></strong></td>
                                        <td><span class="badge"><c:out value="${p.series}"/></span></td>
                                        <td class="price-cell">Rs. ${p.price}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.stock > 0}">
                                                    <span class="stock-badge in-stock">${p.stock} units</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="stock-badge out-stock">Out of Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="price-cell">Rs. ${p.price * p.stock}</td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- ===== QUICK ACTIONS ===== --%>
        <div class="section-card">
            <div class="section-header"><h3>Quick Actions</h3></div>
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/AddProduct" class="action-btn">+ Add New Product</a>
                <a href="${pageContext.request.contextPath}/AdminProducts" class="action-btn secondary">Manage Products</a>
                <a href="${pageContext.request.contextPath}/AdminUsers" class="action-btn secondary">Manage Users</a>
                <a href="${pageContext.request.contextPath}/DownloadReport" class="action-btn" style="background:#1a6b1a;border:none;" title="Download this month's sales report as an HTML file">&#8595; Download Monthly Report</a>
            </div>
        </div>

        <%-- ===== SYSTEM INFO ===== --%>
        <div class="section-card">
            <div class="section-header"><h3>System Info</h3></div>
            <div class="info-table">
                <div class="info-row"><span class="info-label">Application</span><span class="info-value">HotWheels Nepal</span></div>
                <div class="info-row"><span class="info-label">Logged in as</span><span class="info-value"><%= session.getAttribute("username") %> (Admin)</span></div>
                <div class="info-row"><span class="info-label">Total Users</span><span class="info-value"><%= request.getAttribute("totalUsers") %></span></div>
                <div class="info-row"><span class="info-label">Total Products</span><span class="info-value"><%= request.getAttribute("totalProducts") %></span></div>
            </div>
        </div>
    </main>
</div>

<footer><p>&copy; 2026 HotWheelsNepal Admin Panel</p></footer>
</body>
</html>

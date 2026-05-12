<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | <%= session.getAttribute("firstName") != null ? session.getAttribute("firstName") + "'s Dashboard" : "My Dashboard" %></title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/userdashboard.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="dashboard"/>
</jsp:include>

<div class="dashboard-wrapper">

    <aside class="sidebar">
        <div class="user-profile">
            <% if (session.getAttribute("imagePath") != null && !session.getAttribute("imagePath").toString().isEmpty()) { %>
                <div class="avatar" style="padding:0;overflow:hidden;">
                    <img src="<%= request.getContextPath() %>/<%= session.getAttribute("imagePath") %>"
                         alt="avatar" style="width:100%;height:100%;object-fit:cover;border-radius:50%;">
                </div>
            <% } else { %>
                <div class="avatar"><%= session.getAttribute("firstName") != null ? ((String)session.getAttribute("firstName")).substring(0,1).toUpperCase() : "U" %></div>
            <% } %>
            <div class="user-info">
                <h3><%= session.getAttribute("firstName") != null ? session.getAttribute("firstName") : "User" %> <%= session.getAttribute("lastName") != null ? session.getAttribute("lastName") : "" %></h3>
                <span class="role-badge"><%= session.getAttribute("role") != null ? ((String)session.getAttribute("role")).substring(0,1).toUpperCase() + ((String)session.getAttribute("role")).substring(1) : "Collector" %></span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="#" class="nav-item active">Overview</a>
            <a href="${pageContext.request.contextPath}/Shop" class="nav-item">Shop</a>
            <a href="${pageContext.request.contextPath}/Cart" class="nav-item">My Cart</a>
            <a href="${pageContext.request.contextPath}/EditProfile" class="nav-item">Edit Profile</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout">Logout</a>
        </nav>
    </aside>

    <main class="main-content">

        <c:if test="${param.profileUpdated eq 'true'}">
            <div style="background:rgba(0,200,80,0.08);border:1px solid rgba(0,200,80,0.25);color:#00c850;padding:0.8rem 1.2rem;border-radius:8px;font-size:0.88rem;margin-bottom:1.5rem;">
                Profile updated successfully!
            </div>
        </c:if>

        <div class="welcome-banner">
            <div>
                <h2>Welcome back, <span><%= session.getAttribute("firstName") != null ? session.getAttribute("firstName") : "Collector" %></span>!</h2>
                <p>Here's what's happening with your account today.</p>
            </div>
            <div style="display:flex;gap:0.8rem;">
                <a href="${pageContext.request.contextPath}/EditProfile" class="btn-shop" style="background:#1a1a1a;border:1px solid #333;box-shadow:none;">Edit Profile</a>
                <a href="${pageContext.request.contextPath}/Shop" class="btn-shop">Browse Shop</a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= request.getAttribute("totalOrders") %></div>
                <div class="stat-label">Total Orders</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= request.getAttribute("cartCount") %></div>
                <div class="stat-label">Items in Cart</div>
            </div>
        </div>

        <div class="section-card">
            <div class="section-header">
                <h3>My Account Details</h3>
            </div>
            <div class="account-details">
                <div class="detail-row">
                    <span class="detail-label">Full Name</span>
                    <span class="detail-value"><%= session.getAttribute("firstName") %> <%= session.getAttribute("lastName") %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Username</span>
                    <span class="detail-value"><%= session.getAttribute("username") %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Email</span>
                    <span class="detail-value"><%= session.getAttribute("email") %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Phone</span>
                    <span class="detail-value"><%= session.getAttribute("phone") != null ? session.getAttribute("phone") : "Not provided" %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Account Role</span>
                    <span class="detail-value"><span class="role-badge"><%= session.getAttribute("role") != null ? session.getAttribute("role") : "user" %></span></span>
                </div>
                <c:if test="${not empty lastLogin}">
                <div class="detail-row">
                    <span class="detail-label">Last Login</span>
                    <span class="detail-value"><c:out value="${lastLogin}"/></span>
                </div>
                </c:if>
            </div>
        </div>

        <div class="section-card">
            <div class="section-header">
                <h3>Recent Orders</h3>
                <a href="${pageContext.request.contextPath}/Shop" class="link-red">Shop Now &rarr;</a>
            </div>
            <div class="empty-state">
                <h4>No orders yet</h4>
                <p>You haven't placed any orders. Start exploring our collection!</p>
                <a href="${pageContext.request.contextPath}/Shop" class="btn-primary">Browse Cars</a>
            </div>
        </div>

    </main>
</div>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>
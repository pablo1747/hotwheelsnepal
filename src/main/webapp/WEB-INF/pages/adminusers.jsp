<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>HotWheelsNepal - Manage Users</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<header>
    <h1>HotWheelsNepal <span class="admin-tag">ADMIN</span></h1>
    <nav>
        <a href="${pageContext.request.contextPath}/AdminDashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/AdminProducts">Products</a>
        <a href="${pageContext.request.contextPath}/AdminUsers" class="active">Users</a>
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
            <a href="${pageContext.request.contextPath}/AddProduct" class="nav-item">Add Product</a>
            <a href="${pageContext.request.contextPath}/AdminUsers" class="nav-item active">Manage Users</a>
            <a href="${pageContext.request.contextPath}/Home" class="nav-item">View Site</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item logout">Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-heading">
            <h2>Manage Users</h2>
            <span class="total-count"><%= request.getAttribute("users") != null ? ((List)request.getAttribute("users")).size() : 0 %> total users</span>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <div class="section-card">
            <div class="section-header"><h3>All Registered Users (<%= request.getAttribute("users") != null ? ((List)request.getAttribute("users")).size() : 0 %>)</h3></div>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Full Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty users}">
                                <tr><td colspan="8" class="empty-row">No registered users found.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>${u.userId}</td>
                                    <td><strong>${u.firstName} ${u.lastName}</strong></td>
                                    <td>${u.username}</td>
                                    <td>${u.email}</td>
                                    <td>${not empty u.phoneNumber ? u.phoneNumber : '—'}</td>
                                    <td><span class="role-badge ${u.role eq 'admin' ? 'admin-role' : 'user-role'}">${u.role}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role ne 'admin'}">
                                                <span class="status-badge ${u.status eq 'active' ? 'status-active' : 'status-inactive'}">
                                                    ${u.status eq 'active' ? 'Active' : 'Inactive'}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-active">Active</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="actions-cell">
                                        <c:choose>
                                            <c:when test="${u.role ne 'admin'}">
                                                <form action="${pageContext.request.contextPath}/AdminUsers" method="post" style="display:inline;"
                                                      onsubmit="return confirm('${u.status eq 'active' ? 'Deactivate' : 'Activate'} this user?')">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="userId" value="${u.userId}">
                                                    <input type="hidden" name="currentStatus" value="${u.status}">
                                                    <button type="submit"
                                                            class="${u.status eq 'active' ? 'btn-deactivate' : 'btn-activate'}">
                                                        ${u.status eq 'active' ? 'Deactivate' : 'Activate'}
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise><span class="protected-label">Protected</span></c:otherwise>
                                        </c:choose>
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

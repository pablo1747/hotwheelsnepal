<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HotWheels Nepal | Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="login"/>
</jsp:include>

<div class="login-wrapper">
<div class="login-container">
    <h2>Sign In</h2>
    <p class="subtitle">Welcome back to HotWheels Nepal</p>

    <c:if test="${not empty lastLogin}">
        <div class="alert alert-info">Last login: <%= request.getAttribute("lastLogin") %></div>
    </c:if>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success"><%= request.getAttribute("successMessage") %></div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">

        <div class="input-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter your username"
                   value="<%= request.getAttribute("typedUser") != null ? request.getAttribute("typedUser") : "" %>" required>
        </div>

        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>
        </div>

        <button type="submit" class="btn-login">Login</button>
    </form>

    <div class="signup-link">
        <p>Don't have an account?
            <a href="${pageContext.request.contextPath}/Registration">Sign up here</a>
        </p>
    </div>
</div>
</div>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

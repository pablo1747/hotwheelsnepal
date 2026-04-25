<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HotWheels Nepal | Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/registration.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="register"/>
</jsp:include>

<div class="register-wrapper">
<div class="register-container">
    <h2>Create an Account</h2>
    <p class="subtitle">Join the HotWheels Nepal community</p>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/Registration" method="post" enctype="multipart/form-data">

        <div class="row">
            <div class="input-box">
                <label>First Name <span class="required">*</span></label>
                <input type="text" name="firstName" placeholder="e.g. John"
                       value="<%= request.getAttribute("valFirstName") != null ? request.getAttribute("valFirstName") : "" %>">
                <c:if test="${not empty errFirstName}">
                    <span class="field-error"><c:out value="${errFirstName}"/></span>
                </c:if>
            </div>
            <div class="input-box">
                <label>Last Name <span class="required">*</span></label>
                <input type="text" name="lastName" placeholder="e.g. Doe"
                       value="<%= request.getAttribute("valLastName") != null ? request.getAttribute("valLastName") : "" %>">
                <c:if test="${not empty errLastName}">
                    <span class="field-error"><c:out value="${errLastName}"/></span>
                </c:if>
            </div>
        </div>

        <div class="row">
            <div class="input-box">
                <label>Username <span class="required">*</span></label>
                <input type="text" name="username" placeholder="e.g. johndoe123"
                       value="<%= request.getAttribute("valUsername") != null ? request.getAttribute("valUsername") : "" %>">
                <c:if test="${not empty errUsername}">
                    <span class="field-error"><c:out value="${errUsername}"/></span>
                </c:if>
            </div>
            <div class="input-box">
                <label>Date of Birth <span class="required">*</span></label>
                <input type="date" name="dob" value="<%= request.getAttribute("valDob") != null ? request.getAttribute("valDob") : "" %>">
                <c:if test="${not empty errDob}">
                    <span class="field-error"><c:out value="${errDob}"/></span>
                </c:if>
            </div>
        </div>

        <div class="row">
            <div class="input-box">
                <label>Gender <span class="required">*</span></label>
                <select name="gender">
                    <option value="Male"   ${valGender == 'Male'   ? 'selected' : ''}>Male</option>
                    <option value="Female" ${valGender == 'Female' ? 'selected' : ''}>Female</option>
                    <option value="Other"  ${valGender == 'Other'  ? 'selected' : ''}>Other</option>
                </select>
            </div>
            <div class="input-box">
                <label>Email Address <span class="required">*</span></label>
                <input type="email" name="email" placeholder="e.g. name@example.com"
                       value="<%= request.getAttribute("valEmail") != null ? request.getAttribute("valEmail") : "" %>">
                <c:if test="${not empty errEmail}">
                    <span class="field-error"><c:out value="${errEmail}"/></span>
                </c:if>
            </div>
        </div>

        <div class="row">
            <div class="input-box">
                <label>Phone Number <span class="required">*</span></label>
                <input type="text" name="phoneNumber" placeholder="+977 98XXXXXXXX"
                       value="<%= request.getAttribute("valPhone") != null ? request.getAttribute("valPhone") : "" %>">
                <c:if test="${not empty errPhone}">
                    <span class="field-error"><c:out value="${errPhone}"/></span>
                </c:if>
            </div>
            <div class="input-box">
                <label>Profile Picture <span class="optional">(optional)</span></label>
                <input type="file" name="profileImage" accept="image/*">
                <c:if test="${not empty errImage}">
                    <span class="field-error"><c:out value="${errImage}"/></span>
                </c:if>
            </div>
        </div>

        <div class="row">
            <div class="input-box">
                <label>Password <span class="required">*</span></label>
                <input type="password" name="password" placeholder="At least 8 characters">
                <c:if test="${not empty errPassword}">
                    <span class="field-error"><c:out value="${errPassword}"/></span>
                </c:if>
            </div>
            <div class="input-box">
                <label>Confirm Password <span class="required">*</span></label>
                <input type="password" name="rePassword" placeholder="Re-enter your password">
                <c:if test="${not empty errRePassword}">
                    <span class="field-error"><c:out value="${errRePassword}"/></span>
                </c:if>
            </div>
        </div>

        <div class="button">
            <button type="submit">Create Account</button>
        </div>

        <div class="login-link">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
        </div>

    </form>
</div>
</div>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

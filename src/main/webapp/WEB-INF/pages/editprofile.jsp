<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" import="com.hotwheelsnepal.model.UserModel" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    UserModel user = (UserModel) request.getAttribute("user");
    String curFirst  = request.getAttribute("valFirstName") != null ? (String)request.getAttribute("valFirstName") : (user != null ? user.getFirstName()   : "");
    String curLast   = request.getAttribute("valLastName")  != null ? (String)request.getAttribute("valLastName")  : (user != null ? user.getLastName()    : "");
    String curPhone  = request.getAttribute("valPhone")     != null ? (String)request.getAttribute("valPhone")     : (user != null ? user.getPhoneNumber() : "");
    String curGender = request.getAttribute("valGender")    != null ? (String)request.getAttribute("valGender")    : (user != null ? user.getGender()      : "");
    String curDob    = request.getAttribute("valDob")       != null ? (String)request.getAttribute("valDob")       : (user != null && user.getDob() != null ? user.getDob().toString() : "");
    String curImage  = user != null ? user.getImagePath() : null;
    String role      = (String) session.getAttribute("role");
    boolean isAdmin  = "admin".equals(role);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Edit Profile</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/editprofile.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value=""/>
</jsp:include>

<section class="ep-hero">
    <h1>Edit Profile</h1>
    <p>Update your personal details below</p>
</section>

<section class="ep-section">
<div class="ep-layout">

    <%-- ===== LEFT: AVATAR PREVIEW ===== --%>
    <div class="ep-sidebar">
        <div class="avatar-wrap">
            <% if (curImage != null && !curImage.isEmpty()) { %>
                <img src="<%= request.getContextPath() %>/<%= curImage %>" alt="Profile" class="avatar-img" id="avatarPreview">
            <% } else { %>
                <div class="avatar-placeholder" id="avatarPlaceholder">
                    <%= session.getAttribute("firstName") != null ? ((String)session.getAttribute("firstName")).substring(0,1).toUpperCase() : "?" %>
                </div>
                <img src="" alt="Profile" class="avatar-img hidden" id="avatarPreview">
            <% } %>
            <label for="profileImage" class="avatar-edit-btn">Change Photo</label>
        </div>

        <div class="profile-meta">
            <div class="meta-row">
                <span class="meta-label">Username</span>
                <span class="meta-value"><%= session.getAttribute("username") %></span>
            </div>
            <div class="meta-row">
                <span class="meta-label">Email</span>
                <span class="meta-value"><%= session.getAttribute("email") %></span>
            </div>
            <div class="meta-row">
                <span class="meta-label">Role</span>
                <span class="meta-value role-badge"><%= role != null ? role.substring(0,1).toUpperCase() + role.substring(1) : "" %></span>
            </div>
        </div>

        <p class="locked-note">Username and email cannot be changed.</p>

        <a href="<%= request.getContextPath() %><%= isAdmin ? "/AdminDashboard" : "/UserDashboard" %>" class="btn-back-dash">
            &larr; Back to Dashboard
        </a>
    </div>

    <%-- ===== RIGHT: FORM ===== --%>
    <div class="ep-form-wrap">

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
        </c:if>

        <form action="<%= request.getContextPath() %>/EditProfile" method="post" enctype="multipart/form-data" class="ep-form">

            <%-- Hidden file input wired to the avatar change button --%>
            <input type="file" name="profileImage" id="profileImage" accept="image/*" class="hidden">

            <div class="form-section-title">Personal Details</div>

            <div class="form-row">
                <div class="form-group">
                    <label>First Name <span class="req">*</span></label>
                    <input type="text" name="firstName" value="<%= curFirst %>" placeholder="First name" required>
                    <c:if test="${not empty errFirstName}">
                        <span class="field-error"><%= request.getAttribute("errFirstName") %></span>
                    </c:if>
                </div>
                <div class="form-group">
                    <label>Last Name <span class="req">*</span></label>
                    <input type="text" name="lastName" value="<%= curLast %>" placeholder="Last name" required>
                    <c:if test="${not empty errLastName}">
                        <span class="field-error"><%= request.getAttribute("errLastName") %></span>
                    </c:if>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Phone Number <span class="req">*</span></label>
                    <input type="text" name="phoneNumber" value="<%= curPhone %>" placeholder="+977 98XXXXXXXX" required>
                    <c:if test="${not empty errPhone}">
                        <span class="field-error"><%= request.getAttribute("errPhone") %></span>
                    </c:if>
                </div>
                <div class="form-group">
                    <label>Gender</label>
                    <select name="gender">
                        <option value="Male"   <%= "Male".equals(curGender)   ? "selected" : "" %>>Male</option>
                        <option value="Female" <%= "Female".equals(curGender) ? "selected" : "" %>>Female</option>
                        <option value="Other"  <%= "Other".equals(curGender)  ? "selected" : "" %>>Other</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Date of Birth</label>
                    <input type="date" name="dob" value="<%= curDob %>">
                </div>
            </div>

            <c:if test="${not empty errImage}">
                <div class="alert alert-error"><%= request.getAttribute("errImage") %></div>
            </c:if>

            <div class="form-divider"></div>
            <div class="form-section-title">Change Password <span class="optional-tag">(optional)</span></div>

            <div class="form-row">
                <div class="form-group">
                    <label>New Password</label>
                    <input type="password" name="newPassword" placeholder="Leave blank to keep current">
                    <c:if test="${not empty errPassword}">
                        <span class="field-error"><%= request.getAttribute("errPassword") %></span>
                    </c:if>
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword" placeholder="Repeat new password">
                    <c:if test="${not empty errConfirm}">
                        <span class="field-error"><%= request.getAttribute("errConfirm") %></span>
                    </c:if>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-save">Save Changes</button>
                <a href="<%= request.getContextPath() %><%= isAdmin ? "/AdminDashboard" : "/UserDashboard" %>" class="btn-cancel">Cancel</a>
            </div>

        </form>
    </div>

</div>
</section>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

<script>
(function () {
    var fileInput    = document.getElementById('profileImage');
    var preview      = document.getElementById('avatarPreview');
    var placeholder  = document.getElementById('avatarPlaceholder');

    fileInput.addEventListener('change', function () {
        if (fileInput.files && fileInput.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.classList.remove('hidden');
                if (placeholder) placeholder.classList.add('hidden');
            };
            reader.readAsDataURL(fileInput.files[0]);
        }
    });
})();
</script>
</body>
</html>

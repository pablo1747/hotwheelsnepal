<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | About Us</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/aboutus.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="about"/>
</jsp:include>

<section class="about-hero">
    <h1>About HotWheels Nepal</h1>
    <p>Discover our passion for diecast cars and Hot Wheels collectibles</p>
</section>

<section class="section">
    <div class="about-content">
        <h2>Who We Are</h2>
        <p>
            HotWheels Nepal is a premium destination for Hot Wheels enthusiasts and diecast collectors.
            We offer rare models, exclusive releases, and custom track solutions for fans of all ages.
        </p>

        <h2>Our Mission</h2>
        <p>
            To inspire collectors and racers by providing high-quality miniature cars, expert advice,
            and a community where passion meets precision.
        </p>

        <h2>Why Choose HotWheels Nepal?</h2>
        <ul>
            <li>Extensive collection of rare and collectible cars</li>
            <li>Expert guidance for collectors and track builders</li>
            <li>Secure shopping with warranty-backed products</li>
            <li>Community-driven events and promotions</li>
        </ul>
    </div>
</section>

<section class="section">
    <h2 style="font-family:'Rajdhani',sans-serif; font-size:2rem; margin-bottom:0.4rem;">Meet the Team</h2>
    <p style="color:#666; font-size:0.9rem; margin-bottom:2rem;">The people behind HotWheels Nepal</p>

    <div class="owners">

        <div class="owner-card">
            <div class="owner-avatar">S</div>
            <h3><a href="<%= request.getContextPath() %>/Sanjeev">Sanjeev</a></h3>
            <p>Founder &amp; Collector</p>
        </div>

        <div class="owner-card">
            <div class="owner-avatar">P</div>
            <h3><a href="<%= request.getContextPath() %>/Pratik">Pratik</a></h3>
            <p>Marketing Head</p>
        </div>

        <div class="owner-card">
            <div class="owner-avatar">A</div>
            <h3><a href="<%= request.getContextPath() %>/Aryan">Aryan</a></h3>
            <p>Operations Manager</p>
        </div>

        <div class="owner-card">
            <div class="owner-avatar">R</div>
            <h3><a href="<%= request.getContextPath() %>/Rochan">Rochan</a></h3>
            <p>Distribution Manager</p>
        </div>

        <div class="owner-card">
            <div class="owner-avatar">R</div>
            <h3><a href="<%= request.getContextPath() %>/Rojan">Rojan</a></h3>
            <p>Assistant Manager</p>
        </div>

    </div>
</section>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

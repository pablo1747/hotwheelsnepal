<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Aryan Pandey — Operations Manager</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/owners.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="about"/>
</jsp:include>

<div class="portfolio-page">
    <div class="pg-grid"></div>
    <div class="pg-glow" style="left:55%;top:60%;"></div>

    <!-- ===== HERO ===== -->
    <section class="portfolio-hero">
        <div class="portfolio-container">

            <div class="breadcrumb">
                <a href="<%= request.getContextPath() %>/Home">Home</a>
                <span>/</span>
                <a href="<%= request.getContextPath() %>/AboutUs">About Us</a>
                <span>/</span>
                <span class="current">Aryan Pandey</span>
            </div>

            <div class="portfolio-layout" style="margin-top:2.5rem;">

                <!-- LEFT -->
                <div class="portfolio-left">

                    <div class="photo-rings">
                        <div class="ring-outer"></div>
                        <div class="ring-mid"></div>
                        <div class="photo-frame">
                            <img src="<%= request.getContextPath() %>/images/aryan.JPG" alt="Aryan">
                        </div>
                    </div>

                    <div class="status-badge">
                        <span class="status-dot"></span>
                        Racing Season Active
                    </div>

                    <div class="info-card">
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></span>
                            <span class="info-label">Location</span>
                            <span class="info-value">Bhaktapur, Nepal</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg></span>
                            <span class="info-label">Email</span>
                            <span class="info-value">aryan@hotwheelsnepal.com</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg></span>
                            <span class="info-label">Focus</span>
                            <span class="info-value">Operations &amp; Events</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/></svg></span>
                            <span class="info-label">Role</span>
                            <span class="info-value">Operations Manager</span>
                        </div>
                    </div>

                </div>

                <!-- RIGHT -->
                <div class="portfolio-right">

                    <span class="role-pill">Operations Manager</span>

                    <h1 class="profile-name">Aryan Pandey</h1>

                    <p class="profile-tagline">
                        "Turning Passion into Precision — Every Order, Every Race, Every Time"
                    </p>

                    <p class="profile-bio">
                        Aryan Pandey is the operational backbone of HotWheels Nepal, ensuring that every
                        order is fulfilled with precision and every event runs like a well-oiled machine.
                        As Operations Manager, he oversees inventory management, order fulfilment, logistics
                        coordination, and the organisation of racing competitions across Nepal. Aryan has a
                        keen eye for detail and a passion for racing events — from planning Kathmandu's
                        largest Hot Wheels drag-race showdowns to managing the behind-the-scenes logistics
                        that keep collectors happy. He makes the wheels turn.
                    </p>

                    <div class="profile-stats">
                        <div class="pstat">
                            <span class="pstat-num">3+</span>
                            <span class="pstat-lbl">Years</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">500+</span>
                            <span class="pstat-lbl">Orders</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">50+</span>
                            <span class="pstat-lbl">Events Run</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">98%</span>
                            <span class="pstat-lbl">On-Time Rate</span>
                        </div>
                    </div>

                    <div class="profile-actions">
                        <a href="<%= request.getContextPath() %>/ContactUs" class="btn-contact">
                            Get in Touch &#8594;
                        </a>
                        <a href="<%= request.getContextPath() %>/AboutUs" class="btn-back-team">
                            &#8592; Meet the Team
                        </a>
                    </div>

                </div>

            </div>
        </div>
    </section>

    <!-- ===== SKILLS ===== -->
    <section class="skills-section">
        <div class="portfolio-container">
            <div class="skills-inner">
                <h3 class="skills-heading">
                    <span></span>
                    Expertise &amp; Interests
                    <span></span>
                </h3>
                <div class="skills-wrap">
                    <span class="skill-tag">Operations Management</span>
                    <span class="skill-tag">Inventory Control</span>
                    <span class="skill-tag">Logistics &amp; Fulfillment</span>
                    <span class="skill-tag">Event Planning</span>
                    <span class="skill-tag">Racing Competitions</span>
                    <span class="skill-tag">Quality Control</span>
                    <span class="skill-tag">Team Coordination</span>
                    <span class="skill-tag">Process Optimisation</span>
                    <span class="skill-tag">Track Setup</span>
                    <span class="skill-tag">Customer Experience</span>
                </div>
            </div>
        </div>
    </section>

</div>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

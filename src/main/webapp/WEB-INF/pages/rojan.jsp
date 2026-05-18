<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Rojan — Assistant Manager</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/owners.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="about"/>
</jsp:include>

<div class="portfolio-page">
    <div class="pg-grid"></div>
    <div class="pg-glow" style="left:50%;top:65%;"></div>

    <!-- ===== HERO ===== -->
    <section class="portfolio-hero">
        <div class="portfolio-container">

            <div class="breadcrumb">
                <a href="<%= request.getContextPath() %>/Home">Home</a>
                <span>/</span>
                <a href="<%= request.getContextPath() %>/AboutUs">About Us</a>
                <span>/</span>
                <span class="current">Rojan</span>
            </div>

            <div class="portfolio-layout" style="margin-top:2.5rem;">

                <!-- LEFT -->
                <div class="portfolio-left">

                    <div class="photo-frame">
                        <img src="<%= request.getContextPath() %>/images/default.jpg" alt="Rojan">
                    </div>

                    <div class="status-badge">
                        <span class="status-dot"></span>
                        Ready to Assist
                    </div>

                    <div class="info-card">
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></span>
                            <span class="info-label">Location</span>
                            <span class="info-value">Kathmandu, Nepal</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg></span>
                            <span class="info-label">Email</span>
                            <span class="info-value">rojan@hotwheelsnepal.com</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></span>
                            <span class="info-label">Focus</span>
                            <span class="info-value">Support &amp; Coordination</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/></svg></span>
                            <span class="info-label">Role</span>
                            <span class="info-value">Assistant Manager</span>
                        </div>
                    </div>

                </div>

                <!-- RIGHT -->
                <div class="portfolio-right">

                    <span class="role-pill">Assistant Manager</span>

                    <h1 class="profile-name">Rojan</h1>

                    <p class="profile-tagline">
                        "Behind Every Smooth Operation Is Someone Making Sure Nothing Falls Through"
                    </p>

                    <p class="profile-bio">
                        Rojan serves as the connective tissue of HotWheels Nepal — the Assistant Manager
                        who keeps all departments aligned and running smoothly. He supports senior
                        management across operations, marketing, and customer relations, ensuring that
                        daily tasks are executed with precision. Whether it is coordinating with the team
                        on event day, handling escalated customer queries, or managing internal
                        communications, Rojan brings calm, clarity, and commitment to everything he
                        touches. His versatility and reliability make him an indispensable part of the team.
                    </p>

                    <div class="profile-stats">
                        <div class="pstat">
                            <span class="pstat-num">2+</span>
                            <span class="pstat-lbl">Years</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">300+</span>
                            <span class="pstat-lbl">Tasks Handled</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">30+</span>
                            <span class="pstat-lbl">Events Supported</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">4.9</span>
                            <span class="pstat-lbl">Team Rating</span>
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
                    <span class="skill-tag">Team Coordination</span>
                    <span class="skill-tag">Customer Relations</span>
                    <span class="skill-tag">Administrative Support</span>
                    <span class="skill-tag">Event Assistance</span>
                    <span class="skill-tag">Communication</span>
                    <span class="skill-tag">Problem Solving</span>
                    <span class="skill-tag">Scheduling &amp; Planning</span>
                    <span class="skill-tag">Data Entry &amp; Records</span>
                    <span class="skill-tag">Cross-Dept Liaison</span>
                    <span class="skill-tag">Quality Assurance</span>
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

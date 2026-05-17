<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Rochan — Distribution Manager</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/owners.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="about"/>
</jsp:include>

<div class="portfolio-page">
    <div class="pg-grid"></div>
    <div class="pg-glow" style="left:45%;top:55%;"></div>

    <!-- ===== HERO ===== -->
    <section class="portfolio-hero">
        <div class="portfolio-container">

            <div class="breadcrumb">
                <a href="<%= request.getContextPath() %>/Home">Home</a>
                <span>/</span>
                <a href="<%= request.getContextPath() %>/AboutUs">About Us</a>
                <span>/</span>
                <span class="current">Rochan</span>
            </div>

            <div class="portfolio-layout" style="margin-top:2.5rem;">

                <!-- LEFT -->
                <div class="portfolio-left">

                    <div class="photo-rings">
                        <div class="ring-outer"></div>
                        <div class="ring-mid"></div>
                        <div class="photo-frame">
                            <img src="<%= request.getContextPath() %>/images/default.jpg" alt="Rochan Basnet">
                        </div>
                    </div>

                    <div class="status-badge">
                        <span class="status-dot"></span>
                        Available for Deliveries
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
                            <span class="info-value">rochan@hotwheelsnepal.com</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 5v3h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg></span>
                            <span class="info-label">Focus</span>
                            <span class="info-value">Supply &amp; Distribution</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/></svg></span>
                            <span class="info-label">Role</span>
                            <span class="info-value">Distribution Manager</span>
                        </div>
                    </div>

                </div>

                <!-- RIGHT -->
                <div class="portfolio-right">

                    <span class="role-pill">Distribution Manager</span>

                    <h1 class="profile-name">Rochan</h1>

                    <p class="profile-tagline">
                        "Every Car Delivered, Every Route Optimised — From Warehouse to Your Door"
                    </p>

                    <p class="profile-bio">
                        Rochan is the logistics mastermind behind HotWheels Nepal's seamless distribution
                        network. As Distribution Manager, he oversees the entire supply chain — from sourcing
                        authentic Hot Wheels models to ensuring swift and safe delivery across Nepal. With
                        deep expertise in warehouse management, vendor relationships, and last-mile delivery
                        coordination, Rochan ensures that collectors receive their prized cars in perfect
                        condition and on time. His systematic approach and attention to packaging integrity
                        have earned HotWheels Nepal a reputation for reliability.
                    </p>

                    <div class="profile-stats">
                        <div class="pstat">
                            <span class="pstat-num">2+</span>
                            <span class="pstat-lbl">Years</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">1K+</span>
                            <span class="pstat-lbl">Deliveries</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">15+</span>
                            <span class="pstat-lbl">Suppliers</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">99%</span>
                            <span class="pstat-lbl">Safe Delivery</span>
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
                    <span class="skill-tag">Supply Chain Management</span>
                    <span class="skill-tag">Warehouse Operations</span>
                    <span class="skill-tag">Last-Mile Delivery</span>
                    <span class="skill-tag">Vendor Management</span>
                    <span class="skill-tag">Route Optimisation</span>
                    <span class="skill-tag">Inventory Tracking</span>
                    <span class="skill-tag">Packaging &amp; Safety</span>
                    <span class="skill-tag">Import Coordination</span>
                    <span class="skill-tag">Cost Reduction</span>
                    <span class="skill-tag">Fleet Management</span>
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

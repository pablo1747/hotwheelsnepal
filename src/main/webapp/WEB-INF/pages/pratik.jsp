<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Pratik Karki — Marketing Head</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/owners.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="about"/>
</jsp:include>

<div class="portfolio-page">
    <div class="pg-grid"></div>
    <div class="pg-glow" style="left:65%;"></div>

    <!-- ===== HERO ===== -->
    <section class="portfolio-hero">
        <div class="portfolio-container">

            <div class="breadcrumb">
                <a href="<%= request.getContextPath() %>/Home">Home</a>
                <span>/</span>
                <a href="<%= request.getContextPath() %>/AboutUs">About Us</a>
                <span>/</span>
                <span class="current">Pratik Karki</span>
            </div>

            <div class="portfolio-layout" style="margin-top:2.5rem;">

                <!-- LEFT -->
                <div class="portfolio-left">

                    <div class="photo-rings">
                        <div class="ring-outer"></div>
                        <div class="ring-mid"></div>
                        <div class="photo-frame">
                            <div class="photo-initial">PK</div>
                        </div>
                    </div>

                    <div class="status-badge">
                        <span class="status-dot"></span>
                        Open to Partnerships
                    </div>

                    <div class="info-card">
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></span>
                            <span class="info-label">Location</span>
                            <span class="info-value">Lalitpur, Nepal</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg></span>
                            <span class="info-label">Email</span>
                            <span class="info-value">pratik@hotwheelsnepal.com</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg></span>
                            <span class="info-label">Focus</span>
                            <span class="info-value">Digital &amp; Brand</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/></svg></span>
                            <span class="info-label">Role</span>
                            <span class="info-value">Marketing Head</span>
                        </div>
                    </div>

                </div>

                <!-- RIGHT -->
                <div class="portfolio-right">

                    <span class="role-pill">Marketing Head</span>

                    <h1 class="profile-name">Pratik Karki</h1>

                    <p class="profile-tagline">
                        "Spreading the Hot Wheels Passion Across Every Corner of Nepal"
                    </p>

                    <p class="profile-bio">
                        Pratik Karki is the creative engine behind HotWheels Nepal's brand presence and
                        digital outreach. As Marketing Head, he crafts compelling campaigns that connect
                        collectors with the models they love. With a sharp eye for trends and a deep
                        understanding of the collector community, Pratik drives awareness through social
                        media, content creation, and strategic brand partnerships. He has grown the
                        HotWheels Nepal community to over 5,000 passionate members — and the engine
                        is just getting warmed up.
                    </p>

                    <div class="profile-stats">
                        <div class="pstat">
                            <span class="pstat-num">3+</span>
                            <span class="pstat-lbl">Years</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">50+</span>
                            <span class="pstat-lbl">Campaigns</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">5K+</span>
                            <span class="pstat-lbl">Reach</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">12+</span>
                            <span class="pstat-lbl">Partnerships</span>
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
                    <span class="skill-tag">Digital Marketing</span>
                    <span class="skill-tag">Social Media Strategy</span>
                    <span class="skill-tag">Brand Development</span>
                    <span class="skill-tag">Content Creation</span>
                    <span class="skill-tag">SEO &amp; Growth</span>
                    <span class="skill-tag">Influencer Outreach</span>
                    <span class="skill-tag">Email Campaigns</span>
                    <span class="skill-tag">Community Management</span>
                    <span class="skill-tag">Photography</span>
                    <span class="skill-tag">Analytics &amp; Insights</span>
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

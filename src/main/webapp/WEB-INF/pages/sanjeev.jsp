<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Sanjeev Ghimire — Founder</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/owners.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="about"/>
</jsp:include>

<div class="portfolio-page">
    <div class="pg-grid"></div>
    <div class="pg-glow"></div>

    <!-- ===== HERO ===== -->
    <section class="portfolio-hero">
        <div class="portfolio-container">

            <!-- Breadcrumb -->
            <div class="breadcrumb">
                <a href="<%= request.getContextPath() %>/Home">Home</a>
                <span>/</span>
                <a href="<%= request.getContextPath() %>/AboutUs">About Us</a>
                <span>/</span>
                <span class="current">Sanjeev Ghimire</span>
            </div>

            <div class="portfolio-layout" style="margin-top:2.5rem;">

                <!-- LEFT: Photo + info card -->
                <div class="portfolio-left">

                    <div class="photo-rings">
                        <div class="ring-outer"></div>
                        <div class="ring-mid"></div>
                        <div class="photo-frame">
                            <img src="<%= request.getContextPath() %>/images/sanjeev.jpg" alt="Sanjeev Ghimire">
                        </div>
                    </div>

                    <div class="status-badge">
                        <span class="status-dot"></span>
                        Open to Collaborations
                    </div>

                    <!-- Info card -->
                    <div class="info-card">
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></span>
                            <span class="info-label">Location</span>
                            <span class="info-value">Kathmandu, Nepal</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg></span>
                            <span class="info-label">Email</span>
                            <span class="info-value">sanjeevghimire47@gmail.com</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.6 1.36h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 9a16 16 0 0 0 6 6l.92-.92a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg></span>
                            <span class="info-label">Phone</span>
                            <span class="info-value">+977 98XXXXXXXX</span>
                        </div>
                        <div class="info-row">
                            <span class="info-icon"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/></svg></span>
                            <span class="info-label">Role</span>
                            <span class="info-value">Founder &amp; Collector</span>
                        </div>
                    </div>

                    <!-- Social links -->
                    <div class="social-links">
                        <span class="social-label">Connect with Sanjeev</span>
                        <div class="social-row">

                            <a href="https://www.linkedin.com/in/sanjeev-ghimire-4092ab32a/" class="social-btn social-btn--linkedin" title="LinkedIn" target="_blank" rel="noopener">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 0 1-2.063-2.065 2.064 2.064 0 1 1 2.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                                </svg>
                                LinkedIn
                            </a>

                            <a href="https://www.instagram.com/versesbypablo/" class="social-btn social-btn--ig" title="Instagram" target="_blank" rel="noopener">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838a6.162 6.162 0 1 0 0 12.324 6.162 6.162 0 0 0 0-12.324zM12 16a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm6.406-11.845a1.44 1.44 0 1 0 0 2.881 1.44 1.44 0 0 0 0-2.881z"/>
                                </svg>
                                Instagram
                            </a>

                            <a href="https://www.tiktok.com/@versesbypablo" class="social-btn social-btn--tiktok" title="TikTok" target="_blank" rel="noopener">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 0 1-2.88 2.5 2.89 2.89 0 0 1-2.89-2.89 2.89 2.89 0 0 1 2.89-2.89c.28 0 .54.04.79.1V9.01a6.33 6.33 0 0 0-.79-.05 6.34 6.34 0 0 0-6.34 6.34 6.34 6.34 0 0 0 6.34 6.34 6.34 6.34 0 0 0 6.33-6.34V8.69a8.18 8.18 0 0 0 4.78 1.52V6.75a4.85 4.85 0 0 1-1.01-.06z"/>
                                </svg>
                                TikTok
                            </a>

                            <a href="https://github.com/pablo1747" class="social-btn social-btn--gh" title="GitHub" target="_blank" rel="noopener">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/>
                                </svg>
                                GitHub
                            </a>

                            <a href="mailto:sanjeevghimire47@gmail.com" class="social-btn social-btn--email" title="Email">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="2" y="4" width="20" height="16" rx="2"/>
                                    <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                                </svg>
                                Email
                            </a>

                        </div>
                    </div>

                </div><!-- /portfolio-left -->

                <!-- RIGHT: Info -->
                <div class="portfolio-right">

                    <span class="role-pill">Founder &amp; Collector</span>

                    <h1 class="profile-name">Sanjeev Ghimire</h1>

                    <p class="profile-tagline">
                        "Building Nepal's Premier Diecast Community — One Model at a Time"
                    </p>

                    <p class="profile-bio">
                        Sanjeev Ghimire is the visionary founder of HotWheels Nepal, Nepal's first dedicated
                        diecast and Hot Wheels collectibles store. With over five years of deep passion for
                        miniature car culture, he built a thriving community from the ground up — curating
                        rare models, organising collector meetups, and making world-class diecast collectibles
                        accessible to enthusiasts across Nepal. Sanjeev personally oversees product selection,
                        ensuring every model on the shelf lives up to the HotWheels Nepal standard of quality
                        and authenticity. His mission is to turn every collector's shelf into a story worth telling.
                    </p>

                    <div class="profile-stats">
                        <div class="pstat">
                            <span class="pstat-num">5+</span>
                            <span class="pstat-lbl">Years</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">200+</span>
                            <span class="pstat-lbl">Models Curated</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">5K+</span>
                            <span class="pstat-lbl">Community</span>
                        </div>
                        <div class="pstat-sep"></div>
                        <div class="pstat">
                            <span class="pstat-num">100+</span>
                            <span class="pstat-lbl">Events</span>
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

                </div><!-- /portfolio-right -->

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
                    <span class="skill-tag">Product Curation</span>
                    <span class="skill-tag">Rare Diecast Finds</span>
                    <span class="skill-tag">Community Building</span>
                    <span class="skill-tag">Event Management</span>
                    <span class="skill-tag">Collector Networking</span>
                    <span class="skill-tag">Brand Vision</span>
                    <span class="skill-tag">Limited Editions</span>
                    <span class="skill-tag">Hot Wheels Treasure Hunts</span>
                    <span class="skill-tag">Track Design</span>
                    <span class="skill-tag">Business Development</span>
                </div>
            </div>
        </div>
    </section>

</div><!-- /portfolio-page -->

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

<style>
/* Social links — scoped here to keep owners.css clean */
.social-links {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.7rem;
}
.social-label {
    font-size: 0.68rem;
    font-weight: 700;
    letter-spacing: 2px;
    text-transform: uppercase;
    color: #333;
    text-align: center;
}
.social-row {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    justify-content: center;
}
.social-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.42rem 0.9rem;
    background: rgba(255,255,255,0.04);
    border: 1px solid #1e1e1e;
    border-radius: 7px;
    color: #888;
    text-decoration: none;
    font-size: 0.76rem;
    font-weight: 600;
    letter-spacing: 0.3px;
    transition: all 0.2s;
}
.social-btn:hover {
    background: rgba(255,255,255,0.09);
    color: #fff;
    border-color: #333;
    transform: translateY(-2px);
}
.social-btn--linkedin:hover { border-color: #0A66C2; color: #0A66C2; background: rgba(10,102,194,0.08); }
.social-btn--ig:hover       { border-color: #E1306C; color: #E1306C; background: rgba(225,48,108,0.08); }
.social-btn--tiktok:hover   { border-color: #69C9D0; color: #69C9D0; background: rgba(105,201,208,0.08); }
.social-btn--gh:hover       { border-color: #aaa;    color: #fff;    background: rgba(255,255,255,0.08); }
.social-btn--email:hover    { border-color: #e8001a; color: #e8001a; background: rgba(232,0,26,0.06); }
</style>

</body>
</html>

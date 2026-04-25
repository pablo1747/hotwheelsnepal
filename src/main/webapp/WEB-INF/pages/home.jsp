<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | <%= session.getAttribute("firstName") != null ? "Welcome, " + session.getAttribute("firstName") : "Home" %></title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="home"/>
</jsp:include>

<!-- ===== HERO SLIDER ===== -->
<section class="hero" id="heroSection">

    <%-- Slider: each slide is a full-screen image --%>
    <div class="hero-slider" id="heroSlider">
        <div class="slide active">
            <img src="${pageContext.request.contextPath}/images/hero%20section1.avif"
                 alt="Hot Wheels Nepal Collection">
        </div>
        <div class="slide">
            <img src="${pageContext.request.contextPath}/images/hero%20section%202.avif"
                 alt="Hot Wheels Nepal Racing">
        </div>
    </div>

    <%-- Dark gradient overlay --%>
    <div class="hero-overlay"></div>

    <%-- Text content --%>
    <div class="hero-content">
        <span class="hero-badge"> Nepal's #1 Diecast Store</span>
        <h1>Collect. Race. <span>Display.</span></h1>
        <p class="hero-desc">
            Premium Hot Wheels and diecast cars delivered across Nepal.
            Join thousands of collectors and find your next prized model today.
        </p>
        <div class="hero-actions">
            <a href="<%= request.getContextPath() %>/Shop" class="btn-primary">Shop Now &rarr;</a>
            <a href="<%= request.getContextPath() %>/AboutUs" class="btn-outline">About Us</a>
        </div>
        <div class="hero-stats">
            <div class="stat"><span>5+</span><p>Models</p></div>
            <div class="stat"><span>3+</span><p>Series</p></div>
            <div class="stat"><span>5K+</span><p>Collectors</p></div>
        </div>
    </div>

    <%-- Arrow navigation --%>
    <button class="slider-arrow prev" id="prevBtn" aria-label="Previous slide">&#8249;</button>
    <button class="slider-arrow next" id="nextBtn" aria-label="Next slide">&#8250;</button>

    <%-- Dot indicators --%>
    <div class="slider-dots" id="sliderDots">
        <button class="dot active" aria-label="Slide 1"></button>
        <button class="dot"        aria-label="Slide 2"></button>
    </div>

</section>

<script>
(function () {
    var INTERVAL = 6000;   // ms between auto-advances

    var slides   = document.querySelectorAll('#heroSlider .slide');
    var dots     = document.querySelectorAll('#sliderDots .dot');
    var current  = 0;
    var timer;

    function showSlide(n) {
        slides[current].classList.remove('active');
        dots[current].classList.remove('active');
        current = (n + slides.length) % slides.length;
        slides[current].classList.add('active');
        dots[current].classList.add('active');
    }

    function startTimer() {
        clearInterval(timer);
        timer = setInterval(function () { showSlide(current + 1); }, INTERVAL);
    }

    document.getElementById('nextBtn').addEventListener('click', function () {
        showSlide(current + 1);
        startTimer();
    });

    document.getElementById('prevBtn').addEventListener('click', function () {
        showSlide(current - 1);
        startTimer();
    });

    dots.forEach(function (dot, i) {
        dot.addEventListener('click', function () {
            showSlide(i);
            startTimer();
        });
    });

    // Pause on hover
    var hero = document.getElementById('heroSection');
    hero.addEventListener('mouseenter', function () { clearInterval(timer); });
    hero.addEventListener('mouseleave', function () { startTimer(); });

    // Kick off
    startTimer();
})();
</script>

<!-- ===== FEATURED CARS ===== -->
<section class="section">
    <h2>Featured Cars</h2>
    <p class="section-sub">Hand-picked favourites from our collection</p>
    <div class="products">
        <c:choose>
            <c:when test="${empty featuredProducts}">
                <p style="color:#888;text-align:center;padding:2rem 0;width:100%;">
                    No products available yet. Check back soon!
                </p>
            </c:when>
            <c:otherwise>
                <c:forEach var="p" items="${featuredProducts}" varStatus="st">
                    <%-- Use uploaded product image if available, else cycle through fallbacks --%>
                    <c:choose>
                        <c:when test="${not empty p.imageName}">
                            <c:set var="imgSrc" value="${pageContext.request.contextPath}/images/products/${p.imageName}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="idx" value="${st.index % 6}"/>
                            <c:choose>
                                <c:when test="${idx == 0}"><c:set var="fb" value="gtr.jpg"/></c:when>
                                <c:when test="${idx == 1}"><c:set var="fb" value="hw.jpg"/></c:when>
                                <c:when test="${idx == 2}"><c:set var="fb" value="img2.jpeg"/></c:when>
                                <c:when test="${idx == 3}"><c:set var="fb" value="img3.jpeg"/></c:when>
                                <c:when test="${idx == 4}"><c:set var="fb" value="img4.jpeg"/></c:when>
                                <c:otherwise><c:set var="fb" value="img1.jpg"/></c:otherwise>
                            </c:choose>
                            <c:set var="imgSrc" value="${pageContext.request.contextPath}/images/${fb}"/>
                        </c:otherwise>
                    </c:choose>

                    <div class="product-card">
                        <img src="${imgSrc}" alt="<c:out value="${p.name}"/>">
                        <h3><c:out value="${p.name}"/></h3>
                        <p><c:out value="${p.description}"/></p>
                        <c:choose>
                            <c:when test="${p.stock > 0}">
                                <form action="${pageContext.request.contextPath}/Cart" method="post">
                                    <input type="hidden" name="id"    value="<c:out value="${p.productId}"/>">
                                    <input type="hidden" name="name"  value="<c:out value="${p.name}"/>">
                                    <input type="hidden" name="price" value="<c:out value="${p.price}"/>">
                                    <button type="submit" class="add-to-cart-btn">
                                        Add to Cart &mdash; Rs.<c:out value="${p.price}"/>
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <button class="add-to-cart-btn" disabled style="opacity:0.5;cursor:not-allowed;">
                                    Sold Out
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- ===== SERVICES ===== -->
<section class="section services">
    <h2>Our Services</h2>
    <p class="section-sub">More than just a store — a full collector experience</p>
    <div class="products">

        <div class="product-card">
            <h3>Custom Track Design</h3>
            <p>Create your dream Hot Wheels track layout with expert guidance and premium components.</p>
            <a href="${pageContext.request.contextPath}/ContactUs" class="contact-link">Contact Us &rarr;</a>
        </div>

        <div class="product-card">
            <h3>Collector Consultation</h3>
            <p>Expert advice on rare models, limited editions, and exclusive series releases.</p>
            <a href="${pageContext.request.contextPath}/ContactUs" class="contact-link">Contact Us &rarr;</a>
        </div>

        <div class="product-card">
            <h3>Warranty &amp; Replacement</h3>
            <p>Keep your collection in perfect condition with our warranty-backed replacement programme.</p>
            <a href="${pageContext.request.contextPath}/ContactUs" class="contact-link">Contact Us &rarr;</a>
        </div>

        <div class="product-card">
            <h3>Free Nationwide Delivery</h3>
            <p>Orders above Rs.1000 ship free anywhere in Nepal — delivered in 3–5 business days.</p>
            <a href="${pageContext.request.contextPath}/Shop" class="contact-link">Shop Now &rarr;</a>
        </div>

        <div class="product-card">
            <h3>Community Events</h3>
            <p>Join our monthly collector meetups and racing events across Kathmandu and Pokhara.</p>
            <a href="${pageContext.request.contextPath}/ContactUs" class="contact-link">Learn More &rarr;</a>
        </div>

    </div>
</section>

<!-- ===== ABOUT BLURB ===== -->
<section class="section about">
    <h2>About HotWheels Nepal</h2>
    <p>
        HotWheels Nepal is your ultimate destination for Hot Wheels and diecast enthusiasts.
        From rare collectibles to custom tracks, we bring speed, style, and excitement
        to every collector's shelf and play area. Join our community of passionate collectors today.
    </p>
</section>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Shop</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/shop.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="shop"/>
</jsp:include>

<%-- ===== HERO ===== --%>
<section class="shop-hero">
    <div class="shop-hero-inner">
        <span class="hero-eyebrow">Premium Diecast Collection</span>
        <h1>Find Your Next <span>Hot Wheels</span></h1>
        <p>Rare models, exclusive series and limited editions — delivered across Nepal</p>
    </div>
    <div class="hero-speed-lines"></div>
</section>

<%-- ===== TOOLBAR ===== --%>
<div class="shop-toolbar">
    <div class="toolbar-left">
        <c:choose>
            <c:when test="${not empty searchQuery}">
                <span class="toolbar-title">Results for &ldquo;<%= request.getAttribute("searchQuery") %>&rdquo;</span>
                <a href="<%= request.getContextPath() %>/Shop" class="clear-search">&larr; All Cars</a>
            </c:when>
            <c:otherwise>
                <span class="toolbar-title">All Cars</span>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="toolbar-right">
        <c:set var="productCount" value="0"/>
        <c:forEach var="x" items="${products}"><c:set var="productCount" value="${productCount + 1}"/></c:forEach>
        <span class="product-count">${productCount} items</span>

        <form method="get" action="<%= request.getContextPath() %>/Shop" class="sort-form">
            <c:if test="${not empty searchQuery}">
                <input type="hidden" name="q" value="${searchQuery}">
            </c:if>
            <label for="sort-select" class="sort-label">Sort by:</label>
            <select id="sort-select" name="sort" class="sort-select" onchange="this.form.submit()">
                <option value="" ${empty sortOrder ? 'selected' : ''}>Default</option>
                <option value="price_asc"  ${'price_asc'  eq sortOrder ? 'selected' : ''}>Price: Low to High</option>
                <option value="price_desc" ${'price_desc' eq sortOrder ? 'selected' : ''}>Price: High to Low</option>
            </select>
        </form>
    </div>
</div>

<%-- ===== PRODUCT GRID ===== --%>
<section class="products-section">
    <c:choose>
        <c:when test="${empty products}">
            <div class="empty-state">
                <div class="empty-icon">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                </div>
                <h3>No cars found</h3>
                <p>Try a different search or browse all cars.</p>
                <a href="${pageContext.request.contextPath}/Shop" class="btn-browse">Browse All</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="products">
                <c:forEach var="p" items="${products}" varStatus="st">
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

                    <div class="product-card <c:if test="${p.stock == 0}">card-oos</c:if>">

                        <%-- Image area --%>
                        <div class="card-img-wrap">
                            <img src="${imgSrc}" alt="<c:out value="${p.name}"/>">

                            <%-- Badges --%>
                            <div class="card-badges">
                                <c:if test="${not empty p.series}">
                                    <span class="badge-series"><c:out value="${p.series}"/></span>
                                </c:if>
                                <c:choose>
                                    <c:when test="${p.stock == 0}">
                                        <span class="badge-oos">Sold Out</span>
                                    </c:when>
                                    <c:when test="${p.stock <= 5}">
                                        <span class="badge-low">Only <c:out value="${p.stock}"/> left</span>
                                    </c:when>
                                </c:choose>
                            </div>

                            <%-- Hover overlay with quick-add --%>
                            <c:if test="${p.stock > 0}">
                                <div class="card-overlay">
                                    <form action="${pageContext.request.contextPath}/Cart" method="post">
                                        <input type="hidden" name="id"    value="<c:out value="${p.productId}"/>">
                                        <input type="hidden" name="name"  value="<c:out value="${p.name}"/>">
                                        <input type="hidden" name="price" value="<c:out value="${p.price}"/>">
                                        <button type="submit" class="btn-quick-add">+ Quick Add</button>
                                    </form>
                                </div>
                            </c:if>
                        </div>

                        <%-- Card body --%>
                        <div class="card-body">
                            <h3><c:out value="${p.name}"/></h3>
                            <p class="card-desc"><c:out value="${p.description}"/></p>

                            <div class="card-footer">
                                <div class="price-block">
                                    <span class="price-label">Price</span>
                                    <span class="price">Rs. <c:out value="${p.price}"/></span>
                                </div>
                                <c:choose>
                                    <c:when test="${p.stock > 0}">
                                        <form action="${pageContext.request.contextPath}/Cart" method="post">
                                            <input type="hidden" name="id"    value="<c:out value="${p.productId}"/>">
                                            <input type="hidden" name="name"  value="<c:out value="${p.name}"/>">
                                            <input type="hidden" name="price" value="<c:out value="${p.price}"/>">
                                            <button type="submit" class="btn-cart">Add to Cart</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-cart btn-cart--disabled" disabled>Sold Out</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

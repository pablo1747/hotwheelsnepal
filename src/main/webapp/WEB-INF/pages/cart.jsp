<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Cart</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/cart.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="cart"/>
</jsp:include>

<section class="about-hero">
    <h1>Your Cart</h1>
</section>

<section class="section">
    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="empty-state">
                <div class="empty-icon"></div>
                <h2>Your cart is empty</h2>
                <p>Add some Hot Wheels to get started!</p>
                <a href="<%= request.getContextPath() %>/Shop">
                    <button class="cart-btn">Browse Shop</button>
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <%-- Compute totals --%>
            <c:set var="subtotal" value="0"/>
            <c:forEach var="item" items="${cartItems}">
                <c:set var="subtotal" value="${subtotal + item.subtotal}"/>
            </c:forEach>
            <c:set var="shipping" value="${subtotal >= 1000 ? 0 : 100}"/>
            <c:set var="vat" value="${subtotal * 13 / 100}"/>
            <c:set var="grandTotal" value="${subtotal + shipping + vat}"/>

            <div class="cart-layout">

                <%-- ===== LEFT: ITEMS TABLE ===== --%>
                <div class="cart-items">
                    <div class="cart-section-head">
                        <h3>Cart Items</h3>
                        <span class="item-count"><c:forEach var="x" items="${cartItems}" varStatus="s"/><%= request.getAttribute("cartItems") != null ? ((java.util.List)request.getAttribute("cartItems")).size() : 0 %> item(s)</span>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Price</th>
                                <th>Qty</th>
                                <th>Subtotal</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cartItems}">
                                <tr>
                                    <td class="product-name"><c:out value="${item.name}"/></td>
                                    <td>Rs. <c:out value="${item.price}"/></td>
                                    <td><span class="qty-badge"><c:out value="${item.quantity}"/></span></td>
                                    <td class="subtotal-cell">Rs. <c:out value="${item.subtotal}"/></td>
                                    <td>
                                        <form action="<%= request.getContextPath() %>/Cart" method="get">
                                            <input type="hidden" name="removeId" value="${item.id}"/>
                                            <button class="remove-btn" title="Remove">&#10005;</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="cart-actions">
                        <a href="<%= request.getContextPath() %>/Shop" class="btn-continue">&larr; Continue Shopping</a>
                    </div>
                </div>

                <%-- ===== RIGHT: BILLING PANEL ===== --%>
                <div class="billing-panel">
                    <h3 class="billing-title">Order Summary</h3>

                    <div class="billing-rows">
                        <div class="billing-row">
                            <span>Subtotal</span>
                            <span>Rs. <c:out value="${subtotal}"/></span>
                        </div>
                        <div class="billing-row">
                            <span>Shipping</span>
                            <span>
                                <c:choose>
                                    <c:when test="${shipping == 0}">
                                        <span class="free-tag">FREE</span>
                                    </c:when>
                                    <c:otherwise>Rs. <c:out value="${shipping}"/></c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="billing-row">
                            <span>VAT (13%)</span>
                            <span>Rs. <c:out value="${vat}"/></span>
                        </div>
                        <c:if test="${shipping > 0}">
                            <div class="free-shipping-note">
                                Add Rs. <c:out value="${1000 - subtotal}"/> more for free shipping
                            </div>
                        </c:if>
                    </div>

                    <div class="billing-divider"></div>

                    <div class="billing-total">
                        <span>Total</span>
                        <span class="grand-total">Rs. <c:out value="${grandTotal}"/></span>
                    </div>

                    <%-- Promo code --%>
                    <div class="promo-wrap">
                        <input type="text" class="promo-input" placeholder="Promo code">
                        <button class="promo-btn">Apply</button>
                    </div>

                    <%-- Checkout button --%>
                    <a href="<%= request.getContextPath() %>/Checkout" class="checkout-btn">
                        Proceed to Checkout &rarr;
                    </a>

                    <p class="billing-note">
                        Secure checkout &bull; Free returns &bull; Nepal-wide delivery
                    </p>
                </div>

            </div>
        </c:otherwise>
    </c:choose>
</section>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

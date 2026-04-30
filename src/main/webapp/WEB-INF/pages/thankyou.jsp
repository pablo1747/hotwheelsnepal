<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Order Confirmed</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/thankyou.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value=""/>
</jsp:include>

<section class="ty-section">

    <div class="ty-card">
        <div class="ty-icon">&#10003;</div>
        <h1 class="ty-heading">Thank You, <%= session.getAttribute("firstName") %>!</h1>
        <p class="ty-sub">Your order has been placed successfully.</p>

        <div class="order-ref">
            <span class="ref-label">Order Reference</span>
            <span class="ref-value"><%= request.getAttribute("orderRef") %></span>
        </div>

        <div class="payment-badge">
            Paid via &nbsp;<strong><%= request.getAttribute("paymentMethod") %></strong>
        </div>

        <%-- Order items --%>
        <div class="order-items">
            <h3 class="items-heading">Items Ordered</h3>
            <c:set var="subtotal" value="0"/>
            <c:forEach var="item" items="${cartItems}">
                <div class="order-item-row">
                    <span class="oi-name"><c:out value="${item.name}"/></span>
                    <span class="oi-qty">x<c:out value="${item.quantity}"/></span>
                    <span class="oi-price">Rs. <c:out value="${item.subtotal}"/></span>
                </div>
                <c:set var="subtotal" value="${subtotal + item.subtotal}"/>
            </c:forEach>
        </div>

        <%-- Totals summary --%>
        <div class="order-summary">
            <div class="os-row">
                <span>Subtotal</span>
                <span>Rs. <%= request.getAttribute("subtotal") %></span>
            </div>
            <div class="os-row">
                <span>Shipping</span>
                <span>
                    <c:choose>
                        <c:when test="${shipping == 0}"><span class="free-tag">FREE</span></c:when>
                        <c:otherwise>Rs. <c:out value="${shipping}"/></c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="os-row">
                <span>VAT (13%)</span>
                <span>Rs. <%= String.format("%.2f", (Double)request.getAttribute("vat")) %></span>
            </div>
            <div class="os-divider"></div>
            <div class="os-row os-total">
                <span>Grand Total</span>
                <span class="total-val">Rs. <%= String.format("%.2f", (Double)request.getAttribute("grandTotal")) %></span>
            </div>
        </div>

        <p class="delivery-note">
            Your Hot Wheels will be delivered within <strong>3–5 business days</strong>.
            A confirmation will be sent to <strong><%= session.getAttribute("email") %></strong>.
        </p>

        <div class="ty-actions">
            <a href="<%= request.getContextPath() %>/Shop" class="btn-shop">Continue Shopping</a>
            <a href="<%= request.getContextPath() %>/Home" class="btn-home">Go to Home</a>
        </div>
    </div>

</section>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

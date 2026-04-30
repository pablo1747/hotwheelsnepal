<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Checkout</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/checkout.css">
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="cart"/>
</jsp:include>

<section class="checkout-hero">
    <h1>Checkout</h1>
    <p>Almost there, <%= session.getAttribute("firstName") %>!</p>
</section>

<%-- Compute totals --%>
<c:set var="subtotal" value="0"/>
<c:forEach var="item" items="${cartItems}">
    <c:set var="subtotal" value="${subtotal + item.subtotal}"/>
</c:forEach>
<c:set var="shipping"   value="${subtotal >= 1000 ? 0 : 100}"/>
<c:set var="vat"        value="${subtotal * 13 / 100}"/>
<c:set var="grandTotal" value="${subtotal + shipping + vat}"/>

<section class="checkout-section">
<form action="<%= request.getContextPath() %>/Checkout" method="post" class="checkout-form" id="checkoutForm">

    <div class="checkout-layout">

        <%-- ===== LEFT: DELIVERY + PAYMENT ===== --%>
        <div class="checkout-left">

            <%-- Delivery Details --%>
            <div class="checkout-card">
                <h3 class="card-title">
                    <span class="step-num">1</span> Delivery Details
                </h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="deliveryName"
                               value="<%= session.getAttribute("firstName") %> <%= session.getAttribute("lastName") %>"
                               placeholder="Full name" required>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="deliveryPhone"
                               value="<%= session.getAttribute("phone") != null ? session.getAttribute("phone") : "" %>"
                               placeholder="+977 98XXXXXXXX" required>
                    </div>
                    <div class="form-group full-width">
                        <label>Delivery Address</label>
                        <input type="text" name="deliveryAddress" placeholder="Street, Area, City" required>
                    </div>
                    <div class="form-group">
                        <label>City</label>
                        <input type="text" name="deliveryCity" placeholder="e.g. Kathmandu" required>
                    </div>
                    <div class="form-group">
                        <label>Postal Code</label>
                        <input type="text" name="postalCode" placeholder="e.g. 44600">
                    </div>
                </div>
            </div>

            <%-- Payment Method --%>
            <div class="checkout-card">
                <h3 class="card-title">
                    <span class="step-num">2</span> Payment Method
                </h3>
                <div class="payment-options">

                    <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="Cash on Delivery" checked>
                        <div class="option-content">
                            <div class="option-icon">
                                <img src="<%= request.getContextPath() %>/images/cash on delivery.jpg" alt="Cash on Delivery">
                            </div>
                            <div class="option-text">
                                <strong>Cash on Delivery</strong>
                                <span>Pay when your order arrives</span>
                            </div>
                            <div class="option-check">&#10003;</div>
                        </div>
                    </label>

                    <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="eSewa">
                        <div class="option-content">
                            <div class="option-icon">
                                <img src="<%= request.getContextPath() %>/images/esewa.png" alt="eSewa">
                            </div>
                            <div class="option-text">
                                <strong>eSewa</strong>
                                <span>Pay securely via eSewa wallet</span>
                            </div>
                            <div class="option-check">&#10003;</div>
                        </div>
                    </label>

                    <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="Khalti">
                        <div class="option-content">
                            <div class="option-icon">
                                <img src="<%= request.getContextPath() %>/images/khalti.png" alt="Khalti">
                            </div>
                            <div class="option-text">
                                <strong>Khalti</strong>
                                <span>Pay securely via Khalti wallet</span>
                            </div>
                            <div class="option-check">&#10003;</div>
                        </div>
                    </label>

                    <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="Card Payment">
                        <div class="option-content">
                            <div class="option-icon">
                                <img src="<%= request.getContextPath() %>/images/card.png" alt="Card Payment">
                            </div>
                            <div class="option-text">
                                <strong>Card Payment</strong>
                                <span>Credit / Debit card</span>
                            </div>
                            <div class="option-check">&#10003;</div>
                        </div>
                    </label>

                </div>
            </div>

        </div>

        <%-- ===== RIGHT: ORDER SUMMARY ===== --%>
        <div class="checkout-right">
            <div class="summary-card">
                <h3 class="card-title">Order Summary</h3>

                <div class="summary-items">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="summary-item">
                            <span class="si-name"><c:out value="${item.name}"/></span>
                            <span class="si-qty">x<c:out value="${item.quantity}"/></span>
                            <span class="si-price">Rs. <c:out value="${item.subtotal}"/></span>
                        </div>
                    </c:forEach>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-rows">
                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span>Rs. <c:out value="${subtotal}"/></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span>
                            <c:choose>
                                <c:when test="${shipping == 0}"><span class="free-tag">FREE</span></c:when>
                                <c:otherwise>Rs. <c:out value="${shipping}"/></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="summary-row">
                        <span>VAT (13%)</span>
                        <span>Rs. <c:out value="${vat}"/></span>
                    </div>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-total">
                    <span>Total</span>
                    <span class="total-amount">Rs. <c:out value="${grandTotal}"/></span>
                </div>

                <button type="submit" class="btn-confirm">Confirm &amp; Pay &rarr;</button>

                <a href="<%= request.getContextPath() %>/Cart" class="btn-back-cart">&larr; Back to Cart</a>
            </div>
        </div>

    </div>
</form>
</section>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

<script>
(function () {
    var options = document.querySelectorAll('.payment-option');
    options.forEach(function (label) {
        var radio = label.querySelector('input[type="radio"]');
        if (radio.checked) label.classList.add('selected');
        label.addEventListener('click', function () {
            options.forEach(function (l) { l.classList.remove('selected'); });
            label.classList.add('selected');
        });
    });
})();
</script>
</body>
</html>

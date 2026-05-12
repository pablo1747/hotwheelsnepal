<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" errorPage="/WEB-INF/pages/error.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Contact Us</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/aboutus.css">
<style>
    .contact-form-wrap { max-width: 640px; margin: 0 auto; }
    .contact-info { display: flex; gap: 1.5rem; flex-wrap: wrap; margin-bottom: 2.5rem; }
    .info-card {
        flex: 1; min-width: 170px;
        background: #111; border: 1px solid #2a0000; border-radius: 10px;
        padding: 1.2rem 1.4rem;
    }
    .info-card .label { font-size: 0.72rem; text-transform: uppercase; letter-spacing: 1px; color: #555; font-weight: 700; margin-bottom: 0.3rem; }
    .info-card .value { color: #ccc; font-size: 0.92rem; }

    .contact-form { display: flex; flex-direction: column; gap: 1rem; }
    .contact-form input,
    .contact-form textarea {
        width: 100%; padding: 0.75rem 1rem;
        background: #0f0f0f; border: 1px solid #2a0000; border-radius: 7px;
        color: #fff; font-family: 'Inter', sans-serif; font-size: 0.9rem;
        outline: none; transition: border-color 0.2s;
    }
    .contact-form input:focus,
    .contact-form textarea:focus { border-color: #e8001a; }
    .contact-form input::placeholder,
    .contact-form textarea::placeholder { color: #444; }
    .contact-form textarea { resize: vertical; min-height: 130px; }
    .contact-form button {
        padding: 0.85rem 2rem; background: #e8001a; border: none; border-radius: 7px;
        color: #fff; font-family: 'Inter', sans-serif; font-size: 0.95rem; font-weight: 700;
        cursor: pointer; align-self: flex-start; transition: all 0.25s;
        box-shadow: 0 6px 20px rgba(232,0,26,0.3);
    }
    .contact-form button:hover { background: #ff2233; transform: translateY(-1px); }
    .form-title {
        font-family: 'Rajdhani', sans-serif; font-size: 1.5rem; font-weight: 700;
        color: #fff; padding-left: 1rem; border-left: 3px solid #e8001a;
        margin-bottom: 1.2rem;
    }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value="contact"/>
</jsp:include>

<section class="about-hero">
    <h1>Contact Us</h1>
    <p>We'd love to hear from you </p>
</section>

<section class="section">
    <div class="contact-form-wrap">

        <div class="contact-info">
            <div class="info-card">
                <div class="label">Email</div>
                <div class="value">hotwheels\@gmail.com</div>
            </div>
            <div class="info-card">
                <div class="label">Phone</div>
                <div class="value">+977-9800000000</div>
            </div>
            <div class="info-card">
                <div class="label">Location</div>
                <div class="value">Kathmandu, Nepal</div>
            </div>
        </div>

        <p class="form-title">Send a Message</p>

        <form action="<%= request.getContextPath() %>/ContactUs" method="post" class="contact-form">
            <input type="text"  name="name"    placeholder="Your Name"    required>
            <input type="email" name="email"   placeholder="Your Email"   required>
            <input type="text"  name="subject" placeholder="Subject">
            <textarea           name="message" placeholder="Your Message"></textarea>
            <button type="submit">Send Message &rarr;</button>
        </form>

    </div>
</section>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

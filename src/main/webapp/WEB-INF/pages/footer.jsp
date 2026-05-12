<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.Calendar" %>
<style>
/* Sticky footer: pushes footer to bottom on short pages */
body { display: flex !important; flex-direction: column !important; min-height: 100vh !important; }
footer { margin-top: auto; }
</style>
<footer>
    <div class="footer-inner">
        <div class="footer-brand">
            <span class="footer-logo">HotWheels Nepal</span>
            <p class="footer-tagline">Nepal's #1 Diecast &amp; Hot Wheels Store</p>
        </div>
        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/Home">Home</a>
            <a href="${pageContext.request.contextPath}/Shop">Shop</a>
            <a href="${pageContext.request.contextPath}/AboutUs">About Us</a>
            <a href="${pageContext.request.contextPath}/ContactUs">Contact Us</a>
        </div>
        <p class="footer-copy">&copy; <%= Calendar.getInstance().get(Calendar.YEAR) %> HotWheels Nepal. All rights reserved.</p>
    </div>
</footer>
<style>
footer {
    background: #080808;
    border-top: 2px solid #2a0000;
    padding: 2.5rem 5% 1.8rem;
    color: #555;
    font-size: 0.85rem;
}
.footer-inner {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.2rem;
    text-align: center;
}
.footer-brand { display: flex; flex-direction: column; align-items: center; gap: 0.3rem; }
.footer-logo {
    font-family: 'Rajdhani', sans-serif;
    font-size: 1.4rem;
    font-weight: 700;
    color: #e8001a;
    letter-spacing: 3px;
    text-transform: uppercase;
}
.footer-tagline { color: #444; font-size: 0.8rem; letter-spacing: 0.5px; }
.footer-links {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 0.3rem;
}
.footer-links a {
    color: #666;
    text-decoration: none;
    font-size: 0.82rem;
    font-weight: 500;
    padding: 0.3rem 0.7rem;
    border-radius: 4px;
    transition: color 0.2s, background 0.2s;
}
.footer-links a:hover { color: #fff; background: rgba(232,0,26,0.12); }
.footer-copy { color: #333; font-size: 0.78rem; }
</style>

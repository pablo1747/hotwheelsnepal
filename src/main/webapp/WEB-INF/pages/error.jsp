<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HotWheels Nepal | Error</title>
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }

.err-main {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #0a0a0a;
    padding: 3rem 1.5rem;
}

.err-card {
    text-align: center;
    max-width: 520px;
    width: 100%;
}

.err-code {
    font-family: 'Rajdhani', sans-serif;
    font-size: 7rem;
    font-weight: 700;
    color: #e8001a;
    line-height: 1;
    margin-bottom: 0.5rem;
}

.err-divider {
    width: 40px;
    height: 2px;
    background: #e8001a;
    margin: 1rem auto 1.2rem;
    border-radius: 2px;
}

.err-title {
    font-family: 'Rajdhani', sans-serif;
    font-size: 1.8rem;
    font-weight: 700;
    color: #fff;
    margin-bottom: 0.8rem;
}

.err-subtitle {
    color: #666;
    font-size: 0.9rem;
    line-height: 1.7;
    margin-bottom: 2rem;
}

.err-log {
    background: #0d0d0d;
    border: 1px solid #1e1e1e;
    border-left: 3px solid #e8001a;
    border-radius: 6px;
    padding: 0.9rem 1rem;
    margin-bottom: 1.8rem;
    text-align: left;
}
.err-log-label {
    display: block;
    font-size: 0.65rem;
    font-weight: 700;
    letter-spacing: 2px;
    text-transform: uppercase;
    color: #e8001a;
    margin-bottom: 0.4rem;
}
.err-log-text {
    font-family: 'Courier New', monospace;
    font-size: 0.78rem;
    color: #555;
    word-break: break-all;
    line-height: 1.6;
}

.err-actions {
    display: flex;
    justify-content: center;
    gap: 0.8rem;
    flex-wrap: wrap;
}
.btn-err {
    display: inline-block;
    padding: 0.7rem 1.6rem;
    border-radius: 6px;
    font-family: 'Inter', sans-serif;
    font-size: 0.85rem;
    font-weight: 600;
    text-decoration: none;
    cursor: pointer;
    border: none;
    transition: background 0.2s, color 0.2s;
}
.btn-err-primary { background: #e8001a; color: #fff; }
.btn-err-primary:hover { background: #ff1a2e; }
.btn-err-ghost {
    background: transparent;
    color: #888;
    border: 1px solid #2a2a2a;
}
.btn-err-ghost:hover { color: #fff; border-color: #444; }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/pages/header.jsp">
    <jsp:param name="activePage" value=""/>
</jsp:include>

<%
    Integer _code = (Integer) request.getAttribute("errorStatusCode");
    if (_code == null && response.getStatus() != 200) _code = response.getStatus();
    if (_code == null) _code = 500;
    boolean _is404 = (_code == 404);
    String _msg = (String) request.getAttribute("errorMessage");
    if (_msg == null || _msg.isEmpty()) {
        Throwable _ex = (Throwable) request.getAttribute("errorException");
        if (_ex == null) _ex = exception;
        if (_ex != null) _msg = _ex.getMessage();
    }
%>

<main class="err-main">
    <div class="err-card">
        <div class="err-code"><%= _code %></div>

        <div class="err-divider"></div>

        <h1 class="err-title"><%= _is404 ? "Page Not Found" : "Something Went Wrong" %></h1>

        <p class="err-subtitle">
            <%= _is404
                ? "The page you are looking for does not exist or has been moved."
                : "An unexpected error occurred. Please try again or return to the home page." %>
        </p>

        <% if (_msg != null && !_msg.isEmpty()) { %>
        <div class="err-log">
            <span class="err-log-label">Error Detail</span>
            <p class="err-log-text"><%= _msg %></p>
        </div>
        <% } %>

        <div class="err-actions">
            <button onclick="history.back()" class="btn-err btn-err-ghost">Go Back</button>
            <a href="${pageContext.request.contextPath}/Home" class="btn-err btn-err-primary">Back to Home</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/pages/footer.jsp">
    <jsp:param name="year" value="2026"/>
</jsp:include>

</body>
</html>

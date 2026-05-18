<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap">
<style>
/* ===== GLOBAL HEADER STYLES (self-contained so any page gets them) ===== */
:root {
    --red:      #e8001a;
    --red-dark: #b30000;
    --bg:       #0a0a0a;
}

header {
    background: rgba(10,10,10,0.97);
    border-bottom: 2px solid var(--red);
    padding: 0 5%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 70px;
    position: sticky;
    top: 0;
    z-index: 1000;
    backdrop-filter: blur(10px);
    font-family: 'Inter', sans-serif;
}

header h1 {
    font-family: 'Rajdhani', sans-serif;
    font-size: 1.7rem;
    font-weight: 700;
    color: var(--red);
    letter-spacing: 3px;
    text-transform: uppercase;
    margin: 0;
}

header nav {
    display: flex;
    align-items: center;
    gap: 0.2rem;
}

header nav a {
    color: #bbb;
    text-decoration: none;
    font-weight: 600;
    font-size: 0.88rem;
    padding: 0.45rem 0.9rem;
    border-radius: 5px;
    transition: all 0.2s;
    letter-spacing: 0.4px;
}

header nav a:hover {
    color: #fff;
    background: rgba(232,0,26,0.15);
}

header nav a.nav-cta {
    background: var(--red);
    color: #fff;
    margin-left: 0.3rem;
}

header nav a.nav-cta:hover { background: #ff2233; }

/* ===== NAV SEARCH ICON ===== */
.nav-icon-btn {
    background: transparent;
    border: none;
    color: #bbb;
    cursor: pointer;
    width: 36px; height: 36px;
    border-radius: 6px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.05rem;
    transition: all 0.2s;
    padding: 0;
    margin-left: 0.3rem;
}
.nav-icon-btn:hover  { color: #fff; background: rgba(232,0,26,0.15); }
.nav-icon-btn.active { color: #e8001a; background: rgba(232,0,26,0.12); }

/* ===== SEARCH OVERLAY (drops below header) ===== */
.search-overlay {
    position: fixed;
    top: 70px; left: 0; right: 0;
    background: rgba(8,8,8,0.98);
    border-bottom: 2px solid #e8001a;
    padding: 0 5%;
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.3s ease, padding 0.3s ease;
    z-index: 998;
    backdrop-filter: blur(12px);
}
.search-overlay.open {
    max-height: 80px;
    padding: 1rem 5%;
}
.search-overlay-form {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    max-width: 720px;
    margin: 0 auto;
}
.search-overlay-form input[type="text"] {
    flex: 1;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(232,0,26,0.35);
    color: #fff;
    padding: 0.6rem 1.1rem;
    font-size: 0.95rem;
    border-radius: 6px;
    outline: none;
    font-family: 'Inter', sans-serif;
    transition: border-color 0.2s;
}
.search-overlay-form input[type="text"]:focus { border-color: #e8001a; }
.search-overlay-form input[type="text"]::placeholder { color: #444; }
.search-overlay-form .btn-search-go {
    background: #e8001a;
    border: none;
    color: #fff;
    padding: 0.6rem 1.5rem;
    border-radius: 6px;
    font-weight: 700;
    font-size: 0.9rem;
    cursor: pointer;
    font-family: 'Inter', sans-serif;
    transition: background 0.2s;
}
.search-overlay-form .btn-search-go:hover { background: #ff2233; }
.search-overlay-form .btn-close-search {
    background: transparent;
    border: 1px solid #333;
    color: #888;
    width: 34px; height: 34px;
    border-radius: 50%;
    font-size: 1.2rem;
    cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    line-height: 1;
    transition: all 0.2s;
    padding: 0;
}
.search-overlay-form .btn-close-search:hover { border-color: #e8001a; color: #fff; }

/* ===== PROFILE AVATAR + DROPDOWN ===== */
.nav-profile-wrap {
    position: relative;
    margin-left: 0.3rem;
}
.nav-avatar-btn {
    width: 34px; height: 34px;
    border-radius: 50%;
    background: linear-gradient(135deg, #9e0012, #e8001a);
    border: 2px solid rgba(232,0,26,0.45);
    color: #fff;
    font-size: 0.88rem;
    font-weight: 700;
    cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    font-family: 'Rajdhani', sans-serif;
    letter-spacing: 0;
    transition: all 0.2s;
    padding: 0;
}
.nav-avatar-btn:hover {
    border-color: #e8001a;
    box-shadow: 0 0 0 3px rgba(232,0,26,0.22);
    transform: scale(1.08);
}
.profile-dropdown {
    position: absolute;
    top: calc(100% + 10px);
    right: 0;
    background: #111;
    border: 1px solid #2a0000;
    border-radius: 10px;
    min-width: 190px;
    box-shadow: 0 16px 40px rgba(0,0,0,0.7);
    opacity: 0;
    visibility: hidden;
    transform: translateY(-8px);
    transition: opacity 0.2s ease, transform 0.2s ease, visibility 0.2s;
    z-index: 2000;
    overflow: hidden;
}
.profile-dropdown.open {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}
.dropdown-user {
    padding: 0.9rem 1rem 0.75rem;
    border-bottom: 1px solid #1e1e1e;
}
.dropdown-name  { display: block; font-weight: 700; font-size: 0.9rem; color: #fff; }
.dropdown-uname { display: block; font-size: 0.72rem; color: #555; margin-top: 2px; }
.dropdown-link {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.65rem 1rem;
    color: #aaa;
    text-decoration: none;
    font-size: 0.85rem;
    font-weight: 500;
    transition: background 0.15s, color 0.15s;
}
.dropdown-link:hover { background: #1a1a1a; color: #fff; }
.dropdown-link.logout { color: #ff4444; border-top: 1px solid #1e1e1e; }
.dropdown-link.logout:hover { background: rgba(232,0,26,0.08); color: #ff2233; }

/* ===== ACTIVE NAV LINK ===== */
.nav-active {
    color: #fff !important;
    background: rgba(232,0,26,0.15) !important;
    border-bottom: 2px solid #e8001a;
}
</style>

<header>
    <h1>HotWheels Nepal</h1>
    <nav>
        <%-- jsp:param activePage is used to highlight the current page link --%>
        <a href="${pageContext.request.contextPath}/Home"
           class="${param.activePage == 'home' ? 'nav-active' : ''}">Home</a>
        <a href="${pageContext.request.contextPath}/Shop"
           class="${param.activePage == 'shop' ? 'nav-active' : ''}">Shop</a>
        <a href="${pageContext.request.contextPath}/AboutUs"
           class="${param.activePage == 'about' ? 'nav-active' : ''}">About Us</a>
        <a href="${pageContext.request.contextPath}/ContactUs"
           class="${param.activePage == 'contact' ? 'nav-active' : ''}">Contact Us</a>
        <a href="${pageContext.request.contextPath}/Cart"
           class="${param.activePage == 'cart' ? 'nav-active' : ''}">Cart</a>

        <%-- Search icon --%>
        <button class="nav-icon-btn" id="searchToggle" aria-label="Search">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
        </button>

        <%-- Profile or Login --%>
        <c:choose>
            <c:when test="${not empty sessionScope.username}">
                <div class="nav-profile-wrap">
                    <button class="nav-avatar-btn" id="profileToggle" aria-label="Account menu">
                        <% if (session.getAttribute("imagePath") != null && !session.getAttribute("imagePath").toString().isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/<%= session.getAttribute("imagePath") %>"
                                 alt="avatar" style="width:100%;height:100%;object-fit:cover;border-radius:50%;">
                        <% } else { %>
                            <%= session.getAttribute("firstName") != null ? ((String)session.getAttribute("firstName")).substring(0,1).toUpperCase() : "?" %>
                        <% } %>
                    </button>
                    <div class="profile-dropdown" id="profileDropdown">
                        <div class="dropdown-user">
                            <span class="dropdown-name"><%= session.getAttribute("firstName") %></span>
                            <span class="dropdown-uname">@<%= session.getAttribute("username") %></span>
                        </div>
                        <c:choose>
                            <c:when test="${sessionScope.role == 'admin'}">
                                <a href="${pageContext.request.contextPath}/AdminDashboard" class="dropdown-link">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                                    Admin Dashboard
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/UserDashboard" class="dropdown-link">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>
                                    My Profile
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link logout">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                            Logout
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="nav-cta">Login</a>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<%-- Search overlay — sits just below the header --%>
<div class="search-overlay" id="searchOverlay">
    <form action="${pageContext.request.contextPath}/Shop" method="get" class="search-overlay-form">
        <input type="text" name="q" placeholder="Search cars by name or series..." id="searchInput" autocomplete="off">
        <button type="submit" class="btn-search-go">Search</button>
        <button type="button" class="btn-close-search" id="searchClose">&#215;</button>
    </form>
</div>

<script>
(function () {
    var toggle  = document.getElementById('searchToggle');
    var overlay = document.getElementById('searchOverlay');
    var closeBtn = document.getElementById('searchClose');
    var input   = document.getElementById('searchInput');

    toggle.addEventListener('click', function () {
        var open = overlay.classList.toggle('open');
        toggle.classList.toggle('active', open);
        if (open) { setTimeout(function () { input.focus(); }, 320); }
    });
    closeBtn.addEventListener('click', function () {
        overlay.classList.remove('open');
        toggle.classList.remove('active');
    });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            overlay.classList.remove('open');
            toggle.classList.remove('active');
        }
    });

    var profileToggle   = document.getElementById('profileToggle');
    var profileDropdown = document.getElementById('profileDropdown');
    if (profileToggle && profileDropdown) {
        profileToggle.addEventListener('click', function (e) {
            e.stopPropagation();
            profileDropdown.classList.toggle('open');
        });
        document.addEventListener('click', function () {
            profileDropdown.classList.remove('open');
        });
        profileDropdown.addEventListener('click', function (e) {
            e.stopPropagation();
        });
    }
})();
</script>

<%-- Header nav: active class is applied based on current request URI --%>

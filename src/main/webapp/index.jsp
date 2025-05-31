<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="utils/login.jsp" %>

<%
    String currentUsername = (String)session.getAttribute("username");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <% if(currentUsername != null) { %>
    <meta name="username" content="<%= currentUsername %>">
    <% } %>
    <link rel="icon" href="./assets/logo/icon.png"/>
    <link href="./styles/index.css" type="text/css" rel="stylesheet"/>
    <script src="./scripts/header.js" defer></script>
    <title>MyNotepad</title>
</head>

<body>
<header>
    <div class="title">
        <strong onclick="window.location.href='index.jsp'">MyNotepad</strong>
    </div>
    <div class="login-container">
        <form id="loginForm" method="POST">
            <input type="text" name="username" placeholder="Username" required autocomplete="username">
            <input type="password" name="password" placeholder="Password" required autocomplete="current-password">
            <button type="submit" class="login-btn">Login</button>
        </form>
        <% if(request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
    </div>
</header>

<main>
    <h1 class="bodyTitle">MyNotepad</h1>
    <h3 class="subTitle">A Place for Every Idea.</h3>
    <button id="startBtn" onclick="window.location.href='home.jsp'">Start Now</button>
</main>

<footer>
    <p>&copy; 2025 Ruthgyeul. All rights reserved.</p>
    <a href="https://github.com/Ruthgyeul/MyNotepad" target="_blank">
        <img src="${pageContext.request.contextPath}/assets/ui/github.png" alt="GitHub"/>
    </a>
</footer>
</body>
</html>
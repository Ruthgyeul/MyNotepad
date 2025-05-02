<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/logo/icon.png" />
    <link href="${pageContext.request.contextPath}/styles/landing.css" type="text/css" rel="stylesheet" />
    <title>MyNotepad</title>
</head>

<body>
    <!-- Header Area -->
    <header>
        <div class="title">
            <strong onclick="window.location.href='landing.jsp'">MyNotepad</strong>
        </div>
    </header>

    <main>
        <!-- Title Area -->
        <h1 class="bodyTitle" id="title">MyNotepad</h1>
        <h3 class="subTitle" id="subTitle">A Place for Every Idea.</h3>

        <!-- Login Button -->
        <button onclick="window.location.href='home.jsp'">Start Now!</button>
    </main>

    <!-- Footer Area -->
    <footer>
        <p>&copy; 2025 Ruthgyeul. All rights reserved.</p>
        <a href="https://github.com/Ruthgyeul/MyNotepad" target="_blank">
            <img src="${pageContext.request.contextPath}/assets/ui/github.png" alt="github" />
        </a>
    </footer>
</body>

</html>
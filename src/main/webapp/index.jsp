<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/logo/icon.png"/>
    <link href="${pageContext.request.contextPath}/styles/intro.css" type="text/css" rel="stylesheet"/>
    <title>MyNotepad</title>
</head>

<body>
    <header>
        <div class="title">
            <strong onclick="window.location.href='index.jsp'">MyNotepad</strong>
        </div>
    </header>

    <main>
        <h1 class="bodyTitle">MyNotepad</h1>
        <h3 class="subTitle">A Place for Every Idea.</h3>
        <button onclick="window.location.href='home.jsp'">Start Now</button>
    </main>

    <footer>
        <p>&copy; 2025 Ruthgyeul. All rights reserved.</p>
        <a href="https://github.com/Ruthgyeul/MyNotepad" target="_blank">
            <img src="${pageContext.request.contextPath}/assets/ui/github.png" alt="GitHub"/>
        </a>
    </footer>
</body>

</html>
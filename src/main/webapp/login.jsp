<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/logo/icon.png" />
    <link href="${pageContext.request.contextPath}/styles/login.css" type="text/css" rel="stylesheet" />
    <script src="${pageContext.request.contextPath}/scripts/login.js"></script>
    <title>MyNotepad: Login</title>
</head>

<body>
    <!-- Header Area -->
    <header>
        <div class="title">
            <strong onclick="window.location.href='landing.jsp'">MyNotepad</strong>
        </div>
    </header>

    <main>
        <!-- Login Area -->
        <div class="formContent">
            <h1 class="boxTitle">로그인하기</h1>
            <form action="javascript:login()" method="post">
                <div class="field loginField">
                    <input name="id" type="text" placeholder="아이디" id="userId" class="input" required />
                </div>

                <div class="field loginField">
                    <input name="pwd" type="password" placeholder="비밀번호" id="pwd" class="pwd" required />
                </div>

                <hr style="margin-top: 20px;" />

                <div class="field buttonField">
                    <button type="submit">로그인</button>
                </div>
            </form>
        </div>
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
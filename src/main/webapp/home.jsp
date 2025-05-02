<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/logo/icon.png"/>
    <link href="${pageContext.request.contextPath}/styles/home.css" type="text/css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/scripts/home.js" defer></script>
    <title>MyNotepad: 홈</title>
</head>

<body>
    <header>
        <div class="title">
            <strong onclick="window.location.href='index.jsp'">MyNotepad</strong>
        </div>
    </header>

    <main>
        <menu>
            <div class="menuBar">
                <select id="categoryFilter">
                    <option value="all" selected>전체</option>
                    <option value="general">일반</option>
                    <option value="study">공부</option>
                    <option value="etc">기타</option>
                </select>

                <form id="searchForm" method="get" onsubmit="return false;">
                    <input type="text" id="searchInput" class="searchInput" placeholder="노트 (제목/내용/키워드) 검색..." />
                    <button type="button" onclick="searchNotes()">검색</button>
                </form>
            </div>
        </menu>

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>중요도</th>
                    <th>카테고리</th>
                    <th>제목</th>
                    <th>최종 수정일</th>
                </tr>
            </thead>
            <tbody>
                <tr onclick="window.location.href='viewNote.jsp?id=3'">
                    <td>3</td>
                    <td><span class="flagged">🚩</span></td>
                    <td>일반</td>
                    <td>노트 제목3</td>
                    <td>2025-03-25</td>
                </tr>
                <tr onclick="window.location.href='viewNote.jsp?id=2'">
                    <td>2</td>
                    <td></td>
                    <td>일반</td>
                    <td>노트 제목2</td>
                    <td>2025-03-24</td>
                </tr>
                <tr onclick="window.location.href='viewNote.jsp?id=1'">
                    <td>1</td>
                    <td></td>
                    <td>기타</td>
                    <td>노트 제목1</td>
                    <td>2025-03-23</td>
                </tr>
            </tbody>
        </table>

        <button onclick="window.location.href='createNote.jsp'" class="newNoteB">새로운 노트 생성하기</button>
    </main>

    <footer>
        <p>&copy; 2025 Ruthgyeul. All rights reserved.</p>
        <a href="https://github.com/Ruthgyeul/MyNotepad" target="_blank">
            <img src="${pageContext.request.contextPath}/assets/ui/github.png" alt="GitHub"/>
        </a>
    </footer>
</body>

</html>
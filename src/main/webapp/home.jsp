<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="utils/homeData.jsp" %>

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
        <div class="header-container">
            <div class="title">
                <strong onclick="window.location.href='index.jsp'">MyNotepad</strong>
            </div>
            <div class="header-right">
                <span class="username"><%= username %></span>
                <button onclick="window.location.href='createNote.jsp'" class="newNoteB">새 노트</button>
                <button onclick="window.location.href='manageCategories.jsp'" class="newNoteB">카테고리 관리</button>
            </div>
        </div>
    </header>

    <main>
        <menu>
            <div class="menuBar">
                <select id="categoryFilter" onchange="filterNotes()">
                    <option value="all" selected>전체</option>
                    <% for(Map<String, String> category : categories) { %>
                        <option value="<%= category.get("id") %>"><%= category.get("name") %></option>
                    <% } %>
                </select>

                <form id="searchForm" method="get" onsubmit="return searchNotes(event)">
                    <input type="text" id="searchInput" class="searchInput" placeholder="노트 (제목/내용/키워드) 검색..." />
                    <button type="submit">검색</button>
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
                <% for(Map<String, String> note : notes) { %>
                <tr onclick="window.location.href='viewNote.jsp?id=<%= note.get("id") %>'">
                    <td><%= note.get("id") %></td>
                    <td><% if("1".equals(note.get("is_important"))) { %><span class="flagged">🚩</span><% } %></td>
                    <td><%= note.get("category_name") != null ? note.get("category_name") : "미분류" %></td>
                    <td><%= note.get("title") %></td>
                    <td><%= note.get("updated_at") %></td>
                </tr>
                <% } %>
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
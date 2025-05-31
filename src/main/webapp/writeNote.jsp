<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="utils/writeNote.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메모 작성 - My Notepad</title>
    <link href="styles/write.css" type="text/css" rel="stylesheet"/>
    <script src="scripts/newNote.js" defer></script>
</head>
<body>
<header>
    <div class="title">
        <strong onclick="window.location.href='home.jsp'">MyNotepad</strong>
    </div>
    <div class="newNote">
        <p>새 노트 작성 중</p>
    </div>
</header>

<main>
    <form id="noteForm" class="noteForm" action="writeNote.jsp" method="POST" enctype="multipart/form-data">
        <div class="formField titleArea">
            <span id="noteId" class="noteId" data-real-id="0">No. <%= getNextNoteId(session, getConnection()) %></span>
            <input type="text" id="noteTitle" class="noteTitle" name="title" placeholder="제목을 입력하세요" required>
        </div>

        <hr/>

        <div class="infoArea">
            <div class="formField">
                <label>중요도</label>
                <input type="checkbox" id="noteFlag" name="important">
            </div>

            <div class="formField">
                <label>카테고리</label>
                <select name="category" id="noteCategory" required>
                    <% for(Map<String, String> category : categories) { %>
                        <option value="<%= category.get("id") %>"><%= category.get("name") %></option>
                    <% } %>
                </select>
            </div>

            <div class="formField">
                <label>색상</label>
                <input type="color" id="noteColor" name="color" value="#4a6cf7" required>
            </div>
        </div>

        <hr/>

        <div class="formField noteArea">
            <label for="noteText">메모 내용</label>
            <textarea id="noteText" class="noteText" name="content" placeholder="본문을 입력해주세요" required></textarea>
        </div>

        <div class="attachmentArea">
            <label for="noteAttachment">파일 첨부</label>
            <div class="fileUploadContainer">
                <input type="file" id="noteAttachment" name="fileInput" multiple />
                <div class="fileList" id="fileList"></div>
            </div>
        </div>

        <hr/>

        <div class="buttonField">
            <button type="submit" class="submitB">저장하기</button>
            <button type="button" class="cancelB" onclick="window.location.href='home.jsp'">취소</button>
        </div>
    </form>
</main>

<footer>
    <p>&copy; 2025 Ruthgyeul. All rights reserved.</p>
    <a href="https://github.com/Ruthgyeul/MyNotepad" target="_blank">
        <img src="assets/ui/github.png" alt="GitHub"/>
    </a>
</footer>
</body>
</html> 
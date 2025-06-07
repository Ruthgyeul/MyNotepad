<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="utils/db.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 카테고리 목록을 저장할 리스트
    List<Map<String, String>> categories = new ArrayList<>();
    
    try (Connection conn = getConnection()) {
        String userId = (String)session.getAttribute("userId");
        if(userId != null) {
            String sql = "SELECT id, name FROM categories WHERE user_id = ? ORDER BY name";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    while(rs.next()) {
                        Map<String, String> category = new HashMap<>();
                        category.put("id", rs.getString("id"));
                        category.put("name", rs.getString("name"));
                        categories.add(category);
                    }
                }
            }
        }
    } catch(SQLException e) {
        e.printStackTrace();
    }
    
    String id = request.getParameter("id");
    if (id == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    if (request.getMethod().equals("POST")) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String categoryId = request.getParameter("category");
        boolean important = request.getParameter("important") != null;
        String color = request.getParameter("color");
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "UPDATE notes SET category_id = ?, title = ?, content = ?, important = ?, color = ? WHERE id = ?")) {
            
            pstmt.setString(1, categoryId);
            pstmt.setString(2, title);
            pstmt.setString(3, content);
            pstmt.setBoolean(4, important);
            pstmt.setString(5, color);
            pstmt.setInt(6, Integer.parseInt(id));
            pstmt.executeUpdate();
            
            response.sendRedirect("home.jsp");
            return;
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // 메모 정보 조회
    int noteId = 0;
    int displayId = 0;
    String title = "";
    String content = "";
    String categoryId = "";
    boolean important = false;
    String color = "#ffffff";
    Timestamp createdAt = null;
    
    try (Connection conn = getConnection();
         PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM notes WHERE id = ?")) {
        
        pstmt.setInt(1, Integer.parseInt(id));
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                noteId = rs.getInt("id");
                displayId = rs.getInt("user_note_id");
                title = rs.getString("title");
                content = rs.getString("content");
                categoryId = rs.getString("category_id");
                important = rs.getBoolean("important");
                color = rs.getString("color");
                if (color == null) color = "#ffffff";
                createdAt = rs.getTimestamp("created_at");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    if (noteId == 0) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메모 수정 - My Notepad</title>
    <link href="${pageContext.request.contextPath}/styles/write.css" type="text/css" rel="stylesheet"/>
    <script src="scripts/newNote.js" defer></script>
</head>
<body style="background-color: <%= color %>;">
<header>
    <div class="title">
        <strong onclick="window.location.href='home.jsp'">MyNotepad</strong>
    </div>
    <div class="newNote">
        <p>노트 수정 중</p>
    </div>
</header>

<main>
    <form id="noteForm" class="noteForm" action="editNote.jsp?id=<%= noteId %>" method="POST">
        <div class="formField titleArea">
            <span id="noteId" class="noteId" data-real-id="<%= displayId %>">No. <%= displayId %></span>
            <input type="text" id="noteTitle" class="noteTitle" name="title" value="<%= title %>" required>
        </div>

        <hr/>

        <div class="infoArea">
            <div class="formField">
                <label>중요도</label>
                <input type="checkbox" id="noteFlag" name="important" <%= important ? "checked" : "" %>>
            </div>

            <div class="formField">
                <label>카테고리</label>
                <select name="category" id="noteCategory" required>
                    <% for(Map<String, String> cat : categories) { %>
                        <option value="<%= cat.get("id") %>" <%= categoryId.equals(cat.get("id")) ? "selected" : "" %>><%= cat.get("name") %></option>
                    <% } %>
                </select>
            </div>

            <div class="formField">
                <label>색상</label>
                <input type="color" id="noteColor" name="color" value="<%= color %>" required>
            </div>
        </div>

        <hr/>

        <div class="formField noteArea">
            <label for="noteText">메모 내용</label>
            <textarea id="noteText" class="noteText" name="content" required><%= content %></textarea>
        </div>

        <hr/>

        <div class="buttonField">
            <button type="submit" class="submitB">수정하기</button>
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
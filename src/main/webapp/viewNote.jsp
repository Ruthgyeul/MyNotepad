<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="utils/db.jsp" %>

<%
    String noteId = request.getParameter("id");
    if (noteId == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    // 노트 정보와 첨부 파일 정보를 저장할 변수들
    Map<String, Object> note = new HashMap<>();
    List<Map<String, Object>> files = new ArrayList<>();
    
    try (Connection conn = getConnection()) {
        // 노트 정보 조회
        String sql = "SELECT n.*, c.name as category_name " +
                    "FROM notes n " +
                    "LEFT JOIN categories c ON n.category_id = c.id " +
                    "WHERE n.id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, noteId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    note.put("id", rs.getInt("id"));
                    note.put("user_note_id", rs.getInt("user_note_id"));
                    note.put("title", rs.getString("title"));
                    note.put("content", rs.getString("content"));
                    note.put("category_name", rs.getString("category_name"));
                    note.put("important", rs.getBoolean("important"));
                    note.put("color", rs.getString("color"));
                    note.put("created_at", rs.getTimestamp("created_at"));
                }
            }
        }
        
        // 첨부 파일 정보 조회
        sql = "SELECT * FROM noteFiles WHERE note_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, noteId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> file = new HashMap<>();
                    file.put("id", rs.getInt("id"));
                    file.put("file_name", rs.getString("file_name"));
                    file.put("file_content", rs.getString("file_content"));
                    file.put("file_size", rs.getLong("file_size"));
                    file.put("file_type", rs.getString("file_type"));
                    files.add(file);
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= note.get("title") %> - My Notepad</title>
    <link href="${pageContext.request.contextPath}/styles/viewNote.css" type="text/css" rel="stylesheet"/>
</head>
<body>
<header>
    <div class="title">
        <strong onclick="window.location.href='home.jsp'">MyNotepad</strong>
    </div>
    <div class="actions">
        <a href="editNote.jsp?id=<%= note.get("id") %>" class="editBtn">수정</a>
        <button onclick="deleteNote(<%= note.get("id") %>)" class="deleteBtn">삭제</button>
    </div>
</header>

<main>
    <div class="noteView" style="background-color: <%= note.get("color") %>;">
        <div class="noteHeader">
            <span class="noteId">No. <%= note.get("user_note_id") %></span>
            <h1 class="noteTitle"><%= note.get("title") %></h1>
        </div>

        <div class="noteInfo">
            <span class="category"><%= note.get("category_name") %></span>
            <span class="date"><%= note.get("created_at") %></span>
            <% if ((Boolean)note.get("important")) { %>
                <span class="important">중요</span>
            <% } %>
        </div>

        <div class="noteContent"><%= note.get("content") %></div>

        <% if (!files.isEmpty()) { %>
            <div class="attachments">
                <h3>첨부 파일 (<%= files.size() %>)</h3>
                <ul>
                    <% for (Map<String, Object> file : files) { 
                        String fileType = (String)file.get("file_type");
                        boolean isImage = fileType != null && fileType.startsWith("image/");
                    %>
                        <li>
                            <% if (isImage) { %>
                                <div class="imagePreview">
                                    <img src="downloadFile.jsp?id=<%= file.get("id") %>" alt="<%= file.get("file_name") %>" />
                                    <div class="fileInfo">
                                        <span class="fileName"><%= file.get("file_name") %></span>
                                        <span class="fileMeta">
                                            <%= formatFileSize((Long)file.get("file_size")) %> · 
                                            <%= file.get("file_type") %>
                                        </span>
                                    </div>
                                </div>
                            <% } else { %>
                                <a href="downloadFile.jsp?id=<%= file.get("id") %>" class="fileLink">
                                    <div class="fileInfo">
                                        <span class="fileName"><%= file.get("file_name") %></span>
                                        <span class="fileMeta">
                                            <%= formatFileSize((Long)file.get("file_size")) %> · 
                                            <%= file.get("file_type") %>
                                        </span>
                                    </div>
                                </a>
                            <% } %>
                        </li>
                    <% } %>
                </ul>
            </div>
        <% } %>
    </div>
</main>

<script>
function deleteNote(id) {
    if (confirm('정말로 이 노트를 삭제하시겠습니까?')) {
        fetch('deleteNote.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'id=' + id
        }).then(() => {
            window.location.href = 'home.jsp';
        });
    }
}
</script>
</body>
</html>

<%!
    private String formatFileSize(long size) {
        if (size < 1024) return size + " B";
        if (size < 1024 * 1024) return String.format("%.1f KB", size / 1024.0);
        if (size < 1024 * 1024 * 1024) return String.format("%.1f MB", size / (1024.0 * 1024));
        return String.format("%.1f GB", size / (1024.0 * 1024 * 1024));
    }
%> 
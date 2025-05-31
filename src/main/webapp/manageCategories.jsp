<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="utils/db.jsp" %>
<%@ page import="java.util.*" %>
<%
    String username = "";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Map<String, String>> categories = new ArrayList<>();
    
    try {
        conn = getConnection();
        String userId = (String)session.getAttribute("userId");
        
        if(userId != null) {
            // 사용자 정보 조회
            String sql = "SELECT username FROM users WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                username = rs.getString("username");
            }
            
            // 카테고리 목록 조회
            sql = "SELECT id, name, is_default FROM categories WHERE user_id = ? ORDER BY name";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                Map<String, String> category = new HashMap<>();
                category.put("id", rs.getString("id"));
                category.put("name", rs.getString("name"));
                category.put("is_default", rs.getString("is_default"));
                categories.add(category);
            }
        }
    } catch(Exception e) {
        System.err.println("Database error: " + e.getMessage());
        request.setAttribute("errorMessage", "데이터베이스 연결 중 오류가 발생했습니다.");
    } finally {
        if(rs != null) try { rs.close(); } catch(SQLException e1) {}
        if(pstmt != null) try { pstmt.close(); } catch(SQLException e2) {}
        if(conn != null) try { conn.close(); } catch(SQLException e3) {}
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/logo/icon.png"/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/styles/manageCategory.css" type="text/css" rel="stylesheet"/>
    <title>MyNotepad: 카테고리 관리</title>
</head>
<body>
    <header>
        <div class="title">
            <strong onclick="window.location.href='home.jsp'">MyNotepad</strong>
        </div>
        <div class="header-right">
            <span class="username"><%= username %></span>
        </div>
    </header>

    <main>
        <h1>카테고리 관리</h1>
        
        <div class="category-form">
            <h2>새 카테고리 추가</h2>
            <form action="manageCategories.jsp" method="post">
                <input type="text" name="categoryName" placeholder="카테고리 이름" required>
                <button type="submit" class="btn btn-primary">추가</button>
            </form>
        </div>

        <div class="category-list">
            <h2>카테고리 목록</h2>
            <% for(Map<String, String> category : categories) { %>
            <div class="category-item">
                <form action="manageCategories.jsp" method="post" style="display: flex; width: 100%;">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="categoryId" value="<%= category.get("id") %>">
                    <input type="text" name="categoryName" value="<%= category.get("name") %>" <%= "true".equals(category.get("is_default")) ? "readonly" : "" %> required>
                    <button type="submit" class="btn btn-primary" onclick="return confirmUpdate()" <%= "true".equals(category.get("is_default")) ? "disabled" : "" %>>수정</button>
                    <button type="button" onclick="deleteCategory('<%= category.get("id") %>')" class="btn btn-danger" <%= "true".equals(category.get("is_default")) ? "disabled" : "" %>>삭제</button>
                </form>
            </div>
            <% } %>
        </div>
    </main>

    <script>
        function deleteCategory(categoryId) {
            if(!confirm('정말로 이 카테고리를 삭제하시겠습니까?')) {
                return;
            }
            
            const form = document.createElement('form');
            form.method = 'post';
            form.action = 'manageCategories.jsp';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'categoryId';
            idInput.value = categoryId;
            
            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);
            form.submit();
        }

        function confirmUpdate() {
            return confirm('카테고리 이름을 수정하시겠습니까?');
        }
    </script>
</body>
</html>

<%
    // POST 요청 처리
    if("POST".equals(request.getMethod())) {
        String action = request.getParameter("action");
        String categoryName = request.getParameter("categoryName");
        String categoryId = request.getParameter("categoryId");
        
        try {
            conn = getConnection();
            String userId = (String)session.getAttribute("userId");
            
            if(userId != null) {
                if("update".equals(action) && categoryId != null && categoryName != null) {
                    // 기본 카테고리인지 확인
                    String checkDefaultSql = "SELECT is_default FROM categories WHERE id = ? AND user_id = ?";
                    pstmt = conn.prepareStatement(checkDefaultSql);
                    pstmt.setString(1, categoryId);
                    pstmt.setString(2, userId);
                    rs = pstmt.executeQuery();
                    
                    if(rs.next() && rs.getBoolean("is_default")) {
                        request.setAttribute("errorMessage", "기본 카테고리는 수정할 수 없습니다.");
                    } else {
                        // 카테고리 수정
                        String sql = "UPDATE categories SET name = ? WHERE id = ? AND user_id = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, categoryName);
                        pstmt.setString(2, categoryId);
                        pstmt.setString(3, userId);
                        pstmt.executeUpdate();
                    }
                } else if("delete".equals(action) && categoryId != null) {
                    // 기본 카테고리인지 확인
                    String checkDefaultSql = "SELECT is_default FROM categories WHERE id = ? AND user_id = ?";
                    pstmt = conn.prepareStatement(checkDefaultSql);
                    pstmt.setString(1, categoryId);
                    pstmt.setString(2, userId);
                    rs = pstmt.executeQuery();
                    
                    if(rs.next() && rs.getBoolean("is_default")) {
                        request.setAttribute("errorMessage", "기본 카테고리는 삭제할 수 없습니다.");
                    } else {
                        // 트랜잭션 시작
                        conn.setAutoCommit(false);
                        try {
                            // 해당 카테고리의 노트들을 기본 카테고리로 이동
                            String updateSql = "UPDATE notes SET category_id = NULL WHERE category_id = ? AND user_id = ?";
                            pstmt = conn.prepareStatement(updateSql);
                            pstmt.setString(1, categoryId);
                            pstmt.setString(2, userId);
                            pstmt.executeUpdate();
                            // 카테고리 삭제
                            String deleteSql = "DELETE FROM categories WHERE id = ? AND user_id = ?";
                            pstmt = conn.prepareStatement(deleteSql);
                            pstmt.setString(1, categoryId);
                            pstmt.setString(2, userId);
                            pstmt.executeUpdate();
                            conn.commit();
                        } catch(Exception e) {
                            conn.rollback();
                            throw e;
                        } finally {
                            conn.setAutoCommit(true);
                        }
                    }
                } else if(categoryName != null) {
                    // 새 카테고리 추가
                    String sql = "INSERT INTO categories (user_id, name) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, userId);
                    pstmt.setString(2, categoryName);
                    pstmt.executeUpdate();
                }
            }
            
            // 페이지 새로고침
            response.sendRedirect("manageCategories.jsp");
            
        } catch(Exception e) {
            System.err.println("Database error: " + e.getMessage());
            request.setAttribute("errorMessage", "데이터베이스 작업 중 오류가 발생했습니다.");
        } finally {
            if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
            if(conn != null) try { conn.close(); } catch(SQLException e) {}
        }
    }
%> 
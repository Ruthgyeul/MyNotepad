<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="db.jsp" %>

<%
    String username = "";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // 카테고리와 노트 목록을 저장할 리스트
    List<Map<String, String>> categories = new ArrayList<>();
    List<Map<String, String>> notes = new ArrayList<>();
    
    try {
        conn = getConnection();

        String userId = (String)session.getAttribute("userId");
        
        if(userId != null) {
            String sql = "SELECT username FROM users WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                username = rs.getString("username");
            }

            sql = "SELECT id, name FROM categories WHERE user_id = ? ORDER BY name";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                Map<String, String> category = new HashMap<>();
                category.put("id", rs.getString("id"));
                category.put("name", rs.getString("name"));
                categories.add(category);
            }

            sql = "SELECT n.id, n.title, n.category_id, n.is_important, n.updated_at, c.name as category_name " +
                  "FROM notes n " +
                  "LEFT JOIN categories c ON n.category_id = c.id " +
                  "WHERE n.user_id = ? " +
                  "ORDER BY n.updated_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                Map<String, String> note = new HashMap<>();
                note.put("id", rs.getString("id"));
                note.put("title", rs.getString("title"));
                note.put("category_id", rs.getString("category_id"));
                note.put("category_name", rs.getString("category_name"));
                note.put("is_important", rs.getString("is_important"));
                note.put("updated_at", rs.getString("updated_at"));
                notes.add(note);
            }
        }
    } catch(Exception e) {
        System.err.println("Database error: " + e.getMessage());
        request.setAttribute("errorMessage", "데이터베이스 연결 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
    } finally {
        if(rs != null) try { rs.close(); } catch(SQLException e) {}
        if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
        if(conn != null) try { conn.close(); } catch(SQLException e) {}
    }
%> 
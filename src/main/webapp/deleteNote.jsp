<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="utils/db.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    if (request.getMethod().equals("POST")) {
        String id = request.getParameter("id");
        if (id != null) {
            try (Connection conn = getConnection();
                 PreparedStatement pstmt = conn.prepareStatement("DELETE FROM notes WHERE id = ?")) {
                
                pstmt.setInt(1, Integer.parseInt(id));
                pstmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    response.sendRedirect("home.jsp");
%>
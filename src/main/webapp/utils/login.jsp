<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    if ("POST".equals(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username != null && password != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = getConnection();
                if (conn == null) { throw new SQLException("데이터베이스 연결 실패"); }

                String checkUserSql = "SELECT id, password FROM users WHERE username = ?";
                pstmt = conn.prepareStatement(checkUserSql);
                pstmt.setString(1, username);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    if (password.equals(storedPassword)) {
                        session.setAttribute("userId", rs.getString("id"));
                        session.setAttribute("username", username);
                        response.sendRedirect("home.jsp");
                        return;
                    } else {
                        request.setAttribute("error", "비밀번호가 일치하지 않습니다.");
                    }
                } else {
                    String insertUserSql = "INSERT INTO users (username, password) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(insertUserSql);
                    pstmt.setString(1, username);
                    pstmt.setString(2, password);
                    pstmt.executeUpdate();

                    pstmt = conn.prepareStatement(checkUserSql);
                    pstmt.setString(1, username);
                    rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
                        session.setAttribute("userId", rs.getString("id"));
                        session.setAttribute("username", username);
                        response.sendRedirect("home.jsp");
                        return;
                    }
                }
            } catch(Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "로그인 처리 중 오류가 발생했습니다.");
            } finally {
                if(rs != null) try { rs.close(); } catch(SQLException e) {}
                if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
                if(conn != null) try { conn.close(); } catch(SQLException e) {}
            }
        }
    }
%> 
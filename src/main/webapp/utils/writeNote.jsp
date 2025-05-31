<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.*" %>
<%@ include file="db.jsp" %>

<%!
    public int getNextNoteId(HttpSession session, Connection conn) throws SQLException {
        String userId = (String)session.getAttribute("userId");
        if (userId == null) return 1;
        
        String sql = "SELECT COALESCE(MAX(user_note_id), 0) + 1 as next_id FROM notes WHERE user_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("next_id");
                }
            }
        }
        return 1;
    }
%>

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
    
    if (request.getMethod().equals("POST")) {
        // 세션 체크
        String userId = (String)session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 입력값 검증
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String categoryId = request.getParameter("category");
            boolean important = request.getParameter("important") != null;
            String color = request.getParameter("color");
            
            // 필수 입력값 검증
            if (title == null || title.trim().isEmpty() || 
                content == null || content.trim().isEmpty() || 
                categoryId == null || categoryId.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "필수 입력값이 누락되었습니다.");
                return;
            }
            
            // 입력값 길이 제한
            if (title.length() > 200) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "제목은 200자를 초과할 수 없습니다.");
                return;
            }
            
            // 카테고리 유효성 검사
            boolean validCategory = false;
            for (Map<String, String> category : categories) {
                if (category.get("id").equals(categoryId)) {
                    validCategory = true;
                    break;
                }
            }
            if (!validCategory) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 카테고리입니다.");
                return;
            }
            
            Connection conn = null;
            try {
                conn = getConnection();
                conn.setAutoCommit(false); // 트랜잭션 시작
                
                // 노트 저장
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO notes (user_id, user_note_id, category_id, title, content, important, color, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())")) {
                    
                    pstmt.setString(1, userId);
                    pstmt.setInt(2, getNextNoteId(session, conn));
                    pstmt.setString(3, categoryId);
                    pstmt.setString(4, title.trim());
                    pstmt.setString(5, content.trim());
                    pstmt.setBoolean(6, important);
                    pstmt.setString(7, color);
                    pstmt.executeUpdate();
                }
                
                // 파일 업로드 처리
                Collection<Part> parts = request.getParts();
                System.out.println("Total parts: " + parts.size());
                for (Part part : parts) {
                    System.out.println("Processing part: " + part.getName() + 
                                     ", Content-Type: " + part.getContentType() + 
                                     ", Size: " + part.getSize());
                    
                    if (part.getName().equals("fileInput")) {
                        System.out.println("Found fileInput part");
                        if (part.getSize() > 0) {
                            String fileName = part.getSubmittedFileName();
                            System.out.println("Processing file: " + fileName + 
                                             ", Content-Type: " + part.getContentType() + 
                                             ", Size: " + part.getSize());
                            
                            try {
                                // 파일을 바이트 배열로 읽기
                                byte[] fileBytes = part.getInputStream().readAllBytes();
                                System.out.println("File bytes read: " + fileBytes.length);
                                
                                // Base64로 인코딩
                                String base64File = java.util.Base64.getEncoder().encodeToString(fileBytes);
                                System.out.println("Base64 encoded length: " + base64File.length());
                                
                                // 파일 정보를 noteFiles 테이블에 저장
                                try (PreparedStatement fileStmt = conn.prepareStatement(
                                    "INSERT INTO noteFiles (note_id, file_name, file_content, file_size, file_type) " +
                                    "VALUES (LAST_INSERT_ID(), ?, ?, ?, ?)")) {
                                    
                                    fileStmt.setString(1, fileName);
                                    fileStmt.setString(2, base64File);
                                    fileStmt.setLong(3, part.getSize());
                                    fileStmt.setString(4, part.getContentType());
                                    fileStmt.executeUpdate();
                                    System.out.println("File saved successfully: " + fileName);
                                }
                            } catch (Exception e) {
                                System.out.println("Error processing file: " + e.getMessage());
                                e.printStackTrace();
                                throw e;
                            }
                        } else {
                            System.out.println("FileInput part has size 0, skipping");
                        }
                    }
                }
                
                conn.commit(); // 트랜잭션 커밋
                response.sendRedirect("home.jsp");
                return;
                
            } catch (Exception e) {
                if (conn != null) {
                    try {
                        conn.rollback(); // 에러 발생 시 롤백
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
                throw e;
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "노트 저장 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
%>

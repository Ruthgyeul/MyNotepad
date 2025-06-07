<%@ page language="java" contentType="application/octet-stream" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ include file="utils/db.jsp" %>

<%
    String fileId = request.getParameter("id");
    if (fileId == null) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "파일 ID가 지정되지 않았습니다.");
        return;
    }

    try (Connection conn = getConnection()) {
        String sql = "SELECT * FROM noteFiles WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, fileId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String fileName = rs.getString("file_name");
                    String fileContent = rs.getString("file_content");
                    String fileType = rs.getString("file_type");
                    long fileSize = rs.getLong("file_size");

                    // Base64 디코딩
                    byte[] fileBytes = java.util.Base64.getDecoder().decode(fileContent);

                    // Content-Type 설정
                    response.setContentType(fileType);
                    
                    // 이미지가 아닌 경우에만 다운로드 헤더 설정
                    if (!fileType.startsWith("image/")) {
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + 
                            new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
                    }
                    
                    response.setContentLengthLong(fileSize);

                    // 파일 전송: JSP 버퍼를 사용하지 않고 직접 출력 스트림을 사용
                    try (OutputStream outStream = response.getOutputStream()) {
                        outStream.write(fileBytes);
                        outStream.flush();
                    }
                    return;
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일을 찾을 수 없습니다.");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "파일 처리 중 오류가 발생했습니다.");
    }
%> 
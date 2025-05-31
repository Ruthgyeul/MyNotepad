<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>

<%!
    private static boolean isInitialized = false;
    private static synchronized void initialize() {
        if (!isInitialized) {
            isInitialized = true;
        }
    }
%>

<%
    initialize();
%>

<%!
    public Connection getConnection() throws SQLException {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            javax.sql.DataSource ds = (javax.sql.DataSource) envContext.lookup("jdbc/MyNotepadDB");
            return ds.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("데이터베이스 연결 실패: " + e.getMessage());
        }
    }
%> 
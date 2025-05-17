package repository;

import entity.Note;

import java.sql.*;
import java.util.*;

public class NoteRepository {
    private static final String URL = "jdbc:mariadb://localhost:3306/MyNotepadDB";
    private static final String USER = "root";
    private static final String PASSWORD = "9623**";

    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM notes WHERE user_id = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void insert(Note note) {
        String sql = "INSERT INTO notes (user_id, display_id, category, title, content, important, color, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, note.getUserId());
            pstmt.setInt(2, note.getDisplayId());
            pstmt.setString(3, note.getCategory());
            pstmt.setString(4, note.getTitle());
            pstmt.setString(5, note.getContent());
            pstmt.setBoolean(6, note.isImportant());
            pstmt.setString(7, note.getColor());
            pstmt.setTimestamp(8, note.getCreatedAt());
            pstmt.setTimestamp(9, note.getUpdatedAt());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Note> findByUserId(int userId) {
        List<Note> notes = new ArrayList<>();
        String sql = "SELECT * FROM notes WHERE user_id = ? ORDER BY id DESC";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    notes.add(mapNote(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notes;
    }

    public Note findById(int id) {
        String sql = "SELECT * FROM notes WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapNote(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public void delete(int id) {
        String sql = "DELETE FROM notes WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Note note) {
        String sql = "UPDATE notes SET category=?, title=?, content=?, important=?, color=?, updated_at=? WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, note.getCategory());
            pstmt.setString(2, note.getTitle());
            pstmt.setString(3, note.getContent());
            pstmt.setBoolean(4, note.isImportant());
            pstmt.setString(5, note.getColor());
            pstmt.setTimestamp(6, note.getUpdatedAt());
            pstmt.setInt(7, note.getId());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Note mapNote(ResultSet rs) throws SQLException {
        return new Note(
            rs.getInt("id"),
            rs.getInt("user_id"),
            rs.getInt("display_id"),
            rs.getString("category"),
            rs.getString("title"),
            rs.getString("content"),
            rs.getBoolean("important"),
            rs.getString("color"),
            rs.getTimestamp("updated_at"),
            rs.getTimestamp("created_at")
        );
    }
} 
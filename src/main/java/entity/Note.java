package entity;

import java.sql.Timestamp;

public class Note {
    private int id;
    private int userId;
    private String category;
    private String title;
    private String content;
    private boolean important;
    private String color;
    private String[] filePaths;
    private Timestamp updatedAt;
    private Timestamp createdAt;

    public Note(int id, int userId, String category, String title, String content, boolean important, String color, String[] filePaths, Timestamp updatedAt, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.category = category;
        this.title = title;
        this.content = content;
        this.important = important;
        this.color = color;
        this.filePaths = filePaths;
        this.updatedAt = updatedAt;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getCategory() { return category; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public boolean isImportant() { return important; }
    public String getColor() { return color; }
    public String[] getFilePaths() { return filePaths; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public Timestamp getCreatedAt() { return createdAt; }

    public void setUserId(int userId) { this.userId = userId; }
    public void setCategory(String category) { this.category = category; }
    public void setTitle(String title) { this.title = title; }
    public void setContent(String content) { this.content = content; }
    public void setImportant(boolean important) { this.important = important; }
    public void setColor(String color) { this.color = color; }
    public void setFilePaths(String[] filePaths) { this.filePaths = filePaths; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
} 

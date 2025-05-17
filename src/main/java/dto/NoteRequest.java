package dto;

import java.io.File;

public class NoteRequest {
    private int id;
    private int userId;
    private String category;
    private String title;
    private String content;
    private boolean important;
    private String color;
    private File file;

    public NoteRequest(int id, int userId, String category, String title, String content,
                      boolean important, String color, File file) {
        this.id = id;
        this.userId = userId;
        this.category = category;
        this.title = title;
        this.content = content;
        this.important = important;
        this.color = color;
        this.file = file;
    }

    // Getter
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getCategory() { return category; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public boolean isImportant() { return important; }
    public String getColor() { return color; }
    public File getFile() { return file; }

    // Setter
    public void setId(int id) { this.id = id; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setCategory(String category) { this.category = category; }
    public void setTitle(String title) { this.title = title; }
    public void setContent(String content) { this.content = content; }
    public void setImportant(boolean important) { this.important = important; }
    public void setColor(String color) { this.color = color; }
    public void setFile(File file) { this.file = file; }
}
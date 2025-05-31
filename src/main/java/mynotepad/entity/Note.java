package mynotepad.entity;

import java.sql.Timestamp;

public class Note {
    private Integer id;
    private Integer userId;
    private Integer displayId;
    private String category;
    private String title;
    private String content;
    private Boolean important;
    private String color;
    private Timestamp updatedAt;
    private Timestamp createdAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public Integer getDisplayId() { return displayId; }
    public void setDisplayId(Integer displayId) { this.displayId = displayId; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public Boolean getImportant() { return important; }
    public void setImportant(Boolean important) { this.important = important; }
    
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
} 
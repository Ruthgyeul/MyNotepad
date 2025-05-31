package mynotepad.entity;

import java.sql.Timestamp;

public class NoteFile {
    private Integer id;
    private Integer noteId;
    private String fileName;
    private byte[] fileData;
    private Timestamp uploadedAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getNoteId() { return noteId; }
    public void setNoteId(Integer noteId) { this.noteId = noteId; }
    
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    
    public byte[] getFileData() { return fileData; }
    public void setFileData(byte[] fileData) { this.fileData = fileData; }
    
    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
} 
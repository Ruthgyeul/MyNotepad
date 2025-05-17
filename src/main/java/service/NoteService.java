package service;

import dto.NoteRequest;
import entity.Note;
import entity.File;
import repository.NoteRepository;
import repository.FileRepository;

import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

public class NoteService {
    private final NoteRepository noteRepository = new NoteRepository();
    private final FileRepository fileRepository = new FileRepository();

    // CREATE
    public void saveNote(NoteRequest request) {
        int displayId = noteRepository.countByUserId(request.getUserId()) + 1;
        Timestamp now = new Timestamp(System.currentTimeMillis());

        Note note = new Note(
            0,
            request.getUserId(),
            displayId,
            request.getCategory(),
            request.getTitle(),
            request.getContent(),
            request.isImportant(),
            request.getColor(),
            now, now
        );
        noteRepository.insert(note);

        // 파일 저장
        if (request.getFile() != null) {
            saveFile(note.getId(), request.getFile());
        }
    }

    // READ
    public List<Note> getNotesByUser(int userId) {
        return noteRepository.findByUserId(userId);
    }

    // READ
    public Note getNoteById(int noteId) {
        return noteRepository.findById(noteId);
    }

    // READ
    public List<File> getFilesByNoteId(int noteId) {
        return fileRepository.findByNoteId(noteId);
    }

    // UPDATE
    public void updateNote(int noteId, NoteRequest request) {
        Note existingNote = noteRepository.findById(noteId);
        if (existingNote == null) {
            throw new IllegalArgumentException("Note not found with ID: " + noteId);
        }

        Note updatedNote = new Note(
            noteId,
            request.getUserId(),
            existingNote.getDisplayId(),
            request.getCategory(),
            request.getTitle(),
            request.getContent(),
            request.isImportant(),
            request.getColor(),
            new Timestamp(System.currentTimeMillis()),
            existingNote.getCreatedAt()
        );
        noteRepository.update(updatedNote);

        // 파일 업데이트
        if (request.getFile() != null) {
            // 기존 파일 삭제
            fileRepository.deleteByNoteId(noteId);
            // 새 파일 저장
            saveFile(noteId, request.getFile());
        }
    }

    // DELETE
    public void deleteNote(int noteId) {
        // 파일 먼저 삭제
        fileRepository.deleteByNoteId(noteId);
        // 노트 삭제
        noteRepository.delete(noteId);
    }

    private void saveFile(int noteId, java.io.File uploadedFile) {
        String originalName = uploadedFile.getName();
        String fileType = getFileExtension(originalName);
        String storedName = UUID.randomUUID().toString() + fileType;
        String filePath = "/uploads/" + storedName;
        
        File file = new File(
            0,
            noteId,
            originalName,
            storedName,
            filePath,
            uploadedFile.length(),
            fileType,
            new Timestamp(System.currentTimeMillis())
        );
        
        fileRepository.insert(file);
    }

    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf(".");
        return lastDotIndex > 0 ? fileName.substring(lastDotIndex) : "";
    }
}
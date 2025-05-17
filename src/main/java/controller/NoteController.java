package controller;

import dto.NoteRequest;
import entity.Note;
import entity.File;
import service.NoteService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

@WebServlet("/notes")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10,  // 10MB
    maxRequestSize = 1024 * 1024 * 15 // 15MB
)
public class NoteController extends HttpServlet {
    private final NoteService noteService = new NoteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            int noteId = Integer.parseInt(request.getParameter("id"));
            Note note = noteService.getNoteById(noteId);
            List<File> files = noteService.getFilesByNoteId(noteId);
            
            request.setAttribute("note", note);
            request.setAttribute("files", files);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/noteForm.jsp");
            dispatcher.forward(request, response);
        } else {
            int userId = Integer.parseInt(request.getParameter("userId"));
            List<Note> notes = noteService.getNotesByUser(userId);
            request.setAttribute("notes", notes);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/home.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        request.setCharacterEncoding("UTF-8");

        if ("create".equals(action)) {
            NoteRequest noteRequest = parseNoteRequest(request);
            noteService.saveNote(noteRequest);
            response.sendRedirect("notes?userId=" + noteRequest.getUserId());

        } else if ("update".equals(action)) {
            NoteRequest noteRequest = parseNoteRequest(request);
            noteService.updateNote(noteRequest.getId(), noteRequest);
            response.sendRedirect("notes?action=detail&id=" + noteRequest.getId());

        } else if ("delete".equals(action)) {
            int noteId = Integer.parseInt(request.getParameter("id"));
            noteService.deleteNote(noteId);
            response.sendRedirect("notes?userId=" + request.getParameter("userId"));
        }
    }

    private NoteRequest parseNoteRequest(HttpServletRequest request) throws ServletException, IOException {
        int id = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id")) : 0;
        int userId = Integer.parseInt(request.getParameter("userId"));
        String category = request.getParameter("category");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        boolean important = "on".equals(request.getParameter("important"));
        String color = request.getParameter("color");
        
        // 파일 업로드 처리
        java.io.File uploadedFile = null;
        Part filePart = request.getPart("fileInput");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = getSubmittedFileName(filePart);
            if (isValidFileName(fileName)) {
                String uploadPath = getServletContext().getRealPath("/uploads/");
                // 업로드 디렉토리가 없으면 생성
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                
                String storedFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadPath + storedFileName;
                filePart.write(filePath);
                
                uploadedFile = new java.io.File(filePath);
            }
        }

        return new NoteRequest(id, userId, category, title, content, important, color, uploadedFile);
    }
    
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    private boolean isValidFileName(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }
        // 파일 확장자 검사
        String[] allowedExtensions = {".jpg", ".jpeg", ".png", ".gif", ".pdf", ".txt", ".doc", ".docx"};
        String lowerFileName = fileName.toLowerCase();
        for (String ext : allowedExtensions) {
            if (lowerFileName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }
}
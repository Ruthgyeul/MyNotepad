/**
 * MyNotepad - New Note JavaScript Functions
 * Handles initialization and dynamic behavior for the note creation/viewing page
 */

// Auto-populate information when the page loads
function newNoteAutoInfo() {
    // Only perform these operations if we're not in view mode
    if (!document.querySelector('.noteText').hasAttribute('readonly')) {
        // Set current date display if we're in create mode
        const today = new Date();
        const formattedDate = today.toLocaleDateString('ko-KR', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit'
        }).replace(/\. /g, '-').replace('.', '');
        
        const createDateElement = document.getElementById('createDate');
        if (createDateElement) {
            createDateElement.textContent = formattedDate;
        }

        // Generate a temporary note ID based on timestamp
        // This will be replaced by the server with a real ID
        const noteIdElement = document.getElementById('noteId');
        if (noteIdElement) {
            const tempId = Math.floor(Math.random() * 1000);
            noteIdElement.textContent = `No. ${tempId}`;
        }

        // Set focus to the title field for better UX
        const titleInput = document.getElementById('noteTitle');
        if (titleInput) {
            titleInput.focus();
        }

        // Setup color picker change handler to preview the color
        setupColorPickerPreview();
    }
}

// Preview the selected color on the form background
function setupColorPickerPreview() {
    const colorPicker = document.getElementById('noteColor');
    const noteForm = document.querySelector('.noteForm');
    
    if (colorPicker && noteForm) {
        // Apply initial color
        applyColorPreview(colorPicker.value);
        
        // Setup event listener for color changes
        colorPicker.addEventListener('input', function() {
            applyColorPreview(this.value);
        });
    }
}

// Apply color preview with opacity
function applyColorPreview(color) {
    const noteForm = document.querySelector('.noteForm');
    const hexColor = color.toLowerCase();
    
    // Calculate a very light version of the selected color
    const r = parseInt(hexColor.substring(1, 3), 16);
    const g = parseInt(hexColor.substring(3, 5), 16);
    const b = parseInt(hexColor.substring(5, 7), 16);
    
    // Apply a subtle background color to the form
    noteForm.style.backgroundColor = `rgba(${r}, ${g}, ${b}, 0.05)`;
    noteForm.style.borderLeft = `4px solid ${hexColor}`;
    
    // Update header accent
    const titleElement = document.querySelector('header .title strong');
    if (titleElement) {
        titleElement.style.color = hexColor;
    }
}

// Form validation before submission
document.addEventListener('DOMContentLoaded', function() {
    const noteForm = document.getElementById('noteForm');
    
    if (noteForm && !document.querySelector('.noteText').hasAttribute('readonly')) {
        noteForm.addEventListener('submit', function(event) {
            // Title validation
            const titleInput = document.getElementById('noteTitle');
            if (titleInput && titleInput.value.trim() === '') {
                event.preventDefault();
                alert('제목을 입력해주세요.');
                titleInput.focus();
                return false;
            }
            
            // Category validation
            const categorySelect = document.getElementById('noteCategory');
            if (categorySelect && categorySelect.value === '') {
                event.preventDefault();
                alert('카테고리를 선택해주세요.');
                categorySelect.focus();
                return false;
            }
            
            // Content validation
            const contentArea = document.getElementById('noteText');
            if (contentArea && contentArea.value.trim() === '') {
                event.preventDefault();
                alert('내용을 입력해주세요.');
                contentArea.focus();
                return false;
            }
            
            return true;
        });
    }
    
    // Initialize file input styling
    initFileInput();
});

// Enhanced file input
function initFileInput() {
    const fileInput = document.getElementById('noteAttachment');
    const fileList = document.getElementById('fileList');
    
    if (fileInput && fileList) {
        // 파일 선택 시 이벤트 처리
        fileInput.addEventListener('change', function() {
            const files = Array.from(this.files);
            
            // 기존 파일 목록 초기화
            fileList.innerHTML = '';
            
            files.forEach(file => {
                // 파일 크기 포맷팅
                const size = formatFileSize(file.size);
                
                // 파일 아이템 생성
                const fileItem = document.createElement('div');
                fileItem.className = 'fileItem';
                fileItem.innerHTML = `
                    <span class="fileName">${file.name}</span>
                    <span class="fileSize">${size}</span>
                    <button type="button" class="removeFile" onclick="removeFile(this, '${file.name}')">삭제</button>
                `;
                
                fileList.appendChild(fileItem);
            });
        });
    }
}

// 파일 제거 함수
function removeFile(button, fileName) {
    const fileInput = document.getElementById('noteAttachment');
    const fileList = button.parentElement;
    
    // DataTransfer 객체를 사용하여 파일 목록 업데이트
    const dt = new DataTransfer();
    const files = Array.from(fileInput.files);
    
    // 제거할 파일을 제외한 나머지 파일만 유지
    files.forEach(file => {
        if (file.name !== fileName) {
            dt.items.add(file);
        }
    });
    
    // 파일 입력 필드 업데이트
    fileInput.files = dt.files;
    
    // UI에서 파일 항목 제거
    fileList.remove();
}

// 파일 크기 포맷팅 함수
function formatFileSize(size) {
    if (size < 1024) return size + ' B';
    if (size < 1024 * 1024) return (size / 1024).toFixed(1) + ' KB';
    if (size < 1024 * 1024 * 1024) return (size / (1024 * 1024)).toFixed(1) + ' MB';
    return (size / (1024 * 1024 * 1024)).toFixed(1) + ' GB';
}
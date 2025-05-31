CREATE TABLE IF NOT EXISTS notes (
    id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11) NOT NULL,
    user_note_id INT(11) NOT NULL,
    category_id INT(11) NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    important BOOLEAN NOT NULL DEFAULT FALSE,
    color VARCHAR(7) NOT NULL DEFAULT '#4a6cf7',
    created_at TIMESTAMP NULL DEFAULT current_timestamp(),
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE current_timestamp(),
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    UNIQUE KEY unique_user_note_id (user_id, user_note_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- 유저별 노트 ID 자동 증가 트리거
DELIMITER //
CREATE TRIGGER IF NOT EXISTS before_note_insert
BEFORE INSERT ON notes
FOR EACH ROW
BEGIN
    DECLARE max_user_note_id INT;
    
    SELECT COALESCE(MAX(user_note_id), 0) INTO max_user_note_id
    FROM notes
    WHERE user_id = NEW.user_id;
    
    SET NEW.user_note_id = max_user_note_id + 1;
END//
DELIMITER ;
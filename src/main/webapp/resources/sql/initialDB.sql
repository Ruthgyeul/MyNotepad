-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS MyNotepadDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_uca1400_ai_ci;

USE MyNotepadDB;

-- 사용자 테이블 생성
CREATE TABLE IF NOT EXISTS users (
    id INT(11) NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NULL DEFAULT current_timestamp(),
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE current_timestamp(),
    PRIMARY KEY (id),
    UNIQUE KEY unique_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- 카테고리 테이블 생성
CREATE TABLE IF NOT EXISTS categories (
    id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11) NOT NULL,
    name VARCHAR(100) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NULL DEFAULT current_timestamp(),
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE current_timestamp(),
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_category_name_per_user (user_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- 노트 테이블 생성
CREATE TABLE IF NOT EXISTS notes (
    id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11) NOT NULL,
    category_id INT(11) NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    is_important BOOLEAN NOT NULL DEFAULT FALSE,
    color VARCHAR(7) DEFAULT '#ffffff',
    created_at TIMESTAMP NULL DEFAULT current_timestamp(),
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE current_timestamp(),
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- 노트 파일 테이블 생성
CREATE TABLE IF NOT EXISTS noteFiles (
    id INT(11) NOT NULL AUTO_INCREMENT,
    note_id INT(11) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    file_size INT(11) NOT NULL,
    file_type VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NULL DEFAULT current_timestamp(),
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE current_timestamp(),
    PRIMARY KEY (id),
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- 기본 카테고리 자동 생성 트리거
DELIMITER //
CREATE TRIGGER IF NOT EXISTS after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO categories (user_id, name, is_default) VALUES
        (NEW.id, '기본', TRUE);
END//
DELIMITER ;

-- 기존 사용자들을 위한 '기본' 카테고리 생성
INSERT INTO categories (user_id, name, is_default)
SELECT u.id, '기본', TRUE
FROM users u
LEFT JOIN categories c ON u.id = c.user_id AND c.name = '기본'
WHERE c.id IS NULL;

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

-- 기본 카테고리는 사용자 가입 시 자동으로 생성되도록 트리거 추가
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
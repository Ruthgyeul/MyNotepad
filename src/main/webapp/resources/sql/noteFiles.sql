CREATE TABLE IF NOT EXISTS noteFiles (
    id INT(11) NOT NULL AUTO_INCREMENT,
    note_id INT(11) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_content LONGTEXT NOT NULL,
    file_size INT(11) NOT NULL,
    file_type VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NULL DEFAULT current_timestamp(),
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE current_timestamp(),
    PRIMARY KEY (id),
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
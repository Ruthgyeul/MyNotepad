CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    label VARCHAR(50) NOT NULL
);

INSERT INTO categories (name, label) VALUES
     ('general', '일반'),
     ('etc', '기타');
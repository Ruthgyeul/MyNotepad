CREATE TABLE notes (
   id INT AUTO_INCREMENT PRIMARY KEY,
   user_id INT NOT NULL,
   display_id INT NOT NULL,
   category VARCHAR(255),
   title VARCHAR(255) NOT NULL,
   content TEXT,
   important BOOLEAN DEFAULT FALSE,
   color VARCHAR(50),
   updated_at TIMESTAMP NOT NULL,
   created_at TIMESTAMP NOT NULL
);
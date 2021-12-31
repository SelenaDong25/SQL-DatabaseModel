/* Program written by Xin Dong on November 15, 2019*/

/* Question 1*/
use my_drum_shop;
CREATE INDEX addresses_zip_code_ix ON addresses(zip_code);    

/* Question 2*/
DROP DATABASE IF EXISTS my_web_db;
CREATE DATABASE my_web_db CHARSET utf8;
USE my_web_db;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email_address VARCHAR(100),
    first_name VARCHAR(45) ,
    last_name VARCHAR(45) 
)  ENGINE=INNODB;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(45) NOT NULL
)  ENGINE=INNODB;
CREATE TABLE downloads (
    download_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    download_date DATETIME,
    filename VARCHAR(50),
    product_id INT NOT NULL,
    CONSTRAINT downloads_fk_users FOREIGN KEY (user_id)
        REFERENCES users (user_id),
    CONSTRAINT downloads_fk_products FOREIGN KEY (product_id)
        REFERENCES products (product_id)
)  ENGINE=INNODB;
CREATE INDEX downloads_download_date_ix ON downloads(download_date); 

    
/* Question 3*/
USE my_web_db;
INSERT INTO users(user_id, email_address, first_name, last_name) VALUES
( default, 'abc@lwtech.edu', 'Andrew', 'Longman'),
(default, 'ddle@gmail.com', 'Laura','Taylor');
INSERT INTO products(product_id, product_name) VALUES
(default, 'product A'),
(default, 'product B');
INSERT INTO downloads(download_id, user_id, download_date, filename, product_id) VALUES
(default,1,NOW(),'INTRODUCTION TO ...',2),
(default,2,NOW(),'OPERATOR GUIDE',1),
(default,2,NOW(),'COMM...',2);

/* Question 4*/
USE my_web_db;
SELECT 
    product_name, first_name, last_name
FROM
    products p
        JOIN
    downloads d ON p.product_id = d.product_id
        JOIN
    users u ON d.user_id = u.user_id
ORDER BY product_name, last_name, first_name;


/* Question 5*/
ALTER TABLE my_web_db.products 
ADD product_price DECIMAL(5,2) NOT NULL DEFAULT 9.99, 
ADD date_time datetime default now();


/* Question 6*/
ALTER TABLE my_web_db.users
MODIFY first_name VARCHAR(20) NOT NULL;

UPDATE users 
SET 
    first_name = NULL
WHERE
    user_id = 1;
    
UPDATE users 
SET 
    first_name = 'Andrew John George Eric'
WHERE
    user_id = 1;
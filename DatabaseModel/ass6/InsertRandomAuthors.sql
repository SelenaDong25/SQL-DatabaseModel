use rarebooks; 
DELIMITER ;
DROP FUNCTION IF EXISTS randomLetter;
DELIMITER //

-- function to return random letter 
CREATE FUNCTION randomLetter() RETURNS char NO SQL
BEGIN
  RETURN CONVERT(char(round(rand()*25)+97) USING utf8mb4);
END //

DELIMITER ;
DROP FUNCTION IF EXISTS randomString;
DELIMITER //

-- function to return random string
CREATE FUNCTION randomString(length INT) RETURNS varchar(50) NO SQL 
BEGIN
  DECLARE resultString varchar(50) default '';
  DECLARE i INT DEFAULT 0;
  
  WHILE i < length DO
    SET resultString = concat(resultString, randomLetter());
    SET i = i + 1;
  END WHILE;
  
  RETURN resultString;
END //

DELIMITER ;
DROP PROCEDURE IF EXISTS insert_publishers;

DELIMITER //
-- insert publishers
CREATE PROCEDURE insert_authors(authorsCount INT)
BEGIN
  DECLARE i INT DEFAULT 0;
  WHILE i < authorsCount DO
    INSERT INTO author VALUES (default, concat(randomString(rand()*10),' ', randomString(rand()*10)));
    SET i = i + 1;
  END WHILE;
END//
DELIMITER ;

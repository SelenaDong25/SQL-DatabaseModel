/* Program written by Xin Dong on November 21, 2019*/

use my_drum_shop;
/* Question 1*/
DROP PROCEDURE IF EXISTS test;
DELIMITER //
CREATE PROCEDURE test()
BEGIN 
	DECLARE product_count INT;

	SELECT 
		COUNT(*)
	INTO product_count FROM
		products;

	IF product_count >= 7 THEN 
		SELECT 'The number of products is greater than or equal to 7' AS message;
	ELSE 
		SELECT 'The number of products is less than 7' AS message;
	END IF;
END //
DELIMITER ;
CALL test();

            
/* Question 2*/
DROP PROCEDURE IF EXISTS test;
DELIMITER //
CREATE PROCEDURE test()
BEGIN 
	DECLARE product_count INT; 
    DECLARE price DECIMAL(10,2);

	SELECT 
		COUNT(*), AVG(list_price)
	INTO product_count, price FROM
		products;

	IF product_count >= 7 THEN 
		SELECT CONCAT('count: ',product_count,'; average price: ', price) AS message;
	ELSE 
		SELECT 'The number of products is less than 7' AS message;
	END IF;
END //
DELIMITER ;
CALL test();

    
/* Question 3*/
DROP PROCEDURE IF EXISTS test;
DELIMITER //
CREATE PROCEDURE test()
BEGIN 
	DECLARE factor1 INT;
    DECLARE factor2 INT;
    DECLARE i INT default 1;
    DECLARE result VARCHAR(400) DEFAULT '';
    
    SET factor1 = 10;
    SET factor2 = 20;
    SET result = 'common factors of 10 and 20: ';
    
    WHILE (i <= factor1) DO
		IF (factor1 % i = 0 AND factor2 % i = 0) THEN
			SET result = concat(result,i,' ');
		END IF;
        SET i = i+1;
	END WHILE;
	SELECT result AS message;
END //
DELIMITER ;
CALL test();


/* Question 4*/
DROP PROCEDURE IF EXISTS test;
DELIMITER //
CREATE PROCEDURE test()
BEGIN 
DECLARE product_name_var VARCHAR(255);
DECLARE list_price_var DECIMAL(10,2);
DECLARE row_not_found TINYINT DEFAULT FALSE;
DECLARE s_var VARCHAR(400) DEFAULT '';

DECLARE price_cursor CURSOR FOR
	SELECT 
		product_name, list_price
	FROM
		products
	WHERE
		list_price > 700
	ORDER BY list_price DESC;
DECLARE CONTINUE HANDLER FOR NOT FOUND
	SET row_not_found = TRUE;
    
OPEN price_cursor;
FETCH price_cursor INTO product_name_var, list_price_var;
WHILE row_not_found = FALSE DO
    SET s_var = CONCAT(s_var,'"',product_name_var,'"',', ','"',list_price_var,'"',' | ');
	FETCH price_cursor INTO product_name_var, list_price_var;
END WHILE;
SELECT s_var AS message;
END//
DELIMITER ;
CALL test();

/* Question 5*/
DROP PROCEDURE IF EXISTS test;
DELIMITER //
CREATE PROCEDURE test()
BEGIN
DECLARE duplicate_entry_key TINYINT DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR 1062
	SET duplicate_entry_key = TRUE;
INSERT INTO categories(category_name) VALUES('Guitars');    

IF duplicate_entry_key = TRUE THEN
	SELECT 'Row was not inserted - duplicate entry.' AS message;
ELSE
	SELECT '1 row was updated.' AS message;
END IF;
END//
DELIMITER ;
CALL test();
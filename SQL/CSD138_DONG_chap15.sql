/* Program written by Xin Dong on November 21, 2019*/

use my_drum_shop;
/* Question 1*/
DROP PROCEDURE IF EXISTS insert_category;
DELIMITER //
CREATE PROCEDURE insert_category
( 
  category_name_param   VARCHAR(50)
)
BEGIN
  INSERT INTO categories(category_name)
  VALUES (category_name_param);
END//
DELIMITER ;
-- Test fail: 
CALL insert_category('Guitars');
-- Test pass: 
CALL insert_category('Woodwind');

            
/* Question 2*/
DROP FUNCTION IF EXISTS discount_price;
DELIMITER //
CREATE FUNCTION discount_price(item_id_param INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC READS SQL DATA
BEGIN 
	DECLARE discount_price_var DECIMAL(10,2); 
	SELECT 
		item_price - discount_amount 
	INTO discount_price_var FROM
		order_items
	WHERE item_id = item_id_param;
    RETURN(discount_price_var);
     
END //
DELIMITER ;
SELECT DISCOUNT_PRICE(3);
    
/* Question 3*/
DROP FUNCTION IF EXISTS item_total;
DELIMITER //
CREATE FUNCTION item_total(item_id_param INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC READS SQL DATA
BEGIN 
	DECLARE total_price_var DECIMAL(10,2);
    SELECT quantity * discount_price(item_id_param) INTO total_price_var FROM
		order_items
	WHERE item_id = item_id_param;
    RETURN(total_price_var);

END //
DELIMITER ;
SELECT ITEM_TOTAL(5);


/* Question 4*/
DROP PROCEDURE IF EXISTS insert_products;
DELIMITER //
CREATE PROCEDURE insert_products(
category_id_param INT, 
product_code_param VARCHAR(10), 
product_name_param VARCHAR(255),
list_price_param DECIMAL(10,2),
discount_percent_param DECIMAL(10,2))
BEGIN 
IF list_price_param < 0 THEN 
	SIGNAL SQLSTATE '22003'
    SET MESSAGE_TEXT = 'This column doesn’t accept negative numbers.',
    MYSQL_ERRNO = 1264;
ELSEIF discount_percent_param < 0 THEN 
	SIGNAL SQLSTATE '22003'
    SET MESSAGE_TEXT = 'This column doesn’t accept negative numbers.',
    MYSQL_ERRNO = 1264;
END IF;
INSERT INTO products 
VALUES(DEFAULT,category_id_param,product_code_param,product_name_param,
    '', list_price_param,discount_percent_param, now());
END//
DELIMITER ;
CALL insert_products(3,'codetest', 'nametestabc',100.34, 0.21);
CALL insert_products(3,'codetest1', 'nametestdef',-100.34, 0.21);

/* Question 5*/
DROP PROCEDURE IF EXISTS update_product_discount;
DELIMITER //
CREATE PROCEDURE update_product_discount(
	product_id_param INT,
	discount_percent_param DECIMAL(10,2)
)
BEGIN
IF discount_percent_param < 0 THEN 
	SIGNAL SQLSTATE '22003'
    SET MESSAGE_TEXT = 'This column doesn’t accept negative numbers.',
    MYSQL_ERRNO = 1264;
END IF;
UPDATE products 
SET 
    discount_percent = discount_percent_param
WHERE
    product_id = product_id_param; 
END//
DELIMITER ;
CALL update_product_discount(2, 30);
CALL update_product_discount(2, -20);
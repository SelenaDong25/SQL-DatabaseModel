/* Program written by Xin Dong on November 30, 2019*/

use my_drum_shop;
/* Question 1*/
DROP PROCEDURE IF EXISTS test; 
DELIMITER // 
CREATE PROCEDURE test() 
BEGIN 
DECLARE sql_error TINYINT DEFAULT FALSE; 
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE; 
START TRANSACTION;
DELETE FROM addresses 
WHERE
    customer_id = 8;
DELETE FROM customers 
WHERE
    customer_id =8; 
IF sql_error = TRUE then ROLLBACK;
SELECT 'Transaction rolled back.'; 
ELSE COMMIT;
SELECT 'Transaction committed.'; 
END IF; 
END // 
DELIMITER ; 
call test();

            
/* Question 2*/
DROP PROCEDURE IF EXISTS test; 
DELIMITER // 
CREATE PROCEDURE test() 
BEGIN 
DECLARE order_id_var INT(11); 
DECLARE sql_error TINYINT DEFAULT FALSE; 
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE; 
START TRANSACTION;

INSERT INTO orders VALUES
(DEFAULT, 3, NOW(), '10.00', '0.00', NULL, 4, 
'American Express', '378282246310005', '04/2016', 4);

SELECT LAST_INSERT_ID() INTO order_id_var;

INSERT INTO order_items VALUES
(DEFAULT, order_id_var, 6, '415.00', '161.85', 1);

INSERT INTO order_items VALUES
(DEFAULT, order_id_var, 1, '699.00', '209.70', 1);

IF sql_error = TRUE then ROLLBACK;
SELECT 'Transaction rolled back.'; 
ELSE COMMIT;
SELECT 'Transaction committed.'; 
END IF; 
END // 
DELIMITER ; 
call test();
    
/* Question 3*/
DROP PROCEDURE IF EXISTS test; 
DELIMITER // 
CREATE PROCEDURE test() 
BEGIN 
DECLARE customer_id_var INT(11); 
DECLARE shipping_address_id_var INT(11);
DECLARE sql_error TINYINT DEFAULT FALSE; 
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE; 
START TRANSACTION;
SELECT 
    customer_id, shipping_address_id
INTO customer_id_var, shipping_address_id_var FROM
    customers
WHERE
    email_address = 'christineb@solarone.com';
        
SELECT 
    customer_id, order_id, ship_address_id, billing_address_id
FROM
    orders
WHERE
    customer_id = customer_id_var;

SELECT 
    customer_id,
    email_address,
    shipping_address_id,
    billing_address_id
FROM
    customers
WHERE
    customer_id = customer_id_var;

SELECT 
    customer_id, address_id, line1, city, state, zip_code, phone
FROM
    addresses
WHERE
    customer_id = customer_id_var;

INSERT INTO addresses VALUES
(DEFAULT, customer_id_var, '1 Main Street',DEFAULT, 'Bellevue', 'WA',DEFAULT, 98004, '425-425-4255',DEFAULT);

SELECT LAST_INSERT_ID() INTO shipping_address_id_var;

UPDATE customers 
SET 
    shipping_address_id = shipping_address_id_var
WHERE
    customer_id = customer_id_var;
    
UPDATE orders 
SET 
    ship_address_id = shipping_address_id_var
WHERE
    customer_id = customer_id_var;

IF sql_error = TRUE then ROLLBACK;
SELECT 'Transaction rolled back.'; 
ELSE COMMIT;
SELECT 'Transaction committed.'; 
END IF; 
END // 
DELIMITER ; 
call test();


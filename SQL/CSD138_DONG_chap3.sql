/* Program written by Xin Dong on September 30, 2019*/

/* Question 1*/
use my_drum_shop;
SELECT 
    first_name,
    last_name,
    CONCAT(last_name, ', ', first_name) AS full_name
FROM
    customers
WHERE
    LEFT(last_name, 1) BETWEEN 'E' AND 'R'
ORDER BY last_name DESC;

/* Question 2*/
use my_drum_shop;
SELECT 
    product_name, list_price, date_added, description
FROM
    products
WHERE
    list_price BETWEEN 100 AND 1500
ORDER BY date_added;

/* Question 3*/
use my_drum_shop;
SELECT 
    product_name,
    list_price,
    discount_percent,
    ROUND(list_price * discount_percent, 2) AS discount_amount,
    ROUND(list_price - list_price * discount_percent,
            2) AS discount_price
FROM
    products
ORDER BY discount_price
LIMIT 4 , 10;

/* Question 4*/
use my_drum_shop;
SELECT 
    item_id,
    item_price,
    discount_amount,
    quantity,
    item_price * quantity AS price_total,
    discount_amount * quantity AS discount_total,
    quantity * (item_price - discount_amount) AS item_total
FROM
    order_items
WHERE (quantity * (item_price - discount_amount)) < 500
ORDER BY item_total;

/* Question 5*/
use my_drum_shop;
SELECT 
    order_id, order_date, ship_date, ship_amount
FROM
    orders
WHERE
    ship_date IS NULL
ORDER BY order_date DESC;

/* Question 6*/
SELECT 
    NOW() AS today_unformated,
    DATE_FORMAT(NOW(), '%m/%d/%Y') AS today_formatted;

/* Question 7*/
SELECT 
    1000 AS price,
    0.09 AS tax_rate,
    1000 * 0.09 AS tax_amount,
    1000 + 1000 * 0.09 AS total

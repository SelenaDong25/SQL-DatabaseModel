/* Program written by Xin Dong on November 9, 2019*/

/* Question 1*/
use my_drum_shop;
SELECT 
    list_price,
    discount_percent,
    ROUND(list_price * discount_percent / 100, 2) AS discount_amount
FROM
    products;
    
    
/* Question 2*/
SELECT 
    order_date,
    DATE_FORMAT(order_date, '%Y'),
    DATE_FORMAT(order_date, '%b-%d-%Y'),
    DATE_FORMAT(order_date, '%h:%i %p'),
    DATE_FORMAT(order_date, '%m/%d/%y %H:%i')
FROM
    orders;
    
/* Question 3*/
SELECT 
    product_name,
    card_number,
    LENGTH(card_number),
    RIGHT(card_number, 4),
    CONCAT('XXXX-XXXX-XXXX-', RIGHT(card_number, 4)) AS XXXX_last_four,
    IF(SUBSTRING_INDEX(SUBSTRING_INDEX(product_name, ' ', 2),
                ' ',
                - 1) != SUBSTRING_INDEX(SUBSTRING_INDEX(product_name, ' ', 3),
                ' ',
                - 1),
        SUBSTRING_INDEX(SUBSTRING_INDEX(product_name, ' ', 3),
                ' ',
                - 1),
        ' ') AS third_name
FROM
    products p
        JOIN
    order_items oi ON p.product_id = oi.product_id
        JOIN
    orders o ON oi.order_id = o.order_id
ORDER BY product_name;


/* Question 4*/
SELECT 
    order_id,
    DATE_FORMAT(order_date, '%Y-%m-%d'),
    DATE_ADD(DATE_FORMAT(order_date, '%Y-%m-%d'),
        INTERVAL 2 DAY) AS approx_ship_date,
    ship_date,
    DATEDIFF(ship_date, order_date) AS days_to_ship
FROM
    orders
WHERE
    DATE_FORMAT(order_date, '%M %Y') = 'March 2015';
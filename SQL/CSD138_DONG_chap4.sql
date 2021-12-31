/* Program written by Xin Dong on October 6, 2019*/

/* Question 1*/
use my_drum_shop;
SELECT 
    product_name AS product,
    category_name AS category,
    list_price AS price
FROM
    products
        INNER JOIN
    categories ON products.category_id = categories.category_id
ORDER BY category , price;

/* Question 2*/
use my_drum_shop;
SELECT 
    last_name AS Last,
    first_name AS First,
    CONCAT(line1,
            ', ',
            city,
            ', ',
            state,
            ', ',
            zip_code,
            '') AS Address
FROM
    customers
        INNER JOIN
    addresses ON customers.customer_id = addresses.customer_id
WHERE
    email_address != 'erinv@gmail.com'
ORDER BY Last , First;

/* Question 3*/
use my_drum_shop;
SELECT 
    last_name AS Last,
    first_name AS First,
    CONCAT(line1,
            ', ',
            city,
            ', ',
            state,
            ', ',
            zip_code,
            '') AS Billing_Address
FROM
    customers
       INNER JOIN
    addresses ON customers.customer_id = addresses.customer_id
WHERE
    address_id = billing_address_id
ORDER BY Last DESC;


/* Question 4*/
use my_drum_shop;
SELECT 
    last_name,
    first_name,
    order_date,
    product_name,
    item_price,
    discount_amount,
    quantity
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
        INNER JOIN
    products p ON oi.product_id = p.product_id
ORDER BY last_name , order_date , product_name;

/* Question 5*/
SELECT DISTINCT 
    a.product_name, a.list_price
FROM
    products a
        JOIN
    products b ON a.product_id <> b.product_id
        AND a.list_price = b.list_price
ORDER BY product_name DESC;

/* Question 6*/
SELECT 
    category_name, product_id
FROM
    categories c
        LEFT OUTER JOIN
    products p ON c.category_id = p.category_id
WHERE
    p.product_id IS NULL
ORDER BY category_name DESC;

/* Question 7*/
SELECT 
    'SHIPPED' AS ship_status, order_id, order_date
FROM
    orders
WHERE
    ship_date IS NOT NULL 
UNION SELECT 
    'NOT SHIPPED' AS ship_status, order_id, order_date
FROM
    orders
WHERE
    ship_date IS NULL
ORDER BY order_date DESC;

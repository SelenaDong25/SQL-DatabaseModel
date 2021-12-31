/* Program written by Xin Dong on October 14, 2019*/

/* Question 1*/
use my_drum_shop;
SELECT 
    COUNT(*) AS number_of_products,
    SUM(list_price) AS total_price
FROM
    products;

/* Question 2*/
use my_drum_shop;
SELECT 
    category_name,
    product_name,
    COUNT(product_name) AS number_of_products,
    ROUND(AVG(list_price), 2) AS avg_price
FROM
    products
        INNER JOIN
    categories ON products.category_id = categories.category_id
GROUP BY category_name, product_name
ORDER BY number_of_products DESC;

/* Question 3*/
use my_drum_shop;
SELECT 
    email_address,
    SUM(item_price * quantity) AS total_cost,
    SUM(discount_amount * quantity) AS total_discount
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY email_address 
ORDER BY total_cost;


/* Question 4*/
SELECT 
    email_address, 
    COUNT(o.order_id) AS numer_of_orders,
    SUM((item_price - discount_amount) * quantity) AS total_amount
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id

GROUP BY email_address
HAVING numer_of_orders < 3
ORDER BY total_amount;


/* Question 5*/
SELECT 
    email_address,
    COUNT(o.order_id) AS numer_of_orders,
    SUM((item_price - discount_amount) * quantity) AS total_amount
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
WHERE item_price > 500
GROUP BY email_address
HAVING numer_of_orders < 3
ORDER BY total_amount;

/* Question 6*/
SELECT 
    product_name AS product,
    SUM((item_price - discount_amount) * quantity) AS total_amount
FROM
    products p
        INNER JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY product WITH ROLLUP
ORDER BY product DESC;

/* Question 7*/
SELECT 
    email_address,
    COUNT(DISTINCT product_id) AS distinct_product_count
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY email_address
HAVING distinct_product_count > 1
ORDER BY distinct_product_count DESC

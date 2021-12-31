/* Program written by Xin Dong on October 14, 2019*/

/* Question 1*/
use my_drum_shop;
SELECT category_name
FROM categories WHERE category_id
  IN (SELECT category_id FROM products)
ORDER BY category_name;

/* Question 2*/
SELECT 
    product_name, list_price
FROM
    products
WHERE
    list_price > (SELECT 
            AVG(list_price)
        FROM
            products)
GROUP BY product_name, list_price
ORDER BY list_price DESC;

/* Question 3*/
SELECT 
    category_name
FROM
    categories
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            products
        WHERE
            category_id = categories.category_id);


/* Question 4*/
/*First Portion */
SELECT 
    email_address,
    o.order_id,
    SUM((item_price - discount_amount) * quantity) AS order_total
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY email_address , order_id;

/* Second Portion */  
WITH t1 AS (SELECT 
        email_address,
            o.order_id,
            SUM((item_price - discount_amount) * quantity) AS order_total
    FROM
        customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY email_address, order_id ),
t2 AS (SELECT 
    email_address, MAX(order_total) AS max_order_total
FROM
     t1 
     GROUP BY email_address)
SELECT 
    t2.email_address, order_id, max_order_total
FROM
    t2
        JOIN
    t1 ON t1.email_address = t2.email_address
        AND max_order_total = order_total
GROUP BY email_address , order_id;


/* Question 5*/
SELECT 
    product_name, discount_percent
FROM
    products
WHERE
    discount_percent NOT IN (SELECT 
            discount_percent
        FROM
            products
		GROUP BY discount_percent
        HAVING COUNT(*) > 1 )

ORDER BY product_name;

/* Question 6*/
SELECT 
    email_address, order_id, order_date
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
where order_date = (select min(order_date) from orders where customer_id = c.customer_id)
GROUP BY email_address,order_id, order_date;



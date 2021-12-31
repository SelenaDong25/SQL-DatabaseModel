/* Program written by Xin Dong on November 16, 2019*/

/* Question 1*/
use my_drum_shop;
CREATE VIEW customer_addresses AS
    SELECT 
        c.customer_id,
        email_address,
        last_name,
        first_name,
        a1.line1 AS bill_line1,
        a1.line2 AS bill_line2,
        a1.city AS bill_city,
        a1.state AS bill_state,
        a1.zip_code AS bill_zip,
        a2.line1 AS ship_line1,
        a2.line2 AS ship_line2,
        a2.city AS ship_city,
        a2.state AS ship_state,
        a2.zip_code AS ship_zip
    FROM
        customers c
            JOIN
        addresses a1 ON c.customer_id = a1.customer_id
            AND c.billing_address_id = a1.address_id
            JOIN
        addresses a2 ON c.customer_id = a2.customer_id
            AND c.shipping_address_id = a2.address_id;
            
            
/* Question 2*/
SELECT 
    customer_id, last_name, first_name, bill_line1
FROM
    customer_addresses;

    
/* Question 3*/
UPDATE customer_addresses 
SET 
    ship_line1 = '1990 Westwood Blvd.'
WHERE
    customer_id = 8;

/* Question 4*/
CREATE VIEW order_item_products AS
SELECT 
    o.order_id,
    order_date,
    tax_amount,
    ship_date,
    item_price,
    discount_amount,
    item_price - discount_amount AS final_price,
    quantity,
    (item_price - discount_amount) * quantity AS item_total,
    product_name
FROM
    orders o
        JOIN
    order_items oi ON o.order_id = oi.order_id
        JOIN
    products p ON oi.product_id = p.product_id;


/* Question 5*/
CREATE VIEW product_summary AS
    SELECT 
        product_name,
        COUNT(order_id) AS order_count,
        SUM(item_total) AS order_total
    FROM
        order_item_products
    GROUP BY product_name;


/* Question 6*/
SELECT 
    SUM(sub.order_total) AS top5_selling_sum
FROM
    (SELECT 
        order_total
    FROM
        product_summary
    ORDER BY order_total DESC
    LIMIT 5) sub

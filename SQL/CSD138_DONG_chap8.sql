/* Written by Xin Dong, Oct 29, 2019 */
/* Question 1 */
use my_drum_shop;
SELECT 
    list_price,
    FORMAT(list_price, 1),
    CONVERT( list_price , SIGNED), 
    CAST(list_price AS SIGNED)
FROM
    products;

/* Question 2 */
SELECT 
    date_added,
    CAST(date_added AS DATE),
    CAST(date_added AS CHAR (7)),
    CAST(date_added AS TIME)
FROM
    products;
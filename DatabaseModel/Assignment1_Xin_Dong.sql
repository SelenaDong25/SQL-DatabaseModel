/* Module 1 Assignment */
/* Xin Dong */

-- Run the create_rare_books.sql script found under Database
-- Scripts in Canvas then answer each of the questions below.
-- Each question is worth 10 points.

use rarebooks;

-- Exercise 1 
-- Show the count of books currently in stock for each 
-- condition description (i.e., Poor, Good, Fine, etc.).
-- Hint: For this problem you need to find books that have Volumes that do Not have sales!
SELECT 
    c.condition_description, COUNT(v.condition_code) AS count
FROM
    volume AS v
        JOIN
    condition_codes AS c ON v.condition_code = c.condition_code
WHERE
    v.sale_id IS NULL
GROUP BY condition_description;

-- Exercise 2
-- Show the total book sales for each condition description and
-- order the result by the highest sales first.
SELECT 
    c.condition_description,
    SUM(s.sale_total_amt) AS total_sales
FROM
    volume AS v
        JOIN
    condition_codes AS c ON v.condition_code = c.condition_code
        JOIN
    sale AS s ON v.sale_id = s.sale_id
GROUP BY condition_description
ORDER BY total_sales desc;

-- Exercise 3
-- Find the inventory count for every book in stock by author name 
-- and book title.  Sort the result by author name then title, both
-- in ascending order.
-- Hint: For this problem you need to find books that have Volumes that do Not have sales!
SELECT 
    a.author_last_first, w.title, COUNT(v.inventory_id) AS count
FROM
    author AS a
        JOIN
    work AS w ON a.author_numb = w.author_numb
        JOIN
    book AS b ON w.work_numb = b.work_numb
        JOIN
    volume AS v ON b.ISBN = v.ISBN
    WHERE
    v.sale_id IS NULL
GROUP BY a.author_last_first , w.title
ORDER BY a.author_last_first , w.title;

-- Exercise 4
-- Get the count of books in stock from each publisher.  Show the
-- ISBN, title, publisher name, edition, binding, copyright year,
-- and count of books in stock, ordered by publisher name ascending.
-- Hint: For this problem you need to find books that have Volumes that do Not have sales!
SELECT 
    b.ISBN,
    w.title,
    p.publisher_name,
    b.edition,
    b.binding,
    b.copyright_year,
    COUNT(v.inventory_id) AS inventory
FROM
    book AS b
        JOIN
    work AS w ON b.work_numb = w.work_numb
        JOIN
    publisher AS p ON b.publisher_id = p.publisher_id
        JOIN
    volume AS v ON b.ISBN = v.ISBN
    WHERE
    v.sale_id IS NULL
GROUP BY p.publisher_name, b.ISBN
ORDER BY p.publisher_name;

-- Exercise 5
-- Generate a sales report showing the daily sales for all book 
-- sales in the year 2021, with subtotals for month and year.
SELECT 
    sale_date,
    SUBSTRING(sale_date, 6, 2) AS month,
    SUM(sale_total_amt) AS total_sale
FROM
    sale
WHERE
    sale_date > 2021
GROUP BY month , sale_date WITH ROLLUP;

-- Exercise 6
-- Show the book inventory id, title, condition description and
-- selling price for books that had a selling price higher 
-- than the average selling price of books sold in July, 2021, 
-- sorted by title in ascending order.
SELECT 
    v.inventory_id,
    w.title,
    c.condition_description,
    v.selling_price
FROM
    volume AS v
        JOIN
    book ON v.ISBN = book.ISBN
        JOIN
    work AS w ON book.work_numb = w.work_numb
        JOIN
    condition_codes AS c ON v.condition_code = c.condition_code
WHERE
    v.selling_price > (SELECT 
            AVG(v.selling_price)
        FROM
            volume AS v
                JOIN
            sale AS s ON v.sale_id = s.sale_id
        WHERE
            s.sale_date BETWEEN '2021-07-01' AND '2021-07-31')
 order by w.title;
 
-- Exercise 7
-- Generate the best seller list for July, 2021
-- Along with author and title, give the number of copies sold
-- and the total sales amount for each book.  Order the
-- result by copies sold in descending order.
-- Hint: You might try writing the query for copies sold first
SELECT 
    a.author_last_first AS author_name,
    w.title,
    t1.copies,
    SUM(v.selling_price) AS total_sales
FROM
    volume AS v
        JOIN
    book ON v.ISBN = book.ISBN
        JOIN
    work AS w ON book.work_numb = w.work_numb
        JOIN
    author AS a ON w.author_numb = a.author_numb
        JOIN
    (SELECT 
        ISBN, COUNT(ISBN) AS copies
    FROM
        volume
    WHERE
        sale_id IS NOT NULL
    GROUP BY ISBN) t1 ON v.ISBN = t1.ISBN
        JOIN
    sale AS s ON v.sale_id = s.sale_id
WHERE
    s.sale_date BETWEEN '2021-07-01' AND '2021-07-31'
GROUP BY v.ISBN
ORDER BY copies DESC;

-- Exercise 8
-- Give statements to insert a new sale for customer id 3 of the 
-- volume with inventory_id 67 on 11/3/2021 for $125 with credit 
-- card number 1234 5678 9101 4321, expiration month 7, expiration 
-- year 23.
insert into sale values (default, 3, '2021-11-03', 125, '1234 5678 9101 4321', 7, 23);
UPDATE volume 
SET 
    sale_id = (SELECT 
            sale_id
        FROM
            sale
        WHERE
            customer_numb = 3),
    selling_price = 125
WHERE
    inventory_id = 67;

-- Exercise 9
-- Add the JK Rowling book "Harry Potter and Sorcerer's Stone"
-- to the rare book inventory.  This first edition book acquired
-- on 3/1/2018 is in excellent condition and has the ISBN 
-- 978-0-78622-272-8, a leather binding, the copyright year 1999 
-- from the publisher Thorndike Press and an asking price of $100.
insert into publisher value (default, 'Thorndike Press');
insert into author value (default, 'Rowling,JK');
INSERT into work value (default, (select author_numb from author where author_last_first = 'Rowling,JK'),
"Harry Potter and Sorcerer's Stone");
insert into book value ('978-0-78622-272-8',(select work_numb from work where title = "Harry Potter and Sorcerer's Stone"), 
(select publisher_id from publisher where publisher_name = 'Thorndike Press'), 1, 'leather', 1999);
INSERT INTO volume value (default, '978-0-78622-272-8', 
(select condition_code from condition_codes where condition_description = 'excellent'),
'2018-03-01', 100, default, default);


-- Exercise 10
-- Delete the publisher Thorndike Press from the Rare Books 
-- inventory.  Make sure to handle the case in which there are 
-- more than one book in inventory from Thorndike PRess
DELETE FROM volume 
WHERE
    ISBN = (SELECT 
        ISBN
    FROM
        book
    
    WHERE
        publisher_id = (SELECT 
            publisher_id
        FROM
            publisher
        
        WHERE
            publisher_name = 'Thorndike Press'));
DELETE FROM book 
WHERE
    publisher_id =(SELECT 
        publisher_id
    FROM
        publisher
    WHERE
        publisher_name = 'Thorndike Press');
DELETE FROM publisher 
    WHERE
        publisher_name = 'Thorndike Press';

	
use rarebooks;

/* Problem #1  */
CREATE OR REPLACE VIEW p1 AS
    SELECT 
        a.author_last_first, c.condition_description
    FROM
        book b
            JOIN
        volume v USING (ISBN)
            JOIN
        condition_codes c USING (condition_code)
            JOIN
        work w USING (work_numb)
            JOIN
        author a USING (author_numb)
    WHERE
        c.condition_description = 'good';
        
        
/* Problem #2  */
/* The query works because the view is an updatable view which means it 
was created without DISTINCT clause, no aggregate functions, no GROUPBY or 
HAVING clause, no UNION operator. */
UPDATE p1 
SET 
    author_last_first = 'Dong, Xin'
WHERE
    author_last_first = 'Barth, John';
    
/* Problem #3  */
CREATE OR REPLACE VIEW p3 AS
    SELECT 
        author_last_first, COUNT(DISTINCT ISBN) AS volume
    FROM
        book b
            JOIN
        volume v USING (ISBN)
            JOIN
        work w USING (work_numb)
            JOIN
        author a USING (author_numb)
    GROUP BY author_last_first;
    
/* Problem #4 */
/* The query does not work because the view is not updatable. 
The view is created with DISTINCT and GROUP BY clause thus 
it is not updatable. */

/* Problem #5 */
CREATE TEMPORARY TABLE p5(book_title char(50) PRIMARY KEY, publisher_name char(50), avg_asking_price decimal (7,2)); 
INSERT INTO p5 
	SELECT title, publisher_name, AVG(asking_price) 
	FROM book b 
		JOIN 
        volume v USING (ISBN)
		JOIN
		work w USING (work_numb)
		JOIN
		publisher p using (publisher_id);

 /* Problem #6 */ 
 /* It takes 0.016 sec for the first run, then the rest spend 
  0.000 sec each time, so the average time is 0.0032 sec */
DROP PROCEDURE IF EXISTS find_author;
DELIMITER //
-- find authors
CREATE PROCEDURE find_author(authorInput char(128))
BEGIN
  DECLARE author_name char(128) default '';
SELECT 
    author_last_first
INTO author_name FROM
    author
WHERE
    author_last_first = authorInput;
    END//
DELIMITER ;
	 
/* Problem #7 */ 
/* call the procedure insert_author(1000) 5 times, time spending is
15.922, 17.297, 15.156, 15.188, 8.937 sec. So the average time
spending is 14.5 sec. */ 

/* Problem #8 */ 
/* 
--rerun #6 5 times, time spending is 0.062, 0.015, 0.032, 0.016, 0.031 sec. So the average 
time spending is 0.0312 sec. 
-- create index for author table on column author_lst_first to improve the performance. 
After this fix, the run time become 0.000 sec for each time and average is 0.000 sec as well. */ 

CREATE INDEX author_index on author(author_last_first);

/* Problem #9 */ 
/* --run insert_authors(1000) 5 times and run time are 12.157, 11.109, 11.062, 11.406, 10.891 sec, average run time is 11.325 sec.
Since index slow down insert operation, we see longer time for insert_author(1000) after author table is indexed.
Run the procedure find_author 5 times and the run time are all 0.000 sec so average run time is 0.000 sec.
Because the author table is indexed, when the procedure look up an author name, it only go to index pointer so run faster.
*/

/* Problem #10 */
ALTER TABLE publisher
ADD preferred BOOLEAN DEFAULT FALSE;

/* Running this query spend 0.000 sec for each time and average is 0.000 sec. */
use rarebooks;
SELECT 
    publisher_name, preferred
FROM
    publisher
WHERE
    publisher_name = 'Macmillan';
    
/* Problem #11 */
/* Run procedure insert_publisher(1000) 5 times, spend 10.234, 10.141, 10.125, 10.032, 8.985 sec,
average time is 9.903 sec. */

/* Problem #12 */
/* Running query in #10 5 times, spend 0.015, 0.000, 0.015, 0.015, 0.000 sec, average is 0.009 sec.
Create index to improve the performance.
After fix, running query spend 0.000 sec. */
CREATE INDEX publisher_name_preferred_index ON publisher (publisher_name, preferred);  



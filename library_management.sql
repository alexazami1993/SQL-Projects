SELECT
	*
	FROM books;

SELECT
	*
	FROM branch;

SELECT
	*
	FROM employees;

SELECT
	*
	FROM issued_status;

SELECT
	* FROM return_status;

-- Project Task

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('78-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;


--Task 2: Update a members existing address
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';


--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS121'

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT
	*
	FROM issued_status
	WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT
	issued_emp_id,
	COUNT(issued_id)
FROM issued_status
GROUP BY 1
HAVING COUNT(issued_id) > 1;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts
SELECT 
b.isbn,
b.book_title,
COUNT(ist.issued_id) AS no_issued
FROM books b
JOIN issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2;

-- task 7: Retrieve all books in a specific category
SELECT
	*
	FROM books
	WHERE category = 'Classic'


--Task 8: Find Total Rental Income by Category:

SELECT
	b.category,
	SUM(b.rental_price)
FROM books b
JOIN
issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;


--List Members Who Registered in the Last 180 Days:

SELECT
	*
	FROM members
	WHERE reg_date >= CURRENT_DATE - INTERVAL '180 DAYS';


INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES('C120','sam','145 Main St','2024-06-01'),
('C121','john','133 Main St','2024-05-01');

-- List Employees with Their Branch Manager's Name and their branch details:


SELECT
	e.*,
	b.branch_id,
	e2.emp_name as manager
	FROM employees e JOIN branch b ON b.branch_id = e.branch_id
	JOIN employees e2 ON b.manager_id = e.emp_id;
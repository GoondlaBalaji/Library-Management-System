select * from books;
select * from branch;
select * from employees;
select * from members;
select * from issued_status;
select * from return_status

--CRUD Operations

--Task 1. Create a New Book Record 
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn ,book_title, category ,rental_price	,status, author, publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 
'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT*FROM books;

--Task 2: Update an Existing Member's Address whose member_id is C103

UPDATE members
SET member_address='125 Oak St'
WHERE member_id  ='C103';

--Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id = 'IS121'

-- if we try delete IS104 then we get an error this because of that id dependent on another column

--Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status WHERE issued_emp_id = 'E101'

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT * FROM issued_status -- for reference

SELECT issued_member_id ,
count(*) from issued_status
group by 1

having count(*) > 1

--CTAS (Create Table As Select)

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt
create table book_count as
select b.isbn,
 b.book_title,
count(ist.issued_id) as no_issue 
from books as b 
join issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1,2

select * from book_count

-- Data Analysis & Findings
--Task 7. Retrieve All Books in a Specific(one category) Category:

select * from books 
where category = 'Classic'

-- Task 8: Find Total Rental  by Category:
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn --it match both coloumn in table then it combine as one column in a one table
GROUP BY 1

-- below one wrong method it calculates all books price includind not issued books also
select * from books

select category,
sum(rental_price) as rental_price , count(*) from books
group by 1;

--What this does:
--It sums all rental prices and counts all books from the books table, grouped by category.
--BUT ❌ this includes all books — even books that were never issued (never rented).

-- So:
-- Gives you total potential rental price by category.
-- Does not reflect the actual rental income (because some books may never have been issued).


--Task 9: List Members Who Registered in the Last 180 Days:
select * from members 
where reg_date >= current_date - interval '180 days';

insert into members(member_id ,member_name ,member_address, reg_date)
values ('C144','poti','banglore','2025-05-7'),
 ('C145','balz','hyderbad','2025-04-25')

--Task 10: List Employees with Their Branch Manager's Name and their branch details:

select * from branch;

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

SELECT * FROM expensive_books

--Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

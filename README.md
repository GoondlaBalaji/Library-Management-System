# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/najirh/Library-System-Management---P2/blob/main/library_erd.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
-- Library management System Project

--creating a branch table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
	branch_id VARCHAR(10) PRIMARY KEY,	
	manager_id	VARCHAR(10),
	branch_address 	VARCHAR(20),
	contact_no INT
);

DROP TABLE IF EXISTS employees;
CREATE TABLE  employees(
	emp_id	VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(30),
	position VARCHAR(20),
	salary DECIMAL(10,2),
	branch_id VARCHAR(10),
	--FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

DROP TABLE IF EXISTS books;
CREATE TABLE books(
	isbn	VARCHAR(20) PRIMARY KEY,
	book_title VARCHAR(75),
	category	VARCHAR(20),
	rental_price FLOAT,
	status	VARCHAR(10),
	author VARCHAR(35),
	publisher VARCHAR(55)
);

DROP TABLE IF EXISTS members;
CREATE TABLE members(
	member_id VARCHAR(10) PRIMARY KEY,	
	member_name VARCHAR(30),
	member_address VARCHAR(30),	
	reg_date DATE
);

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
	issued_id VARCHAR(20) PRIMARY KEY,
	issued_member_id	 VARCHAR(20),
	issued_book_name VARCHAR(30),	
	issued_date DATE,
	issued_book_isbn VARCHAR(20), 
	issued_emp_id VARCHAR(20)
);

DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
	return_id varchar(30) PRIMARY KEY,
	issued_id VARCHAR(30),
	return_book_name VARCHAR(40),
	return_date	DATE ,
	return_book_isbn VARCHAR(50)
)

```

### 2. CRUD Operations

```sql
select * from books;
select * from branch;
select * from employees;
select * from members;
select * from issued_status;
select * from return_status
```

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn ,book_title, category ,rental_price	,status, author, publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 
'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT*FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address='125 Oak St'
WHERE member_id  ='C103';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id = 'IS121'

```
-- **Note**: if we try delete IS104 then we get an error this because of that id dependent on another column

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status WHERE issued_emp_id = 'E101'
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT * FROM issued_status -- for reference

SELECT issued_member_id ,
count(*) from issued_status
group by 1

having count(*) > 1
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
create table book_count as
select b.isbn,
 b.book_title,
count(ist.issued_id) as no_issue 
from books as b 
join issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1,2

select * from book_count
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql

select * from books 
where category = 'Classic'
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
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
```
-- **Note**: below one wrong method it calculates all books price includind not issued books also
select * from books

```sql
select category,
sum(rental_price) as rental_price , count(*) from books
group by 1;
```
**Note**:
--What this does:
--It sums all rental prices and counts all books from the books table, grouped by category.
--BUT ❌ this includes all books — even books that were never issued (never rented).

-- So:
-- Gives you total potential rental price by category.
-- Does not reflect the actual rental income (because some books may never have been issued).

9. **List Members Who Registered in the Last 180 Days**:
```sql
select * from members 
where reg_date >= current_date - interval '180 days';

insert into members(member_id ,member_name ,member_address, reg_date)
values ('C144','poti','banglore','2025-05-7'),
 ('C145','balz','hyderbad','2025-04-25')
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
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
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
```



## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## Author - Goondla Balaji

This project showcases SQL skills essential for database management and analysis. For more content on SQL and data analysis

Thank you for your interest in this project!

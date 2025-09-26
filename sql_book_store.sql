CREATE DATABASE OnlineBookstore;

-- Switch to the database in terminal m kam karega
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Book_Id INT REFERENCES Books(Book_Id),
	  Customer_ID INT REFERENCES Customers(Customer_Id),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- //import csv book table 

copy
Books(Book_ID, Title ,Author,Genre,Published_Year, Price,Stock)
from 'D:\my files\OneDrive\Desktop\All Excel Practice Files\Books.csv'
CSV HEADER;

-- //import csv custoimetrs table data

copy
Customers( Customer_ID,Name,Email,Phone ,City,Country)
from 'D:\my files\OneDrive\Desktop\All Excel Practice Files\Customers.csv'
CSV HEADER;

copy
Orders(Order_ID, Book_Id,Customer_ID,Order_Date,Quantity,Total_Amount)
from 'D:\my files\OneDrive\Desktop\All Excel Practice Files\Orders.csv'
CSV HEADER;

-- ?????????????????????start ???????????????????????????
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
select * from Books
where genre = 'Fiction';


-- 2) Find books published after the year 1950:
select * from Books
where published_year > 1950;

-- 3) List all customers from the Canada:
select * from Customers
where country = 'Canada';


-- 4) Show orders placed in November 2023:

select * from Orders 
where order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

select SUM(stock) from Books;

-- 6) Find the details of the most expensive book:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

select * from Books 
order by price DESC
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

select * from Orders
where quantity > 1;



-- 8) Retrieve all orders where the total amount exceeds $20:
select * from Orders
where total_amount > 20;



-- 9) List all genres available in the Books table:
select Distinct genre from Books;



-- 10) Find the book with the lowest stock:

select * from Books 
order by stock 
limit 1;

-- 11) Calculate the total revenue generated from all orders:


select sum(total_amount) from Orders;




-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT * FROM ORDERS;

select b.genre , sum(o.quantity) as sold_qunatity
from Books b join Orders o
on b.book_id = o.order_id
group by b.genre;



-- 2) Find the average price of books in the "Fantasy" genre:

select avg(price) from Books
where genre ='Fantasy';

-- 3) List customers who have placed at least 2 orders:

select *  from customers;
select * from orders;

select o.customer_id ,c.name , count(o.order_id) as order_count
from orders o join Customers c 
on o.customer_id = c.customer_id
group by o.customer_id , c.name
having count(order_id) >= 2;

-- 4) Find the most frequently ordered book:
select * from Books;

select o.book_id ,b.title , count(o.order_id) as order_count  
from Orders o join Books b 
on b.book_id = o.book_id
group by o.book_id , b.title
ORDER BY order_count DESC limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select genre , price 
from Books
where genre = 'Fantasy'
Order by price DESC 
limit 3;


-- 6) Retrieve the total quantity of books sold by each author:

select b.author , sum(o.quantity) as total_quantity
from Books b join Orders o
on b.book_id = o.book_id
group by b.author order by total_quantity DESC;




-- 7) List the cities where customers who spent over $30 are located:

select * from Customers;
select * from Orders;

select c.city , total_amount as spend
from Customers c join Orders o
on c.customer_id = o.customer_id
where total_amount > 400;



-- 8) Find the customer who spent the most on orders:
select c.customer_id , c.name, sum(o.total_amount) as total_spent
from orders o join Customers c
on o.customer_id = c.customer_id
group by c.customer_id , c.name
order by total_spent DESC
limit 1;



--9) Calculate the stock remaining after fulfilling all orders:

select b.title , b.book_id , b.stock , COALESCE(sum(o.quantity) , 0) as avalable ,
b.stock - COALESCE(sum(o.quantity) , 0) as remaining_qntyt
from Books b 
left join 
Orders o
on b.book_id = o.book_id
group by b.book_id order by b.book_id;



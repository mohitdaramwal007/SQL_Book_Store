-- Create Tables:

-- Books Table
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

-- Customers Table
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
	Customers_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(50),
	City VARCHAR(50),
	Country VARCHAR(150)
);

-- Orders Table
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);



SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books 
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950:

SELECT * FROM Books 
WHERE Published_year>1950;

-- 3) List all customers from the Canada:

SELECT * FROM Customers 
WHERE country='Canada';


-- 4) Show orders placed in November 2023:

SELECT * FROM Orders 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

SELECT SUM(stock) AS Total_Stock
From Books;


-- 6) Find the details of the most expensive book:

SELECT * FROM Books 
ORDER BY Price DESC 
LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT * FROM Orders 
WHERE quantity>1;



-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM Orders 
WHERE total_amount>20;



-- 9) List all genres available in the Books table:

SELECT DISTINCT genre FROM Books;


-- 10) Find the book with the lowest stock:

SELECT * FROM Books 
ORDER BY stock
LIMIT 1;


-- 11) Calculate the total revenue generated from all orders:

SELECT SUM(total_amount) As Revenue 
FROM Orders;

-- Advance Questions : 

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve the total number of books sold for each genre:

SELECT * FROM Orders;

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b 
ON o.book_id = b.book_id
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM Orders o
JOIN Customers c 
ON o.customer_id = c.customers_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >= 2
ORDER BY order_count;

-- 4) Find the most frequently ordered book:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Books b
ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
ORDER BY order_count DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT * FROM Books
ORDER BY price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM Books b
JOIN Orders o 
ON b.book_id = o.book_id
GROUP BY b.author;

-- 7) List the cities where customers who spent over $30 are located:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT DISTINCT c.city, o.total_amount
FROM Orders o
JOIN Customers c
ON c.customers_id =  o.customer_id
WHERE o.total_amount > 30;

-- 8) Find the customer who spent the most on orders:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT c.customers_id, c.name, SUM(o.total_amount) AS Total_Amount_Spent
FROM Customers c
JOIN Orders o
ON c.customers_id = o.customer_id
GROUP BY c.name, c.customers_id
ORDER BY Total_Amount_Spent DESC
LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT b.book_id, b.title, 
       b.stock, COALESCE(SUM(o.quantity),0) AS Order_Quantity, 
	   b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_quantity
FROM Books b
LEFT JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;

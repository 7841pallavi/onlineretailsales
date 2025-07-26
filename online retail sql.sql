-- CREATE DATABASE
-----------------------------------------------

CREATE DATABASE online_retail_db;

USE online_retail_db;

-----------------------------------------------
-- CREATE TABLES 
-----------------------------------------------

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT, -- PostgreSQL: use SERIAL instead of AUTO_INCREMENT
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10,2),
    stock_qty INT
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(50),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

----------------------------------------------------
-- INSERT DATA
----------------------------------------------------

-- Customers
INSERT INTO customers (name, email, phone, address) VALUES
('Pallavi Khandagale', 'pallavi@example.com', '9876543210', 'Pune'),
('Rahul Sharma', 'rahul@example.com', '9123456780', 'Mumbai');

-- Products
INSERT INTO products (name, description, price, stock_qty) VALUES
('Smartphone', 'Android mobile', 15000.00, 50),
('Headphones', 'Bluetooth headset', 2000.00, 100),
('Laptop', '8GB RAM Laptop', 50000.00, 25);

-- Orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-07-01', 17000.00),
(2, '2025-07-03', 52000.00);

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 15000.00),
(1, 2, 1, 2000.00),
(2, 3, 1, 50000.00),
(2, 2, 1, 2000.00);

-- Payments
INSERT INTO payments (order_id, payment_date, payment_method, amount) VALUES
(1, '2025-07-01', 'Credit Card', 17000.00),
(2, '2025-07-03', 'UPI', 52000.00);

----------------------------------------------
-- Verify Data with SELECT Queries
----------------------------------------------

SELECT * FROM customers;

SELECT * FROM order_items;


---------------------------------------------
-- JOIN Queries for Reports
---------------------------------------------

SELECT 
    p.name AS product,
    SUM(oi.quantity) AS total_units,
    SUM(oi.subtotal) AS total_sales
FROM 
    order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name;

--------------------------------------------
-- Orders with Customer and Payment Info:
--------------------------------------------

SELECT 
    o.order_id,
    c.name AS customer,
    o.order_date,
    o.total_amount,
    p.payment_method
FROM 
    orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN payments p ON o.order_id = p.order_id;


------------------------------------------------
-- View for Sales Summary
-----------------------------------------------

CREATE VIEW sales_summary AS
SELECT 
    o.order_id,
    c.name AS customer_name,
    o.order_date,
    SUM(oi.subtotal) AS total_order_value,
    p.payment_method
FROM 
    orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.order_id;


SELECT * FROM sales_summary;

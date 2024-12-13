CREATE DATABASE SalesTracker;
USE SalesTracker;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    Stock INT
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create OrderDetails table for product details in each order
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Subtotal DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
-- Insert sample customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
VALUES 
    ('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Main St'),
    ('Jane', 'Smith', 'jane.smith@example.com', '0987654321', '456 Oak Ave');

-- Insert sample products
INSERT INTO Products (ProductName, Price, Stock)
VALUES 
    ('Laptop', 799.99, 50),
    ('Smartphone', 599.99, 100),
    ('Tablet', 399.99, 80);

-- Insert sample orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES 
    (1, '2024-11-01', 1399.98),
    (2, '2024-11-02', 399.99);

-- Insert order details
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Subtotal)
VALUES 
    (1, 1, 1, 799.99),
    (1, 2, 1, 599.99),
    (2, 3, 1, 399.99);
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;
SELECT ProductID, ProductName, Stock
FROM Products
WHERE Stock < 50;
SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantitySold, SUM(od.Subtotal) AS TotalSales
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID;
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;
SELECT * FROM Orders
WHERE OrderDate BETWEEN '2024-11-01' AND '2024-11-30';
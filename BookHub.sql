CREATE DATABASE BookHub;
USE BookHub;

-- Create Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    YearPublished INT,
    Stock INT
);

-- Create Members table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    JoinDate DATE
);

-- Create Loans table
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    LoanDate DATE,
    ReturnDate DATE,
    DueDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Create Fines table
CREATE TABLE Fines (
    FineID INT PRIMARY KEY AUTO_INCREMENT,
    LoanID INT,
    FineAmount DECIMAL(10, 2),
    Paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);
-- Insert sample books
INSERT INTO Books (Title, Author, Genre, YearPublished, Stock)
VALUES 
    ('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 5),
    ('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 3),
    ('1984', 'George Orwell', 'Dystopian', 1949, 4);

-- Insert sample members
INSERT INTO Members (FirstName, LastName, Email, Phone, JoinDate)
VALUES 
    ('John', 'Doe', 'john.doe@example.com', '1234567890', '2024-01-01'),
    ('Jane', 'Smith', 'jane.smith@example.com', '0987654321', '2024-01-15');

-- Insert sample loans
INSERT INTO Loans (MemberID, BookID, LoanDate, ReturnDate, DueDate)
VALUES 
    (1, 1, '2024-10-01', '2024-10-15', '2024-10-14'),
    (2, 2, '2024-10-05', NULL, '2024-10-19');

-- Insert sample fines
INSERT INTO Fines (LoanID, FineAmount, Paid)
VALUES 
    (1, 5.00, FALSE);
    
SELECT Title, Author, Stock
FROM Books
WHERE Stock > 0;
SELECT l.LoanID, m.FirstName, m.LastName, b.Title, l.LoanDate, l.DueDate
FROM Loans l
JOIN Members m ON l.MemberID = m.MemberID
JOIN Books b ON l.BookID = b.BookID
WHERE l.ReturnDate IS NULL;
SELECT l.LoanID, m.FirstName, m.LastName, DATEDIFF(CURDATE(), l.DueDate) AS OverdueDays,
       DATEDIFF(CURDATE(), l.DueDate) * 1.00 AS FineAmount
FROM Loans l
JOIN Members m ON l.MemberID = m.MemberID
WHERE l.DueDate < CURDATE() AND l.ReturnDate IS NULL;
SELECT f.FineID, m.FirstName, m.LastName, f.FineAmount, f.Paid
FROM Fines f
JOIN Loans l ON f.LoanID = l.LoanID
JOIN Members m ON l.MemberID = m.MemberID;
UPDATE Loans
SET ReturnDate = CURDATE()
WHERE LoanID = 2;

UPDATE Books
SET Stock = Stock + 1
WHERE BookID = 2;
SELECT Title, Author, Genre, Stock
FROM Books
WHERE Genre = 'Fiction' AND Stock > 0;
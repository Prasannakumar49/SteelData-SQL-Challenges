CREATE SCHEMA bank_data;

USE bank_data;

-- Create the Customers table
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, City, State)
VALUES (1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');
--------------------
-- Create the Branches table
CREATE TABLE Branches (
BranchID INT PRIMARY KEY,
BranchName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Branches table
INSERT INTO Branches (BranchID, BranchName, City, State)
VALUES (1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');
--------------------
-- Create the Accounts table
CREATE TABLE Accounts (
AccountID INT PRIMARY KEY,
CustomerID INT NOT NULL,
BranchID INT NOT NULL,
AccountType VARCHAR(50) NOT NULL,
Balance DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
--------------------
-- Populate the Accounts table
INSERT INTO Accounts (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES (1, 1, 5, 'Checking', 1000.00),
(2, 1, 5, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 1, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 2, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 8, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 14, 'Savings', 50000.00),
(11, 6, 2, 'Checking', 5000.00),
(12, 6, 2, 'Savings', 10000.00),
(13, 1, 5, 'Credit Card', -500.00),
(14, 2, 1, 'Credit Card', -1000.00),
(15, 3, 2, 'Credit Card', -2000.00);
--------------------
-- Create the Transactions table
CREATE TABLE Transactions (
TransactionID INT PRIMARY KEY,
AccountID INT NOT NULL,
TransactionDate DATE NOT NULL,
Amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
--------------------
-- Populate the Transactions table
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount)
VALUES (1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);


SELECT * FROM customers;
SELECT * FROM branches;
SELECT * FROM accounts;
SELECT * FROM transactions;



#1. What are the names of all the customers who live in New York?
SELECT CONCAT(firstName," ",LastName)AS FullName, City
FROM customers
WHERE City = 'New York';



#2. What is the total number of accounts in the Accounts table?
SELECT COUNT(AccountID) AS No_of_accounts
FROM accounts;




#3. What is the total balance of all checking accounts?
SELECT AccountID, SUM(Balance) AS Total_balance
FROM accounts
WHERE Accounttype = 'checking'
GROUP BY AccountID
ORDER BY Total_balance DESC;


#4. What is the total balance of all accounts associated with customers who live in Los Angeles?
SELECT customers.CustomerID, accounts.AccountID, SUM(accounts.balance) AS Total_balance
FROM accounts
INNER JOIN customers ON accounts.customerID =customers.customerID
WHERE customers.city = 'Los Angeles'
GROUP BY customers.customerID;



#5. Which branch has the highest average account balance?
SELECT branches.branchname, ROUND(AVG(accounts.balance),0) AS Avg_balance
FROM branches
INNER JOIN accounts ON branches.branchID = accounts.branchID
GROUP BY branches.branchName
ORDER BY Avg_balance DESC;




#6. Which customer has the highest current balance in their accounts?
SELECT customers.CustomerID, CONCAT(customers.FirstName ," ", customers.LastName) AS FullName, 
accounts.AccountID, Max(accounts.balance) AS Highest_Balance
FROM customers INNER JOIN accounts ON customers.CustomerID = accounts.customerID;




#7. Which customer has made the most transactions in the Transactions table?
SELECT customers.customerID, accounts.AccountID, MAX(transactions.transactionID) AS No_of_transaction
FROM customers INNER JOIN accounts ON customers.customerID = accounts.customerID
INNER JOIN transactions ON accounts.AccountID = transactions.AccountID
GROUP BY customers.customerID
ORDER BY No_of_transaction DESC;



#8.Which branch has the highest total balance across all of its accounts?
SELECT branches.BranchName, SUM(accounts.balance) AS Total_balance
FROM branches INNER JOIN accounts ON branches.BranchID = accounts.BranchID
GROUP BY branches.BranchName
ORDER BY Total_balance DESC
LIMIT 1;



#9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?
SELECT customers.customerID, CONCAT(customers.FirstName," ",customers.FirstName)AS FullName, SUM(accounts.balance) AS Total_balance
FROM customers INNER JOIN accounts ON customers.customerID = accounts.customerID
GROUP BY customers.customerID
ORDER BY Total_balance DESC
LIMIT 1;



#10. Which branch has the highest number of transactions in the Transactions table?
SELECT branches.branchID, branches.branchName, SUM(transactions.transactionID) AS No_of_transactions
FROM branches INNER JOIN accounts ON branches.branchID = accounts.branchID
INNER JOIN transactions ON accounts.accountID = transactions.AccountID
GROUP BY branches.branchID
ORDER BY No_of_transactions DESC;

use nm;

show tables;


-- Case Study

/*Problem Statement:
You are a database developer of an international bank. You are responsible 
for managing the bank database. You want to use the data to answer a few 
questions about your customers regarding withdrawal, deposit etc 
especially about the transaction amount on a particular date across various
regions of the world. Perform SQL queries to get the key insights of a 
customer.
Dataset :
The 3 key datasets for this case study are -
● Continent
The Continent Table has two attributes i.e. region_id and region_name 
where region_name consists of different continents such as Asia, Europe, 
Africa etc assigned with the unique region id.

● Customers
The Customers Table has four attributes named customer_id, region_id, 
start_date and end_date which consists of 3500 records.
● Transaction
Finally, the Transaction Table contains around 5850 records and has four 
attributes named customer_id, txn_date, txn_type and txn_amount.*/

create table continent (
		region_id int,	
		region_name Varchar(50)
);

create table Customers
(
		customer_id int,	
        region_id int,	
        start_date Date,
        end_date Date
);

create table Transaction 
(
		customer_id int,	
        txn_date Date,	
        txn_type Varchar(50),	
        txn_amount int

);


select * from continent;
select * from Customers;
select * from Transaction;



-- 1) Display the count of customer in each region who has done the transaction in year 2020.


SELECT 
    co.region_name,
    COUNT(DISTINCT c.customer_id) AS Count_of_customer
FROM
    continent co
        JOIN
    Customers c ON co.region_id = c.region_id
        JOIN
    Transaction t ON c.customer_id = t.customer_id
WHERE
    YEAR(t.txn_date) = '2020'
GROUP BY co.region_name
ORDER BY Count_of_customer DESC;



-- 2) Display the maximum, minimum of transaction amount of each transaction type.
 
 
 select 
		txn_type,
        max(txn_amount) AS Maximum_Amount,
        min(txn_amount) AS Mimimum_Amount
from Transaction 
group by txn_type;


-- 3) Display customer id, region name and transaction amount where transaction type is deposit and transaction amount > 2000.


SELECT
    c.customer_id,
    co.region_name,
    t.txn_amount
FROM
    Transaction t
JOIN
    Customers c ON c.customer_id = t.customer_id
JOIN
    Continent co ON co.region_id = c.region_id
WHERE
    t.txn_type = 'deposit' AND t.txn_amount > 2000;
    
    
-- 4) Find duplicate records in a customer table.


SELECT
    customer_id,
    region_id,
    start_date,
    end_date,
    COUNT(*) AS duplicate_count
FROM
    Customers
GROUP BY
    customer_id,
    region_id,
    start_date,
    end_date
HAVING
    COUNT(*) > 1;
    
    
    
-- 5) Display the detail of customer id, region name, transaction type and transaction amount for the minimum transaction amount in deposit.

SELECT
    c.customer_id,
    co.region_name,
    t.txn_type,
    t.txn_amount
FROM
    Transaction t
JOIN
    Customers c ON c.customer_id = t.customer_id
JOIN
    Continent co ON co.region_id = c.region_id
WHERE
    t.txn_type = 'deposit'
    AND t.txn_amount = (
        SELECT
            MIN(txn_amount) AS Minimum_Transaction
        FROM
            Transaction
        WHERE
            txn_type = 'deposit'
    );


-- 6) Create a stored procedure to display details of customer and transaction table where transaction date is greater than Jun 2020.


CALL GetCustomerTransactionDetails();


-- 7) Create a stored procedure to insert a record in the continent table.


CALL InsertContinent(1, 'Asia');

-- 8) Create a pivot table to display the total purchase, withdrawal and deposit for all the customers.
SELECT
    customer_id,
    COALESCE(SUM(CASE WHEN txn_type = 'Purchase' THEN txn_amount END), 0) AS Total_Purchase,
    COALESCE(SUM(CASE WHEN txn_type = 'Withdrawal' THEN txn_amount END), 0) AS Total_Withdrawal,
    COALESCE(SUM(CASE WHEN txn_type = 'Deposit' THEN txn_amount END), 0) AS Total_Deposit
FROM
    Transaction
GROUP BY
    customer_id;

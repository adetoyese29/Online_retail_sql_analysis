# Online_retail_sql_analysis

### Project Overview
This project involves using POSTGRESQL to create a database, clean and analyze an online retail store dataset
The dataset is the Online Retil Dataset from Kaggle

## Processes

### Database And Table Creation
- Created a new Database named "Online_retail_sql"
- Created a table called "raw_sales"
- imported the csv file into the table

  CREATE TABLE raw_sales (
    InvoiceNo TEXT,
    StockCode TEXT,
    Description TEXT,
    Quantity INTEGER,
    InvoiceDate TEXT,
    UnitPrice NUMERIC,
    CustomerID TEXT,
    Country TEXT
);

SELECT *
FROM raw_sales
LIMIT 100;

### Cleaning the dataset
- The table contained cancelled orders where the invoiceno starts with 'C'
- Created a new table called "cancelled_orders" and transfered the cancelled orders into it
- Deleted the cancelled orders from the raw_sales table
- Changed date column to timestamp

  -- Create cancelled orders table
CREATE TABLE cancelled_orders AS
SELECT * FROM raw_sales WHERE 1=0;

-- Import cancelled orders into the cancelled+orders table
INSERT INTO cancelled_orders
SELECT * FROM raw_sales
WHERE "invoiceno" LIKE 'C%';

- -- Delete cancelled orders from raw_sales table 
DELETE FROM raw_sales
WHERE "invoiceno" LIKE 'C%';

-- Alter data types
ALTER TABLE raw_sales
ADD COLUMN invoice_timestamp TIMESTAMP;

UPDATE raw_sales
SET invoice_timestamp = TO_TIMESTAMP("invoicedate", 'MM/DD/YYYY HH24:MI')


SELECT * FROM raw_sales
SELECT * FROM cancelled_orders


### Analysis
- The following analysis were carried out

SELECT * FROM raw_sales
LIMIT 100

SELECT * FROM cancelled_orders

-- Sales performance analysis
-- What is the total revenue?
SELECT CAST(SUM(quantity * unitprice)/1000000 AS DECIMAL (10,2)) AS total_revenue
FROM raw_sales;

-- TOTAL NO OF CUSTOMERS
SELECT COUNT(DISTINCT(customerid)) AS total_customers
FROM raw_sales

-- TOTAL NO OF COMPLETED TRANSACTIONS
SELECT COUNT(DISTINCT(invoiceno)) AS transactions
FROM raw_sales;

-- TOTAL NO. OF STOCK
SELECT
	COUNT(DISTINCT(stockcode)) AS Total_stocks
FROM raw_sales;

-- Average Order Value (AOV)
SELECT
	SUM(quantity * unitprice)/COUNT(DISTINCT(invoiceno)) AS AVGORDERVALUE
FROM raw_sales

-- Average Spend per Customer
SELECT
	SUM(quantity * unitprice)/COUNT(DISTINCT(customerid)) AS AVGORDERVALUE
FROM raw_sales;

-- Cancellation Rate
SELECT 
    ROUND(
        ( (SELECT COUNT(DISTINCT invoiceno) FROM cancelled_orders)::decimal
          /
          (SELECT COUNT(DISTINCT invoiceno) 
           FROM (
               SELECT invoiceno FROM raw_sales
               UNION
               SELECT invoiceno FROM cancelled_orders
           ) AS combined
          )
        ) * 100, 
        2
    ) || '%' AS cancellation_rate;


-- What is the monthly sales trend?
SELECT
	DATE_TRUNC('month', invoice_timestamp):: DATE AS sales_month,
	SUM(quantity * unitprice) AS total_revenue
FROM raw_sales
GROUP BY sales_month
ORDER BY sales_month;

-- Which countries generate the most sale?
SELECT
	country,
	SUM(quantity * unitprice) AS total_revenue
FROM raw_sales
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- Product Analysis
-- What are the top 10 best-selling products by number of sales?
SELECT
	description,
	SUM(quantity) AS total_no_of_product_sold
FROM raw_sales
GROUP BY description
ORDER BY total_no_of_product_sold DESC
LIMIT 10;

-- What are the top 10 worst-selling products by number of sales?
SELECT
	description,
	SUM(quantity) AS total_no_of_product_sold
FROM raw_sales
GROUP BY description
ORDER BY total_no_of_product_sold ASC
LIMIT 10;

-- What are the top 10 best-selling products by revenue?
SELECT
	description,
	SUM(quantity * unitprice) AS total_revenue
FROM raw_sales
GROUP BY description
ORDER BY total_revenue DESC
LIMIT 10;

-- Customer Analysis
-- Who are the top 10 spending customers?
SELECT
	customerid,
	SUM(quantity * unitprice) AS total_revenue
FROM raw_sales
WHERE customerid IS NOT NULL
GROUP BY customerid
ORDER BY total_revenue DESC
LIMIT 10;





### Tool Used
PostgreSQL 

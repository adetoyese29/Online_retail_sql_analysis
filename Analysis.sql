-- Customer Segmentation → Based on Recency, Frequency, and Monetary Value (RFM Analysis)




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




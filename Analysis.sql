SELECT * FROM product_sales
LIMIT 100

SELECT * FROM non_product_sales

SELECT * FROM cancelled_orders

-- Sales performance analysis
-- What is the total revenue?
SELECT CAST(SUM(quantity * unitprice)/1000000 AS DECIMAL (10,2)) AS total_revenue
FROM product_sales;

-- TOTAL NO OF CUSTOMERS
SELECT COUNT(DISTINCT(customerid)) AS total_customers
FROM product_sales

-- TOTAL NO OF COMPLETED TRANSACTIONS
SELECT COUNT(DISTINCT(invoiceno)) AS transactions
FROM product_sales;

-- TOTAL NO. OF STOCK
SELECT
	COUNT(DISTINCT(stockcode)) AS Total_stocks
FROM product_sales;

-- Average Order Value (AOV)
SELECT
	SUM(quantity * unitprice)/COUNT(DISTINCT(invoiceno)) AS AVGORDERVALUE
FROM product_sales

-- Average Spend per Customer
SELECT
	SUM(quantity * unitprice)/COUNT(DISTINCT(customerid)) AS AVGORDERVALUE
FROM product_sales;

-- Cancellation Rate
WITH combined AS (
    SELECT invoiceno, 'sale' AS type FROM product_sales
    UNION ALL
    SELECT invoiceno, 'cancel' AS type FROM cancelled_orders
)
SELECT 
    ROUND(
        (COUNT(DISTINCT CASE WHEN type = 'cancel' THEN invoiceno END)::DECIMAL
        / COUNT(DISTINCT invoiceno)) * 100, 2
    ) AS cancellation_rate_percentage
FROM combined;


-- Cancellation Rate by products 
WITH combined AS(
	SELECT 
    invoiceno,
    description,
    'sale' AS type
FROM product_sales

UNION ALL

SELECT 
    invoiceno,
    description,
    'cancel' AS type
FROM cancelled_orders	
)
SELECT
	description,
	COUNT(description) AS desc_count,
    ROUND(
        (COUNT(DISTINCT CASE WHEN type = 'cancel' THEN invoiceno END)::DECIMAL
        / COUNT(DISTINCT invoiceno)) * 100, 2
    ) AS cancellation_rate_percentage
FROM combined
GROUP BY description
HAVING COUNT(description) > 10
ORDER BY cancellation_rate_percentage DESC;


-- Cancellation Rate by country
WITH combined AS(
	SELECT 
    invoiceno,
    country,
    'sale' AS type
FROM product_sales

UNION ALL

SELECT 
    invoiceno,
    country,
    'cancel' AS type
FROM cancelled_orders	
)
SELECT
	country,
	COUNT(country) AS desc_count,
    ROUND(
        (COUNT(DISTINCT CASE WHEN type = 'cancel' THEN invoiceno END)::DECIMAL
        / COUNT(DISTINCT invoiceno)) * 100, 2
    ) AS cancellation_rate_percentage
FROM combined
GROUP BY country
ORDER BY cancellation_rate_percentage DESC;


-- What is the monthly sales trend?
SELECT
	DATE_TRUNC('month', invoice_timestamp):: DATE AS sales_month,
	SUM(quantity * unitprice) AS total_revenue
FROM product_sales
GROUP BY sales_month
ORDER BY sales_month;

-- Which countries generate the most sale?
SELECT
	country,
	SUM(quantity * unitprice) AS total_revenue
FROM product_sales
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- Product Analysis
-- What are the top 10 best-selling products by number of sales?
SELECT
	description,
	SUM(quantity) AS total_no_of_product_sold
FROM product_sales
GROUP BY description
ORDER BY total_no_of_product_sold DESC
LIMIT 10;

-- What are the top 10 worst-selling products by number of sales?
SELECT
	description,
	SUM(quantity) AS total_no_of_product_sold
FROM product_sales
GROUP BY description
ORDER BY total_no_of_product_sold ASC
LIMIT 10;

-- What are the top 10 best-selling products by revenue?
SELECT
	description,
	SUM(quantity * unitprice) AS total_revenue
FROM product_sales
GROUP BY description
ORDER BY total_revenue DESC
LIMIT 10;

-- Customer Analysis
-- Who are the top 10 spending customers?
SELECT
	customerid,
	SUM(quantity * unitprice) AS total_revenue
FROM product_sales
WHERE customerid IS NOT NULL
GROUP BY customerid
ORDER BY total_revenue DESC
LIMIT 10;


-- non products analysis
-- Total cost/revenue per description
SELECT 
	description,
	SUM(quantity * unitprice) AS total_value
FROM non_product_sales
GROUP BY description
ORDER BY total_value DESC;

-- Net impact by customer/country
SELECT
	customerid,
	country,
	SUM(quantity * unitprice) AS total_value
FROM non_product_sales
GROUP BY customerid, country
ORDER BY total_value DESC;


--Monthly trend of adjustments
SELECT DATE_TRUNC('month', invoice_timestamp::date) AS month,
       description,
       SUM(quantity * unitprice) AS monthly_value
FROM non_product_sales
GROUP BY month, description
ORDER BY month

-- Voucher issuance by type
SELECT 
	description,
	COUNT(*) AS issued,
    SUM(quantity * unitprice) AS total_value
FROM non_product_sales
WHERE description ILIKE '%voucher%'
GROUP BY description;


-- Postage & carriage impact
SELECT
	description, 
	SUM(quantity * unitprice) AS total_postage
FROM non_product_sales
WHERE description LIKE 'POSTAGE' OR description LIKE '%CARRIAGE%'
GROUP BY description;

-- Bank charges trend
SELECT DATE_TRUNC('month', invoice_timestamp::date) AS month,
       SUM(quantity * unitprice) AS bank_charges
FROM non_product_sales
WHERE description ILIKE '%bank%'
GROUP BY month;

-- Adjustments by type
SELECT
	description,
	SUM(quantity * unitprice) AS adjustment_value
FROM non_product_sales
WHERE description ILIKE '%manual%' OR description ILIKE '%adjust%'
GROUP BY description;


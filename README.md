# Online_retail_sql_analysis

### Project Overview
This project involves using POSTGRESQL to create a database, clean and analyze an online retail store dataset 
The dataset is the Online Retail Dataset from Kaggle

## Processes

### Database And Table Creation
- Created a new Database named "Online_retail_sql"
- Created a table called "raw_sales"
- imported the csv file into the table

### Cleaning the dataset
- The "raw_sales" table is a combination of product items like "WHITE METAL LANTERN" and non product items like "POSTAGE"
- Created 2 new tables called "product_sales" which contains the product items and "non_product_sales" which contains the non product items
- The tables contained cancelled orders where the invoiceno starts with 'C'
- Created a new table called "cancelled_orders" from the "product_sales" table and transfered the cancelled orders into it
- Deleted the cancelled orders from the "product_sales" table
- Changed date column to timestamp

### Analysis
The following analysis were carried out on the dataset

#### Sales performance analysis
- What is the total revenue?
- TOTAL NO OF CUSTOMERS
- TOTAL NO OF COMPLETED TRANSACTIONS
- TOTAL NO. OF STOCK
- Average Order Value (AOV)
- Average Spend per Customer
- Cancellation Rate
- Cancellation Rate by products
- Cancellation Rate by country
- What is the monthly sales trend?
- Which countries generate the most sale?

#### Product Analysis
- What are the top 10 best-selling products by number of sales?
- What are the top 10 worst-selling products by number of sales?
- What are the top 10 best-selling products by revenue?

#### Customer Analysis
- Who are the top 10 spending customers?

#### non products analysis
- Total cost/revenue per description
- Net impact by customer/country
- Monthly trend of adjustments
- Voucher issuance by type
- Postage & carriage impact
- Bank charges trend
- Adjustments by type

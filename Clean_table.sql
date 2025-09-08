-- Create product_sales table
DROP TABLE IF EXISTS product_sales;
CREATE TABLE product_sales AS
SELECT *
FROM raw_sales
WHERE description NOT IN (
    'Adjust bad debt',
    'AMAZON FEE',
    'Bank Charges',
    'CARRIAGE',
    'CRUK Commission',
    'Discount',
    'Manual',
    'POSTAGE',
    'SAMPLES',
    'DOTCOMPOSTAGE',
    'Dotcomgiftshop Gift Voucher £10.00',
    'Dotcomgiftshop Gift Voucher £20.00',
    'Dotcomgiftshop Gift Voucher £30.00',
    'Dotcomgiftshop Gift Voucher £40.00',
    'Dotcomgiftshop Gift Voucher £50.00',
    'to push order througha s stock was',
    'samples/damages',
    'Sale error'
);


SELECT * FROM product_sales
LIMIT 100;

-- Create non_product_sales table
DROP TABLE IF EXISTS non_product_sales;
CREATE TABLE non_product_sales AS
SELECT *
FROM raw_sales
WHERE description IN (
    'Adjust bad debt',
    'AMAZON FEE',
    'Bank Charges',
    'CARRIAGE',
    'CRUK Commission',
    'Discount',
    'Manual',
    'POSTAGE',
    'SAMPLES',
    'DOTCOMPOSTAGE',
    'Dotcomgiftshop Gift Voucher £10.00',
    'Dotcomgiftshop Gift Voucher £20.00',
    'Dotcomgiftshop Gift Voucher £30.00',
    'Dotcomgiftshop Gift Voucher £40.00',
    'Dotcomgiftshop Gift Voucher £50.00',
    'to push order througha s stock was',
    'samples/damages',
    'Sale error'
);

SELECT * FROM non_product_sales
LIMIT 100;

-- Create cancelled orders table
DROP TABLE IF EXISTS cancelled_orders;
CREATE TABLE cancelled_orders AS
SELECT * FROM product_sales
WHERE invoiceno LIKE '%C%'

SELECT * FROM cancelled_orders
LIMIT 100;

-- Delete cancelled orders from product_sales table 
DELETE FROM product_sales
WHERE "invoiceno" LIKE 'C%';


-- Alter data types
-- For raw_sales
ALTER TABLE raw_sales
ADD COLUMN invoice_timestamp TIMESTAMP;

UPDATE raw_sales
SET invoice_timestamp = TO_TIMESTAMP("invoicedate", 'MM/DD/YYYY HH24:MI')


-- for product_sales
ALTER TABLE product_sales
ADD COLUMN invoice_timestamp TIMESTAMP;

UPDATE product_sales
SET invoice_timestamp = TO_TIMESTAMP("invoicedate", 'MM/DD/YYYY HH24:MI')


-- For cancelled_orders
ALTER TABLE non_product_sales
ADD COLUMN invoice_timestamp TIMESTAMP;

UPDATE non_product_sales
SET invoice_timestamp = TO_TIMESTAMP("invoicedate", 'MM/DD/YYYY HH24:MI')


-- For cancelled_orders
ALTER TABLE cancelled_orders
ADD COLUMN invoice_timestamp TIMESTAMP;

UPDATE cancelled_orders
SET invoice_timestamp = TO_TIMESTAMP("invoicedate", 'MM/DD/YYYY HH24:MI')






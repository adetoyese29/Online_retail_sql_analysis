-- Create cancelled orders table
CREATE TABLE cancelled_orders AS
SELECT * FROM raw_sales WHERE 1=0;

-- Import cancelled orders into the cancelled+orders table
INSERT INTO cancelled_orders
SELECT * FROM raw_sales
WHERE "invoiceno" LIKE 'C%';

-- Delete cancelled orders from raw_sales table 
DELETE FROM raw_sales
WHERE "invoiceno" LIKE 'C%';

-- Alter data types
ALTER TABLE raw_sales
ADD COLUMN invoice_timestamp TIMESTAMP;

UPDATE raw_sales
SET invoice_timestamp = TO_TIMESTAMP("invoicedate", 'MM/DD/YYYY HH24:MI')


SELECT * FROM raw_sales
SELECT * FROM cancelled_orders

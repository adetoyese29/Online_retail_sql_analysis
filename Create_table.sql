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

-- Measure Exploration
SELECT 'Total Sales' AS Measure_name, SUM(sales_amount) AS Meaure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price',  AVG(sls_price)  FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders',  COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT product_number) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers', COUNT(customer_key) AS Total_customer FROM gold.dim_customers

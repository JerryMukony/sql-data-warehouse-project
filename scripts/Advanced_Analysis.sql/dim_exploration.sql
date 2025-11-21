-- Explore All Countries our customers come from
SELECT DISTINCT country FROM GOLD.dim_customers

-- Explore All Categories "The Major Divisions".
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products

-- Explore All Dates
-- Find the date of the first and last order
-- How many years of sales are available
SELECT 
MIN(order_date) first_order_date,
MAX(order_date) last_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales

-- Find the youngest and oldest customer
SELECT 
MIN(birthdate) AS oldest_customer,
DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_customer,
DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age,
DATEDIFF(year, MIN(birthdate), MAX(birthdate)) AS age_gap
FROM gold.dim_customers

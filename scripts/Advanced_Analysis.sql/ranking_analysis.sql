
-- Ranking Analysis
-- Which 5 products generate the highest revenue?
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS Highest_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.prd_key = p.prd_key
GROUP BY 
p.product_name
ORDER BY Highest_revenue DESC

-- What are the 5 worst- performing products in terms of sales
SELECT TOP 5
p.product_name AS Worst_Performing_products,
SUM(f.sales_amount) AS Lowest_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.prd_key = p.prd_key
GROUP BY 
p.product_name
ORDER BY Lowest_revenue

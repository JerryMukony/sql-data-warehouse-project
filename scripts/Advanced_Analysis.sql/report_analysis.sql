/*
==============================================================================================
Product Report
==============================================================================================
Purpose:
	-This report consolidates key product metrics and behaviors.
Highlights:
	1. Gather essential fields such as product name, category, subcategory, and cost.
	2. Segment products by revenue to identify High-Performers, Mid-Range, or Low-Performers
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
==================================================================================================
*/

CREATE VIEW gold.report_products AS 
WITH base_query AS (
SELECT
f.order_number,
f.order_date,
f.customer_key,
f.sales_amount,
f.quantity,
p.prd_key,
p.product_name,
p.category,
p.subcategory,
p.product_cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.prd_key = p.prd_key
WHERE order_date IS NOT NULL -- only consider valid sales dates
)

, product_aggregation AS (
 /*........................................................................................
 2) Customer Aggregations: Summarizes key metrics at the customer level
 .........................................................................................*/
SELECT 
prd_key,
product_name,
category,
subcategory,
product_cost,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan,
MAX(order_date) as last_sale_date,
COUNT(DISTINCT order_number) as total_orders,
COUNT(DISTINCT customer_key) as total_customers,
SUM(sales_amount) as total_sales,
SUM(quantity) as total_quantity,
ROUND(AVG(CAST(sales_amount AS float) /NULLIF(quantity, 0)), 1) as avg_selling_price
FROM base_query
GROUP BY
	prd_key,
	product_name,
	category,
	subcategory,
	product_cost
)

/* ............................................................................
	3) Final Query: Combine all product results into one output
..............................................................................*/
SELECT
	prd_key,
	product_name,
	category,
	subcategory,
	product_cost,
	last_sale_date,
	DATEDIFF(month, last_sale_date, GETDATE()) as recency_in_months,
CASE	WHEN total_sales > 50000  THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
END customer_segment,
lifespan,
total_orders,
total_sales,
total_quantity,
total_customers,
avg_selling_price,

-- Compute average order value (AVO)
CASE WHEN total_sales = 0 THEN 0
	ELSE total_sales/total_orders
END AS avg_order_value,
-- Compute average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
	ELSE total_sales/lifespan
END AS avg_monthly_spend
FROM product_aggregation

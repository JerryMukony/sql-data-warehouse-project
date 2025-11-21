-- Data Segmentation
/*Segment products into cost ranges and count how many products fall into each segment*/

WITH product_segment AS (
SELECT 
prd_key,
product_name, 
product_cost,
CASE	WHEN product_cost < 100 THEN 'Below 100'
		WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN product_cost BETWEEN 500 AND 1000 THEN '500-100'
	ELSE 'Above 1000'
END cost_range
FROM gold.dim_products )

SELECT
cost_range,
COUNT(prd_key) as total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC

/*Group customers into 3 segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than $5,000.
	- Regular: Customers with at least 12 months of history but spending $5,000 or less.
	- New: Customers with a lifespan less than 12 months
And find the total number of customers by each group
*/

WITH customer_spending AS (
SELECT 
c.customer_key,
SUM(f.sales_amount) as total_spending,
MIN(f.order_date) as first_order,
MAX(f.order_date) as last_order,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
customer_segment,
COUNT(customer_key) as total_customers
FROM (
	SELECT
	customer_key,
	CASE	WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segment
	FROM customer_spending)t
GROUP BY customer_segment
ORDER BY total_customers DESC

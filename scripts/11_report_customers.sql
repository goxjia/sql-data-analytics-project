/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
CREATE VIEW report_customers AS 
WITH customer_information AS (
SELECT
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	TIMESTAMPDIFF(YEAR, c.birthdate, CURDATE()) AS age,
	COUNT(DISTINCT fs.order_number) AS total_orders,
	SUM(fs.sales_amount) AS total_sales,
	SUM(fs.quantity) AS total_quantity_purchased,
	MIN(fs.order_date) AS first_order,
	MAX(fs.order_date) AS last_order,
	COUNT(DISTINCT fs.product_key) AS total_products,
	TIMESTAMPDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date)) AS lifespan
FROM
	fact_sales fs
LEFT JOIN
        customers c ON
	fs.customer_key = c.customer_key
WHERE
	fs.order_date IS NOT NULL
	AND fs.order_date <> ''
GROUP BY
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name),
	TIMESTAMPDIFF(YEAR, c.birthdate, CURDATE())
)
SELECT
	ci.customer_key,
	ci.customer_number,
	ci.customer_name,
	ci.age,
	CASE
		WHEN ci.age < 20 THEN 'Below 20'
		WHEN ci.age BETWEEN 20 AND 29 THEN '20-29'
		WHEN ci.age BETWEEN 30 AND 39 THEN '30-39'
		WHEN ci.age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_group,
	ci.total_orders,
	ci.total_sales,
	ci.total_quantity_purchased,
	ci.total_products,
	ci.lifespan,
	CASE
		WHEN ci.lifespan >= 12
		AND ci.total_sales > 5000 THEN 'VIP'
		WHEN ci.lifespan >= 12
		AND ci.total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS segment,
	TIMESTAMPDIFF(MONTH, ci.last_order, CURDATE()) AS recency,
	CASE
		WHEN ci.total_orders = 0 THEN ci.total_sales
		-- Handle cases where total_orders might be 0 to avoid division by zero
		ELSE ROUND(ci.total_sales / ci.total_orders, 2)
	END AS average_order_value,
	CASE
		WHEN ci.lifespan = 0 THEN ci.total_sales
		-- Handle cases where lifespan might be 0 (e.g., only one order)
		ELSE ROUND(ci.total_sales / ci.lifespan, 2)
	END AS average_monthly_spend
FROM
	customer_information ci;
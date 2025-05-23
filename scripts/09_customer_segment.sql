/*Segment products into cost ranges and 
count how many products fall into each segment*/
WITH product_segment AS(
SELECT
	product_key,
	product_name,
	CASE
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END AS cost_range
FROM
	products)

SELECT
	cost_range,
	COUNT(product_key) AS total_products
FROM
	product_segment
GROUP BY
	cost_range
ORDER BY
	COUNT(product_key) DESC;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH customer_information AS(
SELECT
	fs.customer_key,
	-- 名字组合在一起
	CONCAT(first_name, " ", last_name) AS name,
	SUM(sales_amount) AS total_spending,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	-- Calculate the difference and alias it
	TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date) ) AS lifespan
FROM
	fact_sales fs
LEFT JOIN customers c
ON
	fs.customer_key = c.customer_key
WHERE
	order_date IS NOT NULL
	AND order_date <> ''
GROUP BY
	fs.customer_key,
	CONCAT(first_name, " ", last_name))
	
,
customer_group AS(
	SELECT
	customer_key,
	name,
	total_spending,
	lifespan,
	CASE
		WHEN
	lifespan >= 12
		AND total_spending >5000 THEN 'VIP'
		WHEN lifespan >= 12
		AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
FROM
	customer_information)

	SELECT
	customer_segment,
	count(customer_key) AS cnt_customers
FROM
	customer_group
GROUP BY
	customer_segment;
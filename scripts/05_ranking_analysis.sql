/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT
	product_name,
	sum(sales_amount) AS revenue
FROM
	fact_sales fs
LEFT JOIN products p
		USING(product_key)
GROUP BY
	product_name
ORDER BY
	revenue DESC
LIMIT 5;

-- Complex but Flexibly Ranking Using Window Functions
SELECT
	*
FROM
	(
	SELECT
		product_name,
		sum(sales_amount) AS revenue,
		RANK() OVER(ORDER BY sum(sales_amount) DESC) AS ranking
	FROM
		fact_sales fs
	LEFT JOIN products p
			USING(product_key)
	GROUP BY
		product_name
	ORDER BY
		revenue DESC)t
WHERE
	ranking <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT
	product_name,
	sum(sales_amount) AS revenue
FROM
	fact_sales fs
LEFT JOIN products p
		USING(product_key)
GROUP BY
	product_name
ORDER BY
	revenue ASC
LIMIT 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT
	concat(first_name, ' ', last_name) AS customer_name,
	sum(sales_amount) AS revenue
FROM
	fact_sales fs
LEFT JOIN customers c
		USING(customer_key)
GROUP BY
	concat(first_name, ' ', last_name)
ORDER BY
	revenue DESC
LIMIT 10;

-- The 3 customers with the fewest orders placed
SELECT
	concat(first_name, ' ', last_name) AS customer_name,
	count(DISTINCT order_number) AS total_orders
FROM
	fact_sales fs
LEFT JOIN customers c
		USING(customer_key)
GROUP BY
	concat(first_name, ' ', last_name)
ORDER BY
	total_orders ASC
LIMIT 3;

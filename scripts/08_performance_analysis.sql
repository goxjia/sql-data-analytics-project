WITH yearly_product_sales AS(
SELECT
	YEAR(order_date) AS order_year,
	product_name ,
	SUM(sales_amount) AS current_sales
FROM
	fact_sales fs
LEFT JOIN products p
		USING(product_key)
WHERE
	order_date IS NOT NULL AND order_date <> ''
GROUP BY
	YEAR(order_date),
	product_name
ORDER BY
	YEAR(order_date) ASC,
	product_name ASC)
	
	,
product_sales AS (
SELECT
	*,
	avg(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
	LAG(current_sales, 1) OVER (PARTITION BY product_name
ORDER BY
	order_year ASC ) AS previous_sales
FROM
	yearly_product_sales)

SELECT
	order_year,
	product_name,
	current_sales,
	avg_sales,
	current_sales - avg_sales AS diff_avg,
	CASE
		WHEN current_sales - avg_sales>0 THEN 'Above Avg'
		WHEN current_sales - avg_sales<0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS avg_change,
	previous_sales,
	current_sales - previous_sales AS diff_py,
	CASE
		WHEN current_sales - previous_sales>0 THEN 'Increase'
		WHEN current_sales - previous_sales<0 THEN 'Decrease'
		ELSE 'No change'
	END AS py_change
FROM
	product_sales;
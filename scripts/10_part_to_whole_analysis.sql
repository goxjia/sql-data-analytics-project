-- Which categories contribute the most to overall sales?
WITH category_sales AS(
SELECT
	category,
	sum(sales_amount) AS total_sales
FROM
	products p
LEFT JOIN fact_sales fs
		USING(product_key)
WHERE
	order_date IS NOT NULL
GROUP BY
	category)

SELECT
	category,
	total_sales,
	sum(total_sales) OVER() AS overall_sales,
	concat(round(total_sales / sum(total_sales) OVER() * 100, 2), '%') AS percentage
FROM
	category_sales;
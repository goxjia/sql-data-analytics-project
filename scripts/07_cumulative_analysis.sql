WITH data_monthly AS(
SELECT
	DATE_FORMAT(order_date, '%Y-%m') AS order_month,
	sum(sales_amount) AS total_sales,
	avg(price) AS average_price
FROM
	fact_sales fs
WHERE
	order_date IS NOT NULL
	AND order_date <> ''
GROUP BY
	DATE_FORMAT(order_date, '%Y-%m'))

	SELECT
	order_month,
	total_sales,
	average_price ,
	sum(total_sales) OVER(ORDER BY order_month ASC ) AS running_total_sales,
	round(avg(average_price) OVER(ORDER BY order_month ASC), 2) AS running_average_price
FROM
	data_monthly
ORDER BY
	order_month ;
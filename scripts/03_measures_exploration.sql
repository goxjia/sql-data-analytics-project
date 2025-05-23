/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

/*
Find the Total Sales
Find how many items are sold
Find the average selling price
Find the Total number of Orders
Find the total number of products
Find the total number of customers
Find the total number of customers that has placed an order
Generate a Report that shows all key metrics of the business
*/
SELECT
	'Total Sales' AS measure_name,
	SUM(sales_amount) AS measure_value
FROM
	fact_sales fs
UNION ALL
SELECT
	'Items Sold',
	sum(quantity)
FROM
	fact_sales fs
UNION ALL
SELECT
	'Avg Selling Price',
	avg(price)
FROM
	fact_sales fs
UNION ALL
SELECT
	'Total Orders',
	count(DISTINCT order_number)
FROM
	fact_sales fs
UNION ALL
SELECT
	'Total Products',
	count(product_key)
FROM
	products p
UNION ALL
SELECT
	'Total Customers',
	count(customer_key)
FROM
	customers c
UNION ALL
SELECT
	'Nr. Customers Placed an Order',
	count(DISTINCT customer_key)
FROM
	fact_sales fs;

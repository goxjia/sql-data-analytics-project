/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), TIMESTAMPDIFF()
===============================================================================
*/
-- Determine the first and last order date and the total duration in months
SELECT
	min(order_date) AS first_order_date,
	max(order_date) AS last_order_date,
	TIMESTAMPDIFF(MONTH, min(order_date), max(order_date)) AS total_duration
FROM
	fact_sales fs
WHERE
	order_date <> '';

-- Find the youngest and oldest customer based on birthdate
SELECT
	max(birthdate) AS youngest_birthdate,
	TIMESTAMPDIFF(year, max(birthdate), CURDATE()) AS youngest_age,
	min(birthdate) AS oldest_birthdate,
	TIMESTAMPDIFF(year, min(birthdate), CURDATE()) AS oldest_age
FROM
	customers;


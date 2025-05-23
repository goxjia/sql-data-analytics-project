USE DataWarehouseAnalytics;

# 简单日期函数
SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM
    fact_sales
WHERE
	#order_date不为空值且不为空格
    order_date IS NOT NULL and order_date <> ''
GROUP BY YEAR(order_date) , MONTH(order_date)
ORDER BY YEAR(order_date) , MONTH(order_date);

# DATE_FORMAT语句
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM
    fact_sales
WHERE
    order_date IS NOT NULL
        AND order_date <> ''
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY DATE_FORMAT(order_date, '%Y-%m');
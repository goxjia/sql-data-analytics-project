/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
CREATE VIEW report_products AS
WITH basic_query AS (
    -- Gathers essential information for each sales record
    SELECT
        fs.order_number,
        fs.order_date,
        fs.sales_amount,
        fs.quantity,
        fs.customer_key,
        fs.product_key,
        p.product_number,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM
        fact_sales fs
    LEFT JOIN
        products p ON fs.product_key = p.product_key
    WHERE
        fs.order_date IS NOT NULL
        AND fs.order_date <> ''
),
product_aggregation AS (
    -- Aggregates product-level metrics from the basic_query
    SELECT
        bq.product_key,
        bq.product_number,
        bq.product_name,
        bq.category,
        bq.subcategory,
        bq.cost,
        COUNT(DISTINCT bq.order_number) AS total_orders,
        SUM(bq.sales_amount) AS total_sales,
        SUM(bq.quantity) AS total_quantity_sold,
        COUNT(DISTINCT bq.customer_key) AS total_customers,
        MIN(bq.order_date) AS first_order,
        MAX(bq.order_date) AS last_order,
        TIMESTAMPDIFF(MONTH, MIN(bq.order_date), MAX(bq.order_date)) AS lifespan
    FROM
        basic_query bq
    GROUP BY
        bq.product_key,
        bq.product_number,
        bq.product_name,
        bq.category,
        bq.subcategory,
        bq.cost
)
SELECT
    pa.product_key,
    pa.product_number,
    pa.product_name,
    pa.category,
    pa.subcategory,
    pa.cost,
    CASE
        WHEN pa.total_sales > 50000 THEN 'High-Performers'
        WHEN pa.total_sales > 10000 THEN 'Mid-Range'
        ELSE 'Low-Performers'
    END AS product_segment,
    pa.total_orders,
    pa.total_sales,
    pa.total_quantity_sold,
    pa.total_customers,
    pa.lifespan,
    TIMESTAMPDIFF(MONTH, pa.last_order, CURDATE()) AS recency,
    CASE
        WHEN pa.total_orders = 0 THEN pa.total_sales -- Handle cases where total_orders might be 0 to avoid division by zero
        ELSE ROUND(pa.total_sales / pa.total_orders, 2)
    END AS avg_order_revenue,
    CASE
        WHEN pa.lifespan = 0 THEN pa.total_sales -- Handle cases where lifespan might be 0 (e.g., only one sale)
        ELSE ROUND(pa.total_sales / pa.lifespan, 2)
    END AS avg_monthly_revenue
FROM
    product_aggregation pa;
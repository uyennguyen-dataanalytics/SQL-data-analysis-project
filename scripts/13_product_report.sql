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
WITH base_query AS (
SELECT
s.order_number,
s.order_date,
s.customer_key,
s.sales_amount,
s.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
),
product_aggregation AS (
SELECT
product_key,
product_name,
category,
subcategory,
cost,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT order_number) AS total_orders,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers,
MAX(order_date) AS last_sale_date,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
sales_amount/quantity AS avg_selling_price
FROM base_query
GROUP BY 
product_key,
product_name,
category,
subcategory,
cost
)

SELECT
product_key,
product_name,
category,
subcategory,
cost,
last_sale_date,
DATEDIFF(MONTH, last_sale_date, GETDATE()) AS months_since_last_sale,
CASE WHEN total_sales > 50000 THEN 'High performer'
     WHEN total_sales >= 10000 THEN 'Mid range'
     ELSE 'Low performer'
END product_segment,
total_sales,
total_orders,
total_quantity,
total_customers,
lifespan
FROM product_aggregation

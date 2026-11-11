/*
===============================================================================
Product Report
===============================================================================
Purpose:
    Consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High performers, Mid range, or Low performers.
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

/*---------------------------------------------------------------------------
Create view: gold.report_products
---------------------------------------------------------------------------*/

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
CREATE VIEW gold.report_products AS

/*---------------------------------------------------------------------------
Base query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
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

/*---------------------------------------------------------------------------
Customer aggregation: Summarize key metrics at product level
---------------------------------------------------------------------------*/
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
        ROUND(AVG(CAST(sales_amount AS FLOAT)/NULLIF(quantity,0)),1) AS avg_selling_price
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
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS months_since_last_sale, -- KPI: recency
    CASE WHEN total_sales > 50000 THEN 'High performer'
         WHEN total_sales >= 10000 THEN 'Mid range'
         ELSE 'Low performer'
    END product_segment,
    total_sales,
    total_orders,
    total_quantity,
    total_customers,
    avg_selling_price,
    lifespan,
    CASE WHEN total_orders = 0 THEN 0
         ELSE total_sales/total_orders 
    END AS avg_order_revenue,                                             -- KPI: average order revenue
    CASE WHEN lifespan = 0 THEN total_sales
         ELSE total_sales/lifespan
    END avg_monthly_revenue                                               -- KPI: average monthly revenue
FROM product_aggregation



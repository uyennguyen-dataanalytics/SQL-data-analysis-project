/*
============================================================================
Cummulative Analysis
============================================================================
Purpose:
  Calculate running totals or moving averages for key metrics
  Track performance over time
  For growth analysis and identify long-term trends
SQL functions used:
  Aggregate window functions: SUM() OVER(), AVG() OVER()
*/

-- Calculate the total sales per month and 
-- the running total of sales over time, which restarts each year, and
-- the moving average of price over time
SELECT
  order_date,
  total_sales,
  SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales,
  AVG(average_price) OVER (PARTITION BY order_date ORDER BY order_date) AS moving_average_price
FROM (
  SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    AVG(price) AS average_price
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATETRUNC(month, order_date)
) t

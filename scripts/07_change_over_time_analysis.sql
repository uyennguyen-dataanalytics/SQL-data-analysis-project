/*
=======================================================
Change Over Time Analysis
=======================================================
Purpose:
  Track trends, growth, and changes in key metrics over time
  For time-series analysis

SQL functions used:
  Date functions: DATETRUNC(), FORMAT()
  Aggregation functions: SUM(), COUNT(), AVG()
*/

-- Analyze sales performance over time
-- Using date functions
SELECT
  YEAR(order_date) AS order_year,
  MONTH(order_date) AS order_month,
  SUM(sales_amount) AS total_sales,
  COUNT(DISTINCT customer_key) AS total_customers,
  SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

-- Using DATETRUNC()
SELECT 
  DATETRUNC(month, order_date) AS order_date,
  SUM(sales_amount) AS total_sales,
  COUNT(DISTINCT customer_key) AS total_customers,
  SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)

-- Using FORMAT()
-- Note: FORMAT() returns text, so ORDER BY sorts months alphabetically
SELECT 
  FORMAT(order_date, 'yyyy-MMM') AS order_date,
  SUM(sales_amount) AS total_sales,
  COUNT(DISTINCT customer_key) AS total_customers,
  SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')

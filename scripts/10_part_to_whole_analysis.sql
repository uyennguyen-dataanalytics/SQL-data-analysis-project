/*
=============================================================
Part-to-Whole Analysis
=============================================================
Purpose:
  Find the proportion of each part compared to the whole

SQL functions used:
  SUM(): aggregate values per category
  Aggregate window function: SUM() OVER() for the overall total
*/

-- Which categories contribute the most to overall sales?
WITH category_sales AS (
	SELECT
	category,
	SUM(sales_amount) total_sales
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	GROUP BY category
)

SELECT
	category,
	total_sales,
	SUM(total_sales) OVER () overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT) /SUM(total_sales) OVER ())*100,2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC

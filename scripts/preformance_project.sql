WITH yearly_product_sale AS (
SELECT
	YEAR(f.order_date) AS order_year,
	p.product_name AS product_name,
	SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE YEAR(f.order_date) IS NOT NULL
GROUP BY YEAR(f.order_date), p.product_name
)

SELECT
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg_sales,
	CASE 
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS perf_diff,
	LAG(current_sales) OVER( PARTITION BY product_name ORDER BY order_year) AS priv_year_sales ,
	current_sales - LAG(current_sales) OVER( PARTITION BY product_name ORDER BY order_year) AS prev_yr_diff,
	CASE 
		WHEN current_sales - LAG(current_sales) OVER( PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increased'
		WHEN current_sales - LAG(current_sales) OVER( PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decreased'
		ELSE 'Same'
	END AS py_sales_diff
FROM yearly_product_sale
ORDER BY product_name, order_year

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP TABLE gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS sub_category,
	pc.maintenance AS maintenance,
	pn.prd_cost AS product_cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL

===================================================================================================================

  IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP TABLE gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
SELECT
	sls_ord_num AS order_number,
	pr.product_key,
	ci.customer_key,
	sls_order_dt AS order_date,
	sls_ship_dt AS shipping_date,
	sls_due_dt AS due_date,
	sls_sales AS sales_amount,
	sls_quantity AS quantity,
	sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customer ci
ON sd.sls_cust_id = ci.customer_id

=======================================================================================================

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP TABLE gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
SELECT
	sls_ord_num AS order_number,
	pr.product_key,
	ci.customer_key,
	sls_order_dt AS order_date,
	sls_ship_dt AS shipping_date,
	sls_due_dt AS due_date,
	sls_sales AS sales_amount,
	sls_quantity AS quantity,
	sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customer ci
ON sd.sls_cust_id = ci.customer_id

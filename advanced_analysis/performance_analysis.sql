/*=====================================================================
3. PERFORMANCE ANALYSIS

Purpose:
Evaluate yearly product performance.

Business Questions:
- Is each product performing above or below its historical average?
- Did product sales improve compared to the previous year?
=====================================================================*/

WITH yearly_product_sales AS
(
    SELECT
        EXTRACT(YEAR FROM a.order_date)::INT AS order_year,
        b.product_name,
        SUM(a.sales_amount) AS current_sales
    FROM gold.fact_sales a
    LEFT JOIN gold.dim_products b ON a.product_key = b.product_key
    WHERE a.order_date IS NOT NULL
    GROUP BY
        EXTRACT(YEAR FROM a.order_date), b.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
    CASE
        WHEN current_sales > AVG(current_sales) OVER(PARTITION BY product_name) THEN 'Above Average'
        WHEN current_sales < AVG(current_sales) OVER(PARTITION BY product_name) THEN 'Below Average'
        ELSE 'Average'
    END AS avg_change,
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,
    current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_previous_year,
    CASE
        WHEN current_sales > LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) THEN 'Increase'
        WHEN current_sales < LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) THEN 'Decrease'
        ELSE 'No Change'
    END AS previous_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year;

/*=====================================================================
4. PART TO WHOLE ANALYSIS

Purpose:
Measure the contribution of each product category to total sales.

Business Questions:
- Which product categories generate the highest revenue?
- What percentage of total sales does each category represent?
=====================================================================*/

WITH category_sales AS
(
    SELECT
        b.category,
        SUM(a.sales_amount) AS total_sales
    FROM gold.fact_sales a
    LEFT JOIN gold.dim_products b ON a.product_key = b.product_key
    GROUP BY b.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    ROUND( total_sales / SUM(total_sales) OVER()*100,2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;

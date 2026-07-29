/*=====================================================================
5.1 PRODUCT SEGMENTATION

Purpose:
Group products according to cost ranges.

Business Questions:
- How many products belong to each pricing segment?
=====================================================================*/

WITH product_segments AS
(
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost <100 THEN 'Below 100'
            WHEN cost <500 THEN '100-500'
            WHEN cost <1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT
    cost_range,
    COUNT(*) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

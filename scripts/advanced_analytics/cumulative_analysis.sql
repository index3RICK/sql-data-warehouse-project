/*=====================================================================
2. CUMULATIVE ANALYSIS

Purpose:
Calculate running totals over time.

Business Questions:
- What are the accumulated sales month by month?
- Is business growth accelerating or slowing down?
=====================================================================*/

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month', order_date)::date AS order_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', order_date)
)

SELECT
    order_month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_month) AS running_total_sales
FROM monthly_sales
ORDER BY order_month;

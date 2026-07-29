/*=====================================================================
1. CHANGES OVER TIME ANALYSIS

Purpose:
Analyze business evolution over time.

Business Questions:
- How do sales evolve month by month?
- How many customers purchase each month?
- How many products are sold each month?
=====================================================================*/

SELECT
    DATE_TRUNC('month', order_date)::date AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;

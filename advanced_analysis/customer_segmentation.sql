/*=====================================================================
5.2 CUSTOMER SEGMENTATION

Purpose:
Segment customers according to purchase history and spending.

Segments:
- VIP
- Regular
- New
=====================================================================*/

WITH customer_spending AS
(
    SELECT
        customer_key,
        SUM(sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY customer_key
),
customer_segments AS
(
    SELECT
        customer_key,
        total_spending,
        ( EXTRACT(YEAR FROM AGE(last_order, first_order))*12 + EXTRACT(MONTH FROM AGE(last_order, first_order))) AS lifespan_months
    FROM customer_spending
)
SELECT
    CASE
        WHEN lifespan_months>=12 AND total_spending>5000 THEN 'VIP'
        WHEN lifespan_months>=12 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    COUNT(*) AS total_customers
FROM customer_segments
GROUP BY customer_segment
ORDER BY total_customers DESC;

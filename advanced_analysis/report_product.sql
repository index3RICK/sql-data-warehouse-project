/*
==============================================================================
Product Report
==============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.
Highlights:
    1. Retrieves essential product information:
        - Product Name
        - Category
        - Subcategory
        - Cost
    2. Segments products by revenue:
        - High Performer
        - Mid Range
        - Low Performer
    3. Aggregates product-level metrics:
        - Total Orders
        - Total Sales
        - Total Quantity Sold
        - Total Customers
        - Lifespan (Months)
    4. Calculates business KPIs:
        - Recency (Months Since Last Sale)
        - Average Order Revenue (AOR)
        - Average Monthly Revenue
==============================================================================
*/
CREATE OR REPLACE VIEW gold.report_products AS
/*==============================================================================
1. Base Query
   Retrieves transactional and product information.
==============================================================================*/
WITH base_query AS (
    SELECT

        a.order_number,
        a.order_date,
        a.customer_key,
        a.sales_amount,
        a.quantity,
        b.product_key,
        b.product_name,
        b.category,
        b.subcategory,
        b.cost
    FROM gold.fact_sales a
    LEFT JOIN gold.dim_products b ON a.product_key = b.product_key
    WHERE a.order_date IS NOT NULL

),
/*==============================================================================
2. Product Aggregation
   Calculates product-level business metrics.
==============================================================================*/
product_aggregation AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customers,
        MIN(order_date) AS first_sale_date,
        MAX(order_date) AS last_sale_date,
        (EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 + EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))))::INT AS lifespan_months
    FROM base_query
    GROUP BY product_key, product_name, category, subcategory, cost
)

/*==============================================================================
3. Final Report
==============================================================================*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    CASE
        WHEN total_sales >= 50000 THEN 'High Performer'
        WHEN total_sales >= 10000 THEN 'Mid Range'
        ELSE 'Low Performer'
    END AS product_segment,
    last_sale_date,
    (EXTRACT(YEAR FROM AGE(CURRENT_DATE,last_sale_date))*12 + EXTRACT(MONTH FROM AGE(CURRENT_DATE,last_sale_date)))::INT AS recency_months,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    lifespan_months,
    ROUND(total_sales / NULLIF(total_orders,0),2) AS avg_order_revenue,
    ROUND(total_sales / NULLIF(GREATEST(lifespan_months,1),0),2) AS avg_monthly_revenue
FROM product_aggregation;

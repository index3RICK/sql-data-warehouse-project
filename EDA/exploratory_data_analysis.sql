/*
===============================================================================
 Exploratory Data Analysis (EDA)
===============================================================================

Project:
    SQL Data Warehouse Project

Purpose:
    Perform an initial exploratory analysis of the Gold Layer in order to
    understand the structure, quality, distribution and business value of
    the data before creating dashboards or performing advanced analytics.

Objectives:
    • Explore database objects.
    • Explore dimensions.
    • Explore measures.
    • Calculate business KPIs.
    • Analyze magnitude.
    • Identify rankings.
    • Prepare the dataset for advanced analytics.

Author : Erick Chicaiza
Database : PostgreSQL
Layer : Gold
===============================================================================
*/

------------------------------------------------------------
-- DATABASE EXPLORATION
------------------------------------------------------------

-- Explore all objects in the Gold Layer

SELECT
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema='gold'
ORDER BY table_name;


------------------------------------------------------------
-- Explore all columns of each table
------------------------------------------------------------

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema='gold'
AND table_name='dim_customers'
ORDER BY ordinal_position;


SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema='gold'
AND table_name='dim_products'
ORDER BY ordinal_position;


SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema='gold'
AND table_name='fact_sales'
ORDER BY ordinal_position;


------------------------------------------------------------
-- DIMENSIONS EXPLORATION
------------------------------------------------------------

-- Customer Dimensions

SELECT DISTINCT country
FROM gold.dim_customers
ORDER BY country;

SELECT DISTINCT gender
FROM gold.dim_customers
ORDER BY gender;

SELECT DISTINCT marital_status
FROM gold.dim_customers
ORDER BY marital_status;


-- Product Dimensions

SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name;

------------------------------------------------------------
-- DATE EXPLORATION
------------------------------------------------------------

-- Sales date range

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    AGE(MAX(order_date),MIN(order_date)) AS order_period,
    EXTRACT(YEAR FROM AGE(MAX(order_date),MIN(order_date))) AS years_of_sales
FROM gold.fact_sales;

------------------------------------------------------------
-- Customer Age Exploration
------------------------------------------------------------

SELECT
    MIN(birthdate) AS oldest_birthdate,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE,MIN(birthdate))) AS oldest_customer_age,
    MAX(birthdate) AS youngest_birthdate,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE,MAX(birthdate))) AS youngest_customer_age
FROM gold.dim_customers;

------------------------------------------------------------
-- MEASURES EXPLORATION
------------------------------------------------------------

SELECT SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


SELECT SUM(quantity) AS total_quantity
FROM gold.fact_sales;


SELECT AVG(price) AS average_price
FROM gold.fact_sales;


SELECT COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;


SELECT COUNT(DISTINCT product_key) AS total_products
FROM gold.dim_products;


SELECT COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers;


SELECT COUNT(DISTINCT customer_key) AS customers_with_orders
FROM gold.fact_sales;


------------------------------------------------------------
-- BUSINESS KPI SUMMARY
------------------------------------------------------------

SELECT 'Total Sales' AS metric, SUM(sales_amount)::numeric FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', ROUND(AVG(price),2) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers;


------------------------------------------------------------
-- MAGNITUDE ANALYSIS
------------------------------------------------------------
-- Customers by Country
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

------------------------------------------------------------
-- Customers by Gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

------------------------------------------------------------
-- Products by Category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

------------------------------------------------------------
-- Average Product Cost by Category
SELECT
    category,
    ROUND(AVG(cost),2) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;

------------------------------------------------------------
-- Revenue by Category
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key=f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

------------------------------------------------------------
-- Revenue by Customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key=f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC;

------------------------------------------------------------
-- Quantity Sold by Country
SELECT
    c.country,
    SUM(f.quantity) AS total_items_sold
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key=f.customer_key
GROUP BY c.country
ORDER BY total_items_sold DESC;


------------------------------------------------------------
-- RANKING ANALYSIS
------------------------------------------------------------
-- Top 5 Products by Revenue
SELECT *
FROM(
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER(
            ORDER BY SUM(f.sales_amount) DESC
        ) AS product_rank
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON p.product_key=f.product_key
    GROUP BY p.product_name
)t
WHERE product_rank<=5;

------------------------------------------------------------
-- Bottom 5 Products by Revenue
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key=f.product_key
GROUP BY p.product_name
ORDER BY total_revenue
LIMIT 5;

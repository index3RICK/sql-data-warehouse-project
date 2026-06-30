/*
=========================================================================================================
  Data Quality Checks | CRM Sales Details
=========================================================================================================
PURPOSE:
This script profiles the Bronze CRM Sales table before loading data into the Silver layer.

Checks include:
    - Invalid dates
    - Incorrect sales calculations
    - Negative or missing prices
    - Invalid quantities

These validations define the business rules implemented
during the Silver ETL process.
=========================================================================================================
*/

-- Invalid Order Dates
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt = 0
   OR LENGTH(sls_order_dt::TEXT) <> 8;
-- Invalid Ship Dates
SELECT *
FROM bronze.crm_sales_details
WHERE sls_ship_dt = 0
   OR LENGTH(sls_ship_dt::TEXT) <> 8;
-- Invalid Due Dates
SELECT *
FROM bronze.crm_sales_details
WHERE sls_due_dt = 0
   OR LENGTH(sls_due_dt::TEXT) <> 8;
-
-- Invalid Sales Amount
SELECT *
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL
   OR sls_sales <= 0
   OR sls_sales <> sls_quantity * ABS(sls_price);
-- Invalid Price
SELECT *
FROM bronze.crm_sales_details
WHERE sls_price IS NULL
   OR sls_price <= 0;
-- Invalid Quantity
SELECT *
FROM bronze.crm_sales_details
WHERE sls_quantity <= 0;

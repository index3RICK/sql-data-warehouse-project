/*
=========================================================================================================
  Data Quality Checks | ERP Customer Information
=========================================================================================================
PURPOSE:
This script profiles the Bronze ERP Customer table before loading data into the Silver layer.

Checks include:
    - Customer ID formatting
    - Future birth dates
    - Unrealistic birth dates
    - Gender inconsistencies

The results define the cleansing rules applied during the Silver ETL process.
=========================================================================================================
*/

-- Customer IDs with NAS prefix
SELECT *
FROM bronze.erp_cust_az12
WHERE cid LIKE 'NAS%';
-- Future Birth Dates
SELECT *
FROM bronze.erp_cust_az12
WHERE bdate > CURRENT_DATE;
-- Customers older than 100 years
SELECT *
FROM bronze.erp_cust_az12
WHERE bdate < CURRENT_DATE - INTERVAL '100 years';
-- Review Gender Values
SELECT DISTINCT
    gen
FROM bronze.erp_cust_az12
ORDER BY gen;

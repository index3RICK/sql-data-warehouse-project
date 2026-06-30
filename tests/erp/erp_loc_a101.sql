/*
=========================================================================================================
  Data Quality Checks | ERP Customer Location
=========================================================================================================
PURPOSE:
This script profiles the Bronze ERP Location table before loading data into the Silver layer.

Checks include:
    - Customer ID formatting
    - Missing countries
    - Country code inconsistencies

These validations define the standardization rules used
during the Silver ETL process.
=========================================================================================================
*/

-- Customer IDs containing '-'
SELECT *
FROM bronze.erp_loc_a101
WHERE cid LIKE '%-%';
-- Missing Countries
SELECT *
FROM bronze.erp_loc_a101
WHERE ctry IS NULL
   OR TRIM(ctry) = '';
-- Review Country Values
SELECT DISTINCT
    ctry
FROM bronze.erp_loc_a101
ORDER BY ctry;

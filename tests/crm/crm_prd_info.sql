/*
=========================================================================================================
  Data Quality Checks | CRM Product Information
=========================================================================================================
PURPOSE:
This script profiles the Bronze CRM Product table before loading data into the Silver layer.

The goal is to identify common data quality issues such as:
    - Duplicate product keys
    - Missing values
    - Invalid product costs
    - Inconsistent product lines
    - Historical product versions

These checks help define the cleansing and transformation rules applied
during the Silver ETL process.
=========================================================================================================
*/

-- Check for duplicate Product Keys
SELECT
    prd_key,
    COUNT(*) AS duplicate_count
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*) > 1;
-- View duplicated products
SELECT *
FROM bronze.crm_prd_info
WHERE prd_key IN
(
    SELECT prd_key
    FROM bronze.crm_prd_info
    GROUP BY prd_key
    HAVING COUNT(*) > 1
)
ORDER BY prd_key, prd_start_dt;
-- Check for NULL product costs
SELECT *
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL;
-- Review Product Line values
SELECT DISTINCT
    prd_line
FROM bronze.crm_prd_info
ORDER BY prd_line;

-- Review product history (used to calculate End Date)
SELECT *
FROM bronze.crm_prd_info
ORDER BY prd_key, prd_start_dt;

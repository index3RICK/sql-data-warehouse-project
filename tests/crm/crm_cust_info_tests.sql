/*
==========================================================
Data Quality Checks - bronze.crm_cust_info
==========================================================
Checks performed:

1. Primary Key validation
2. Duplicate records
3. Null values
4. Leading / trailing spaces
5. Invalid marital status
6. Invalid gender values
*/

-- validation cst_id
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;
-- duplicate
SELECT *
FROM bronze.crm_cust_info
WHERE cst_id IN (
    SELECT cst_id
    FROM bronze.crm_cust_info
    GROUP BY cst_id
    HAVING COUNT(*) > 1
)
ORDER BY cst_id, cst_create_date DESC;
-- spaces firstname
SELECT
    cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);
-- spaces lastname
SELECT
    cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname <> TRIM(cst_lastname);
-- marital status
SELECT DISTINCT
    cst_marital_status
FROM bronze.crm_cust_info;
-- invalid gender
SELECT DISTINCT
    cst_gndr
FROM bronze.crm_cust_info;

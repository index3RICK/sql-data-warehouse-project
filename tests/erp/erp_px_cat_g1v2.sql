/*
=========================================================================================================
  Data Quality Checks | ERP Product Categories
=========================================================================================================
PURPOSE:
This script profiles the Bronze ERP Product Category table before loading data into the Silver layer.

Checks include:
    - Missing IDs
    - Missing categories
    - Missing subcategories
    - Missing maintenance values

This table requires minimal cleansing but is still validated
to ensure data completeness.
=========================================================================================================
*/

-- Missing Product IDs
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE id IS NULL;
-- Missing Categories
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat IS NULL;
-- Missing Subcategories
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE subcat IS NULL;
-- Missing Maintenance Values
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE maintenance IS NULL;
-- Review Category Structure
SELECT DISTINCT
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2
ORDER BY cat, subcat;

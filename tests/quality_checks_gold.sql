/*
=========================================================================================================
 Gold Layer Quality Checks | Validaciones de Calidad de la Capa Gold
=========================================================================================================

PURPOSE:
This script validates the Gold layer after the dimensional model has been created.

The objective is to ensure that dimensions and fact tables are ready for reporting by checking:

    • Duplicate surrogate keys
    • Duplicate business keys
    • Referential integrity
    • Null foreign keys
    • Dimension consistency
    • Business rule validation

These checks should return no unexpected results.

---------------------------------------------------------------------------------------------------------

PROPÓSITO:
Este script valida la capa Gold una vez creado el modelo dimensional.

El objetivo es garantizar que las dimensiones y la tabla de hechos estén listas para
reportes mediante la validación de:

    • Claves sustitutas duplicadas
    • Claves de negocio duplicadas
    • Integridad referencial
    • Claves foráneas nulas
    • Consistencia entre dimensiones
    • Validación de reglas de negocio

Estas consultas no deberían devolver resultados inesperados.

=========================================================================================================
*/
----------------------------------------------------------------------------------------
-- Check 1
-- Verify duplicate surrogate keys (Customer Dimension)
----------------------------------------------------------------------------------------

SELECT
    customer_key,
    COUNT(*)
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

----------------------------------------------------------------------------------------
-- Check 2
-- Verify duplicate business keys (Customer Dimension)
----------------------------------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*)
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

----------------------------------------------------------------------------------------
-- Check 3
-- Verify duplicate surrogate keys (Product Dimension)
----------------------------------------------------------------------------------------

SELECT
    product_key,
    COUNT(*)
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

----------------------------------------------------------------------------------------
-- Check 4
-- Verify duplicate business keys (Product Dimension)
----------------------------------------------------------------------------------------

SELECT
    product_id,
    COUNT(*)
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1;

----------------------------------------------------------------------------------------
-- Check 5
-- Verify referential integrity (Customer Dimension)
----------------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

----------------------------------------------------------------------------------------
-- Check 6
-- Verify referential integrity (Product Dimension)
----------------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;

----------------------------------------------------------------------------------------
-- Check 7
-- Verify NULL foreign keys
----------------------------------------------------------------------------------------

SELECT *
FROM gold.fact_sales
WHERE customer_key IS NULL
   OR product_key IS NULL;

----------------------------------------------------------------------------------------
-- Check 8
-- Verify gender standardization
----------------------------------------------------------------------------------------

SELECT DISTINCT
    a.cst_gndr AS crm_gender,
    b.gen AS erp_gender,
    CASE
        WHEN a.cst_gndr <> 'n/a' THEN a.cst_gndr
        ELSE COALESCE(b.gen,'n/a')
    END AS final_gender
FROM silver.crm_cust_info a
LEFT JOIN silver.erp_cust_az12 b ON a.cst_key = b.cid
ORDER BY 1,2;

----------------------------------------------------------------------------------------
-- Check 9
-- Verify customer uniqueness after enrichment
----------------------------------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*)
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

----------------------------------------------------------------------------------------
-- Check 10
-- Verify active products only
----------------------------------------------------------------------------------------

SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt IS NULL;

----------------------------------------------------------------------------------------
-- Resultados Esperados
----------------------------------------------------------------------------------------

-- Las validaciones de duplicados no deben devolver registros.
-- Las validaciones de integridad referencial no deben devolver registros.
-- Las validaciones de claves foráneas nulas no deben devolver registros.
-- La validación de género es únicamente para revisión manual.
-- La consulta de productos activos sirve para validar la regla de negocio.

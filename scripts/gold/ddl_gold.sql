/*
=========================================================================================================
 Create Gold Views | Creación de las Vistas de la Capa Gold
=========================================================================================================

PURPOSE:
This script creates the Gold layer views that provide a business-ready dimensional model
optimized for reporting and analytical queries.

The Gold layer consists of:

    • Customer Dimension
    • Product Dimension
    • Sales Fact Table

These views consume the cleansed and standardized data from the Silver layer.

---------------------------------------------------------------------------------------------------------

PROPÓSITO:
Este script crea las vistas de la capa Gold que proporcionan un modelo dimensional
listo para el negocio y optimizado para reportes y análisis.

La capa Gold está compuesta por:

    • Dimensión de Clientes
    • Dimensión de Productos
    • Tabla de Hechos de Ventas

Estas vistas consumen los datos limpios y estandarizados provenientes de la capa Silver.
=========================================================================================================
*/


/*=========================================================================================================
    View: gold.dim_customers
==========================================================================================================
Purpose:
    Stores customer information enriched from CRM and ERP systems.
    Each record represents the latest version of a customer.

Propósito:
    Almacena la información de clientes enriquecida con datos del CRM y ERP.
    Cada registro representa la versión más reciente del cliente.
=========================================================================================================*/

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    a.cst_id AS customer_id,
    a.cst_key AS customer_number,
    a.cst_firstname AS first_name,
    a.cst_lastname AS last_name,
    c.ctry AS country,
    a.cst_marital_status AS marital_status,
    CASE
        WHEN a.cst_gndr <> 'n/a'
            THEN a.cst_gndr
        ELSE COALESCE(b.gen,'n/a')
    END AS gender,
    b.bdate AS birthdate,
    a.cst_create_date AS create_date
FROM silver.crm_cust_info a
LEFT JOIN silver.erp_cust_az12 b ON a.cst_key = b.cid
LEFT JOIN silver.erp_loc_a101 c ON a.cst_key = c.cid;

/*=========================================================================================================
    View: gold.dim_products
==========================================================================================================
Purpose:
    Stores the current product catalog enriched with ERP category information.
    Only active products are included.

Propósito:
    Almacena el catálogo actual de productos enriquecido con información de categorías
    provenientes del ERP.

    Solo se incluyen productos activos.
=========================================================================================================*/

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY a.prd_start_dt,a.prd_key) AS product_key,
    a.prd_id AS product_id,
    a.prd_key AS product_number,
    a.prd_nm AS product_name,
    a.cat_id AS category_id,
    b.cat AS category,
    b.subcat AS subcategory,
    b.maintenance,
    a.prd_cost AS cost,
    a.prd_line AS product_line,
    a.prd_start_dt AS start_date
FROM silver.crm_prd_info a
LEFT JOIN silver.erp_px_cat_g1v2 b ON a.cat_id = b.id
WHERE a.prd_end_dt IS NULL;


/*=========================================================================================================
    View: gold.fact_sales
==========================================================================================================
Purpose:
    Stores sales transactions linked to customer and product dimensions.

    Each record represents one sales order line.

Propósito:
    Almacena las transacciones de ventas relacionadas con las dimensiones
    de clientes y productos.

    Cada registro representa una línea de una orden de venta.
=========================================================================================================*/

CREATE VIEW gold.fact_sales AS
SELECT
    a.sls_ord_num AS order_number,
    b.product_key,
    c.customer_key,
    a.sls_order_dt AS order_date,
    a.sls_ship_dt AS shipping_date,
    a.sls_due_dt AS due_date,
    a.sls_sales AS sales_amount,
    a.sls_quantity AS quantity,
    a.sls_price AS price
FROM silver.crm_sales_details a
LEFT JOIN gold.dim_products b ON a.sls_prd_key = b.product_number
LEFT JOIN gold.dim_customers c ON a.sls_cust_id = c.customer_id;

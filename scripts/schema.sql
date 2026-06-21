/*
=========================================================================================================
  Create Schemas | Creación de esquemas (Data Warehouse Layers)
=========================================================================================================
  PURPOSE:
    This script creates the logical structure of the Data Warehouse using schemas only.

    Layers:
      - Bronze
      - Silver
      - Gold

  CONTEXT:
    - This script assumes you are already connected to the 'datawarehouse' database.
    - It does NOT create or drop the database.
    - It only defines the internal structure (schemas) of the Data Warehouse.

  ARCHITECTURE:
    This follows the Medallion Architecture commonly used in Data Engineering:
    Bronze → Silver → Gold

  NOTE:
    Schemas help organize data logically inside a single database and support scalable ETL pipelines.
=========================================================================================================
*/


-- =========================
-- BRONZE LAYER
-- =========================
CREATE SCHEMA IF NOT EXISTS bronze;
-- =========================
-- SILVER LAYER
-- =========================
CREATE SCHEMA IF NOT EXISTS silver;
-- =========================
-- GOLD LAYER
-- =========================
CREATE SCHEMA IF NOT EXISTS gold;

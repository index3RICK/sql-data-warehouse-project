/*
=========================================================================================================
  Load Data .csv | Carga masiva de datos .csv
=========================================================================================================
PURPOSE:
This script creates the Bronze layer tables used to store raw data from CRM and ERP source systems.
The purpose of this script is the massive data loading from .csv files.

NOTE:
Data is loaded without cleansing or transformation.
===================================================
*/

CREATE OR REPLACE PROCEDURE bronze.bronze_load()
AS
$$
DECLARE
    total_start_time TIMESTAMP;
    total_end_time TIMESTAMP;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
BEGIN

    total_start_time := clock_timestamp();

    RAISE NOTICE '######################################################################';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '######################################################################';

    ----------------------------------------------------------------------------
    -- CRM TABLES
    ----------------------------------------------------------------------------
    RAISE NOTICE '----------------------------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '----------------------------------------------------------------------';

    -- Table: bronze.crm_cust_info
    BEGIN
        start_time := clock_timestamp();

        RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
        COPY bronze.crm_cust_info
        FROM '/data/CRM/bronze.crm_cust_info.csv'
        DELIMITER ','
        CSV HEADER;

        end_time := clock_timestamp();

        RAISE NOTICE '>> Load Duration: % seconds',
            ROUND(EXTRACT(EPOCH FROM (end_time - start_time)),2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'ERROR Loading bronze.crm_cust_info';
            RAISE NOTICE '%', SQLERRM;
    END;

	RAISE NOTICE '';
    -- Table: bronze.crm_prd_info
    BEGIN
        start_time := clock_timestamp();

        RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
        COPY bronze.crm_prd_info
        FROM '/data/CRM/bronze.crm_prd_info.csv'
        DELIMITER ','
        CSV HEADER;

        end_time := clock_timestamp();

        RAISE NOTICE '>> Load Duration: % seconds',
            ROUND(EXTRACT(EPOCH FROM (end_time - start_time)),2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'ERROR Loading bronze.crm_prd_info';
            RAISE NOTICE '%', SQLERRM;
    END;

	RAISE NOTICE '';
    -- Table: bronze.crm_sales_details
    BEGIN
        start_time := clock_timestamp();

        RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
        COPY bronze.crm_sales_details
        FROM '/data/CRM/bronze.crm_sales_details.csv'
        DELIMITER ','
        CSV HEADER;

        end_time := clock_timestamp();

        RAISE NOTICE '>> Load Duration: % seconds',
            ROUND(EXTRACT(EPOCH FROM (end_time - start_time)),2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'ERROR Loading bronze.crm_sales_details';
            RAISE NOTICE '%', SQLERRM;
    END;

    ----------------------------------------------------------------------------
    -- ERP TABLES
    ----------------------------------------------------------------------------
    RAISE NOTICE '----------------------------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '----------------------------------------------------------------------';

    -- Table: bronze.erp_cust_az12
    BEGIN
        start_time := clock_timestamp();

        RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
        COPY bronze.erp_cust_az12
        FROM '/data/ERP/bronze.erp_cust_az12.csv'
        DELIMITER ','
        CSV HEADER;

        end_time := clock_timestamp();

        RAISE NOTICE '>> Load Duration: % seconds',
            ROUND(EXTRACT(EPOCH FROM (end_time - start_time)),2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'ERROR Loading bronze.erp_cust_az12';
            RAISE NOTICE '%', SQLERRM;
    END;
	
	RAISE NOTICE '';
    -- Table: bronze.erp_loc_a101
    BEGIN
        start_time := clock_timestamp();

        RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
        COPY bronze.erp_loc_a101
        FROM '/data/ERP/bronze.erp_loc_a101.csv'
        DELIMITER ','
        CSV HEADER;

        end_time := clock_timestamp();

        RAISE NOTICE '>> Load Duration: % seconds',
            ROUND(EXTRACT(EPOCH FROM (end_time - start_time)),2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'ERROR Loading bronze.erp_loc_a101';
            RAISE NOTICE '%', SQLERRM;
    END;
	
	RAISE NOTICE '';
    -- Table: bronze.erp_px_cat_g1v2
    BEGIN
        start_time := clock_timestamp();

        RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        COPY bronze.erp_px_cat_g1v2
        FROM '/data/ERP/bronze.erp_px_cat_g1v2.csv'
        DELIMITER ','
        CSV HEADER;

        end_time := clock_timestamp();

        RAISE NOTICE '>> Load Duration: % seconds',
            ROUND(EXTRACT(EPOCH FROM (end_time - start_time)),2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'ERROR Loading bronze.erp_px_cat_g1v2';
            RAISE NOTICE '%', SQLERRM;
    END;

    total_end_time := clock_timestamp();

    RAISE NOTICE '######################################################################';
    RAISE NOTICE 'Bronze Layer Load Finished';
    RAISE NOTICE '----------------------------------------------------------------------';
    RAISE NOTICE 'TOTAL EXECUTION TIME: % seconds',
        ROUND(EXTRACT(EPOCH FROM (total_end_time - total_start_time)),2);
    RAISE NOTICE '######################################################################';

END;
$$ LANGUAGE plpgsql;

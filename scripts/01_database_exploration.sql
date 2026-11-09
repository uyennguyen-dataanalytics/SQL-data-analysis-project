/*
======================================================
Database Exploration
======================================================
Purpose:
  Explore the structure of the database, including the list of tables and their schemas
  inspect the columns and metadata for specific tables
  
Tables used: 
  INFORMATION_SCHEMA.TABLES,
  INFORMATION_SCHEMA.COLUMNS
*/

-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES
-- or
SELECT
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES

-- Explore all columns in one specific table (e.g. dim_products)
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'
-- or
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'     -- retrieve only specific columns

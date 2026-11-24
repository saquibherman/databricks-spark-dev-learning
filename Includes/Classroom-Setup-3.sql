-- Databricks notebook source
-- MAGIC %run ./Classroom-Setup-Common

-- COMMAND ----------

-- DBTITLE 1,Validate Required Setup
-- Validate Required Setup
SELECT ensure_setup() AS status;

-- COMMAND ----------

-- DBTITLE 1,Set Working Schema
-- Set Working Schema
USE SCHEMA spark_dev;

SELECT
  current_user()    AS current_user,
  current_catalog() AS current_catalog,
  current_schema()  AS current_schema;
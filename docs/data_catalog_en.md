# Data Catalog

## Overview

The Gold layer contains the business-ready dimensional model used for reporting and analytics.

It consists of three business tables:

- Customer Dimension
- Product Dimension
- Sales Fact Table

The dimensional model follows a Star Schema where dimensions store descriptive information and the fact table stores business transactions.

---

# 1. gold.dim_customers

## Purpose

Stores customer information enriched from CRM and ERP systems.

Each record represents the latest version of a customer after the data cleansing and standardization process.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INT | Surrogate key uniquely identifying each customer. |
| customer_id | INT | Customer identifier from the CRM source system. |
| customer_number | VARCHAR | Business customer identifier shared across CRM and ERP. |
| first_name | VARCHAR | Customer first name. |
| last_name | VARCHAR | Customer last name. |
| country | VARCHAR | Customer country of residence. |
| marital_status | VARCHAR | Customer marital status. |
| gender | VARCHAR | Standardized customer gender. |
| birthdate | DATE | Customer birth date. |
| create_date | DATE | Customer creation date in CRM. |

---

# 2. gold.dim_products

## Purpose

Stores the current product catalog enriched with ERP category information.

Only active products are included.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INT | Surrogate key uniquely identifying each product. |
| product_id | INT | Product identifier from CRM. |
| product_number | VARCHAR | Business product identifier. |
| product_name | VARCHAR | Product name. |
| category_id | VARCHAR | Product category identifier. |
| category | VARCHAR | Product category. |
| subcategory | VARCHAR | Product subcategory. |
| maintenance | VARCHAR | Product maintenance classification. |
| cost | NUMERIC | Standard product cost. |
| product_line | VARCHAR | Product line. |
| start_date | DATE | Product activation date. |

---

# 3. gold.fact_sales

## Purpose

Stores sales transactions linked to customer and product dimensions.

Each record represents one sales order line.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_number | VARCHAR | Sales order identifier. |
| product_key | INT | Foreign key referencing dim_products. |
| customer_key | INT | Foreign key referencing dim_customers. |
| order_date | DATE | Order creation date. |
| shipping_date | DATE | Shipping date. |
| due_date | DATE | Expected delivery date. |
| sales_amount | NUMERIC | Total sales amount. |
| quantity | INT | Quantity sold. |
| price | NUMERIC | Unit selling price. |

---

# Star Schema

```

dim_customers
|
|
dim_products -------- fact_sales

```

---

# Notes

- Customer information is standardized in the Silver layer.
- Product dimension contains only active products.
- The fact table references surrogate keys from both dimensions.
- Gold tables are optimized for reporting and analytical queries.

# 🏪 Sales Data Mart — End-to-End Data Warehouse Project

> A complete Data Warehousing project built during the **DEPI Internship Program**, covering pipeline design, star schema modeling, ETL implementation, and dimensional data loading using Python and SQL Server.

---

## Project Overview

This project implements a **Sales Data Mart** based on a transactional OLTP system (`Sales_OLTP`). The goal is to transform raw operational data into an analytics-ready **Star Schema** data warehouse (`Sales_DWH`) that enables efficient reporting and business intelligence.

**Source System (Sales_OLTP)** contains:
- Categories & SubCategories
- Products
- Customers (with gender info)
- Salesmen & Addresses
- Orders & Order Details

**Target System (Sales_DWH)** is a Star Schema with:
- `DimCustomer` — customer demographics
- `DimProduct` — product hierarchy
- `DimSalesMan` — salesperson details
- `Dim_Date` — date dimension (2023–2030)
- `FactOrders` — sales transactions (measures: Quantity, TotalPrice)

---

## Tech Stack

| Tool | Purpose |
|---|---|
| **SQL Server Express** | Source OLTP & Target DWH |
| **Python 3** | ETL scripting |
| **pandas** | Data extraction & transformation |
| **pyodbc** | Database connectivity |
| **Jupyter Notebook** | ETL development & documentation |
| **Excel** | Source-to-target mapping sheet |

---

## Project Steps

### Step 1 — Pipeline Design

The ETL pipeline follows a classic **Extract → Transform → Load** architecture:

```
 ┌─────────────────┐     Extract      ┌───────────────────┐     Load     ┌──────────────────┐
 │   Sales_OLTP    │ ───────────────► │    DWH / OLAP     │ ───────────► │   Sales_DWH      │
 │  (SQL Server)   │                  │       ETL         │              │  (SQL Server)    │
 └─────────────────┘                  └───────────────────┘              └──────────────────┘
```

**Extract:** SQL views (`prod_view`, `salesman_view`, `order_view`) are used to pre-join and flatten the OLTP tables before pulling data into Python DataFrames.

**Transform:** Data cleaning steps applied per entity:
- Customers: full name concatenation, phone number dash removal, null checks
- Products: multi-level join (SubCategory → Category)
- SalesMan: address join for city field
- FactOrders: `OrderDate` converted from datetime to integer key (`YYYYMMDD`), Quantity cast to `float64`

**Load:** Row-by-row insert into each DWH dimension/fact table via `pyodbc` cursor execution.

> ![Pipeline Design](images/design_pipeline.JPG)

---

### Step 2 — DWH Schema Design

The data warehouse follows a **Star Schema** with one central fact table surrounded by four dimension tables.



> ![DWH Schema](images/design_schema.JPG)

---

### Step 3 — Data Mapping

The mapping document (`Maping.xlsx`) defines the full **source-to-target column lineage** for each dimension and the fact table.


> 📎 Full mapping file: [`Maping.xlsx`](Maping.xlsx)

---

### Step 4 — DDL Implementation

The DWH schema was implemented using SQL Server DDL statements. Key design decisions:

- `FactOrders` uses a **surrogate key** (`FactOrderSK IDENTITY`) since `OrderID` can repeat across order lines
- `Order_Date` in FactOrders is an `INT` foreign key referencing `Dim_Date.Date_SK` (format: `YYYYMMDD`)
- `Dim_Date` is pre-populated from **2023 to 2030** using a stored procedure `sp_PopulateDateDimension`
- All dimension tables use the natural business key as the primary key

**Files:**
- [`sales_dwh_query.sql`](sales_dwh_query.sql) — Full DDL for all tables + stored procedure
- [`etl_queries.sql`](etl_queries.sql) — OLTP source views used in extraction


> ![Database Diagram](images/Diagram.jpg)

> ![DimCustomer Table](images/DimCustomer.jpg)
> ![DimProduct Table](images/DimProduct.jpg)
> ![DimSalesMan Table](images/DimSalesMan.jpg)
> ![Dim_Date Table](images/Dim_Date.jpg)
> ![FactOrders Table](images/factorders.jpg)

---

### Step 5 — ETL Using Python

The ETL process is implemented in a **Jupyter Notebook** (`etl_dwh.ipynb`) with three clearly separated stages:

#### Extract
#### Transform
#### Load


> 📓 Full notebook: [`etl_dwh.ipynb`](etl_dwh.ipynb)

---

## Repository Structure

## Repository Structure
 
```
Sales-Data-Mart/
│
├── README.md                  # This file
├── etl_dwh.ipynb              # ETL pipeline (Extract, Transform, Load)
├── sales_dwh_query.sql        # DWH DDL — tables, stored procedure, date dimension
├── etl_queries.sql            # OLTP source views for extraction
├── Maping.xlsx                # Source-to-target mapping sheet
│
└── images/                    # Screenshots (add yours here)
    ├── pipeline_design.png
    ├── dwh_schema.png
    ├── db_diagram.png
    ├── dim_customer.png
    ├── dim_product.png
    ├── dim_salesman.png
    ├── dim_date.png
    └── fact_orders.png
```

---

## How to Run

**Prerequisites:**
- SQL Server Express with ODBC Driver 17
- Python 3.x
- Jupyter Notebook
- `pip install pyodbc pandas`

**Steps:**

1. **Restore OLTP database** — Restore `Sales_OLTP.back` into SQL Server
2. **Create DWH** — Run `sales_dwh_query.sql` to create `Sales_DWH` with all tables and the date dimension
3. **Create source views** — Run `etl_queries.sql` on `Sales_OLTP` to create the extraction views
4. **Run ETL** — Open and execute `etl_dwh.ipynb` in Jupyter Notebook

---

## Author

**ESAB**
DEPI Internship Program — Data Engineering Track
📅 April 2026

---

> ⭐ If you found this project useful, feel free to star the repository!

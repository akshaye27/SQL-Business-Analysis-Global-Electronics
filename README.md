# Global Electronics Retailer SQL Analysis

## Project Overview

This project analyzes sales data from a global electronics retailer using MySQL.

The objective is to answer business questions related to sales performance, customer behaviour, product performance, and store performance. The project starts with data quality checks and gradually moves to advanced SQL analysis using Common Table Expressions (CTEs) and Window Functions.

A total of 28 business questions have been solved in this project.

---

## Business Problem

A global electronics retailer wants to better understand its sales performance and customer behaviour. Using SQL, this project answers important business questions that help identify sales trends, top-performing products, customer segments, and overall business performance.

---

## Dataset

The project uses the following tables:

- Customers
- Products
- Sales
- Stores
- Exchange Rates

The Sales table acts as the central fact table and is connected to the other tables through primary and foreign keys.

---
## Database Schema

The following Entity Relationship (ER) diagram shows the relationships between the tables used in this project.

![ER Diagram](Images/ER_Diagram.png)

## Business Questions Answered

The project answers 28 business questions, including:

- Finding the sales date range
- Checking duplicate products
- Identifying missing and invalid records
- Total customers by country
- Top countries by revenue
- Top products by revenue
- Best performing brands
- Best performing stores
- Online vs physical store revenue
- Monthly revenue trend
- Annual revenue trend
- Weekday vs weekend revenue
- Average order value
- Repeat vs one-time customers
- Customer segmentation
- Products that have never been sold
- Revenue contribution by category
- Customers purchasing from multiple categories
- Customer segmentation using CTEs
- Top-selling product in each category
- Ranking products using Window Functions
- Top 3 products in each category
- Running revenue over time
- Month-over-month revenue change
- Year-over-year revenue growth
- Customer retention analysis
- Executive business report

---

## SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- CASE
- Aggregate Functions
- INNER JOIN
- LEFT JOIN
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- Running Totals
- Year-over-Year Analysis

---

## Tools Used

- MySQL
- MySQL Workbench

---

## Files Included

- SQL_Project.sql
- Customers.csv
- Products.csv
- Sales.csv
- Stores.csv
- Exchange_Rates.csv
- Data_Dictionary.csv

---

## Key Learnings

This project helped me improve my understanding of:

- SQL for business analysis
- Data cleaning and validation
- Customer and sales analysis
- Revenue analysis
- Window Functions
- Common Table Expressions (CTEs)
- Writing SQL queries to solve real business problems

---

## Author

Akshaye Nair

Business Intelligence | Data Analytics

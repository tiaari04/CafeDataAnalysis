# Café Sales Analysis - SQL & Power BI Project

## Overview
End-to-end data analysis project using a café transaction dataset. The project covers data staging, cleaning, standardization, and exploratory analysis in PostgreSQL, with findings visualized in an interactive Power BI dashboard.

## Key Insights

* **Coffee leads in quantity but not revenue**: It ranked 1st in 5 out of 12 months yet generates some of the lowest revenue per unit. Salad consistently outearned it despite similar sales volumes
* **Salad is the café's most valuable product**: It appeared in the monthly top 3 for 7 out of 12 months and generated the highest in-store revenue of any item at $6,110
* **The overall 50/50 in-store vs takeaway split masks item-level differences**: Salad and Juice were bought more often in-store, while Coffee, Cake and Cookie were more popular as takeaway, suggesting customer purchasing behaviour varies by product
* **Cookie underperforms despite its popularity**: It was frequently in the top 3 in quantity but generated as little as $290 in a single month, making it the least valuable top-performing item
* **Revenue is stable year-round**: Monthly totals ranged only from $6,633 to $7,350, accumulating to $84,786.50 by year end, suggesting demand isn't seasonal

## Process

### Staging
* Created a staging table to preserve the raw data before making any changes, ensuring the original dataset remained intact throughout the cleaning process

### Data Cleaning
* Checked for duplicate records using ROW_NUMBER() partitioned by transaction_id
* Removed header rows incorrectly inserted as data
* Validated transaction_id formatting against the expected TXN_ pattern
* Converted all UNKNOWN and ERROR string values to NULL across every column

### Standardization
* Converted column data types from text to their correct types - transaction_date to date, quantity to smallint, price_per_unit and total_spent to real
* Recalculated missing total_spent values using quantity * price_per_unit when both were available
* Recalculated missing quantity and price_per_unit values using the same logic in reverse
* Inferred NULL item names using average price per unit per item (e.g. records with a price of $1.00 were identified as Cookie, $2.00 as Coffee)

### Exploratory Data Analysis
* Most purchased and highest earning product overall
* Monthly item rankings by quantity sold
* Top 3 items per month by quantity and revenue
* In-store vs takeaway revenue overall and broken down by item
* Monthly revenue totals and rolling cumulative revenue

## Dashboard
<img width="1135" height="638" alt="Screenshot 2026-02-22 172602" src="https://github.com/user-attachments/assets/1390e43a-6acf-4e4f-b323-6f86f5d1a205" />
An interactive Power BI dashboard featuring:

* Quantity vs revenue comparison by item
* Total revenue by item treemap
* In-store vs takeaway revenue by item
* Monthly revenue and cumulative revenue line charts
* Slicers for item and purchase location

## Tools & Technologies
* PostgreSQL - Staging, cleaning, standardization, and exploratory analysis
* Power BI - Interactive dashboard and visualizations

## Data Source
Raw dataset sourced from Kaggle

## Limitations
* NULL records that could not be resolved were excluded from analysis, which may introduce a small bias

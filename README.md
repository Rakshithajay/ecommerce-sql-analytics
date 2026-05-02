# E-Commerce SQL Analytics — Olist Dataset

## Project Overview
End-to-end SQL analysis of 100,000+ real Brazilian e-commerce orders
across 9 tables using advanced SQL techniques.

## Tools Used
- SQL (SQLite) — DB Browser for SQLite
- Dataset: Brazilian E-Commerce Public Dataset by Olist (Kaggle)

## Key Findings
- 99,441 orders across Sep 2016 – Oct 2018
- November 2017 = peak revenue month at R$1,153,528 (Black Friday)
- São Paulo = 15,540 customers — 15% of all buyers
- 91.9% of orders delivered early — Olist over-promises delivery dates
- AL state = worst late delivery rate at 23.9%
- health_beauty = #1 revenue category at R$1,258,681
- office_furniture = lowest rated category at 3.49 stars
- 29,218 customers classified as Lost in RFM analysis
- Champions (11,886 customers) spend avg R$271 — 2x the Lost segment
- Top seller generated R$225,586 revenue across 1,116 orders

## SQL Modules
| File | Analysis |
|------|----------|
| 01_exploration.sql | NULL audit, date range, order status breakdown |
| 02_revenue.sql | Monthly trends, MoM growth with LAG() window function |
| 03_customers.sql | One-time vs repeat buyers, NTILE spend quartiles |
| 04_products.sql | Category revenue, best and worst review scores |
| 05_delivery.sql | Late delivery rate by state, avg delivery days |
| 06_cohort.sql | Monthly cohort retention analysis |
| 07_rfm.sql | RFM scoring with NTILE — Champion/Loyal/At Risk/Lost |
| 08_sellers.sql | Seller leaderboard with RANK() window function |

## SQL Techniques Demonstrated
- CTEs (Common Table Expressions)
- Window Functions: RANK(), DENSE_RANK(), NTILE(), LAG()
- Multi-table JOINs (up to 4 tables)
- Subqueries (scalar, correlated, derived tables)
- CASE WHEN segmentation
- HAVING for group-level filtering
- Date functions: STRFTIME(), JULIANDAY()
- COALESCE() for NULL handling
- Aggregate functions: SUM, AVG, COUNT, MIN, MAX

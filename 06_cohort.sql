-- MODULE 6: COHORT RETENTION ANALYSIS
-- E-Commerce SQL Analytics | Olist Dataset

-- 6.1 Monthly cohort retention
-- Step 1: Find each customer's first order month (cohort)
-- Step 2: Track all their subsequent order months
-- Step 3: Count active customers per cohort per month

WITH first_orders AS (
  SELECT
    c.customer_unique_id,
    MIN(STRFTIME('%Y-%m', o.order_purchase_timestamp)) AS cohort_month
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
),
customer_activity AS (
  SELECT
    f.customer_unique_id,
    f.cohort_month,
    STRFTIME('%Y-%m', o.order_purchase_timestamp) AS order_month
  FROM first_orders f
  JOIN customers c ON f.customer_unique_id = c.customer_unique_id
  JOIN orders o    ON c.customer_id        = o.customer_id
  WHERE o.order_status = 'delivered'
)
SELECT
  cohort_month,
  order_month,
  COUNT(DISTINCT customer_unique_id) AS active_customers
FROM customer_activity
GROUP BY cohort_month, order_month
ORDER BY cohort_month, order_month;

-- 6.2 Cohort size — how many customers acquired each month
WITH first_orders AS (
  SELECT
    c.customer_unique_id,
    MIN(STRFTIME('%Y-%m', o.order_purchase_timestamp)) AS cohort_month
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
)
SELECT
  cohort_month,
  COUNT(*) AS cohort_size
FROM first_orders
GROUP BY cohort_month
ORDER BY cohort_month;

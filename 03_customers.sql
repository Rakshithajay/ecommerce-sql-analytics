-- MODULE 3: CUSTOMER SEGMENTATION
-- E-Commerce SQL Analytics | Olist Dataset

-- 3.1 One-time vs repeat customers
WITH customer_orders AS (
  SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS order_count
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_unique_id
)
SELECT
  CASE WHEN order_count = 1 THEN 'One-time' ELSE 'Repeat' END AS segment,
  COUNT(*)                                                      AS customers,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_orders), 2) AS percentage
FROM customer_orders
GROUP BY 1;

-- 3.2 Top 10 customers by total spend
SELECT
  c.customer_unique_id,
  COUNT(o.order_id)              AS total_orders,
  ROUND(SUM(p.payment_value), 2) AS total_spent
FROM customers c
JOIN orders o          ON c.customer_id  = o.customer_id
JOIN order_payments p  ON o.order_id     = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

-- 3.3 Customer spend distribution using NTILE quartiles
WITH customer_spend AS (
  SELECT
    c.customer_unique_id,
    ROUND(SUM(p.payment_value), 2) AS total_spent
  FROM customers c
  JOIN orders o         ON c.customer_id = o.customer_id
  JOIN order_payments p ON o.order_id    = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
),
ranked AS (
  SELECT
    customer_unique_id,
    total_spent,
    NTILE(4) OVER (ORDER BY total_spent) AS spend_quartile
  FROM customer_spend
)
SELECT
  spend_quartile,
  COUNT(*)                       AS customers,
  ROUND(MIN(total_spent), 2)     AS min_spend,
  ROUND(MAX(total_spent), 2)     AS max_spend,
  ROUND(AVG(total_spent), 2)     AS avg_spend
FROM ranked
GROUP BY spend_quartile
ORDER BY spend_quartile;

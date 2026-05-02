-- MODULE 7: RFM CUSTOMER SEGMENTATION
-- E-Commerce SQL Analytics | Olist Dataset
-- RFM = Recency, Frequency, Monetary
-- Each dimension scored 1-4 using NTILE()
-- Higher score = better customer

-- 7.1 RFM scoring and customer segmentation
WITH rfm_base AS (
  SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp)  AS last_order_date,
    COUNT(o.order_id)                AS frequency,
    ROUND(SUM(p.payment_value), 2)   AS monetary
  FROM customers c
  JOIN orders o         ON c.customer_id = o.customer_id
  JOIN order_payments p ON o.order_id    = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
),
rfm_scored AS (
  SELECT *,
    NTILE(4) OVER (ORDER BY last_order_date DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency ASC)        AS f_score,
    NTILE(4) OVER (ORDER BY monetary ASC)         AS m_score
  FROM rfm_base
)
SELECT
  CASE
    WHEN r_score = 1 AND f_score >= 3 THEN 'Champion'
    WHEN r_score <= 2 AND f_score >= 2 THEN 'Loyal'
    WHEN r_score = 1                   THEN 'Potential'
    WHEN r_score = 3                   THEN 'At Risk'
    ELSE                                    'Lost'
  END                              AS segment,
  COUNT(*)                         AS customers,
  ROUND(AVG(monetary), 2)          AS avg_spend,
  ROUND(AVG(frequency), 2)         AS avg_orders
FROM rfm_scored
GROUP BY segment
ORDER BY customers DESC;

-- 7.2 Full RFM detail per customer (top 20 Champions)
WITH rfm_base AS (
  SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp)  AS last_order_date,
    COUNT(o.order_id)                AS frequency,
    ROUND(SUM(p.payment_value), 2)   AS monetary
  FROM customers c
  JOIN orders o         ON c.customer_id = o.customer_id
  JOIN order_payments p ON o.order_id    = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
),
rfm_scored AS (
  SELECT *,
    NTILE(4) OVER (ORDER BY last_order_date DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency ASC)        AS f_score,
    NTILE(4) OVER (ORDER BY monetary ASC)         AS m_score
  FROM rfm_base
)
SELECT
  customer_unique_id,
  last_order_date,
  frequency,
  monetary,
  r_score, f_score, m_score,
  CASE
    WHEN r_score = 1 AND f_score >= 3 THEN 'Champion'
    WHEN r_score <= 2 AND f_score >= 2 THEN 'Loyal'
    WHEN r_score = 1                   THEN 'Potential'
    WHEN r_score = 3                   THEN 'At Risk'
    ELSE                                    'Lost'
  END AS segment
FROM rfm_scored
WHERE r_score = 1 AND f_score >= 3
ORDER BY monetary DESC
LIMIT 20;

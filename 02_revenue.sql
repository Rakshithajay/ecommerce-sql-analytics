-- MODULE 2: REVENUE ANALYSIS
-- E-Commerce SQL Analytics | Olist Dataset

-- 2.1 Monthly revenue trend
SELECT
  STRFTIME('%Y-%m', order_purchase_timestamp) AS month,
  COUNT(DISTINCT o.order_id)                  AS total_orders,
  ROUND(SUM(p.payment_value), 2)              AS total_revenue
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

-- 2.2 Month-over-month growth using LAG() window function
WITH monthly AS (
  SELECT
    STRFTIME('%Y-%m', order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value), 2)              AS revenue
  FROM orders o
  JOIN order_payments p ON o.order_id = p.order_id
  WHERE order_status = 'delivered'
  GROUP BY 1
)
SELECT
  month,
  revenue,
  LAG(revenue) OVER (ORDER BY month)                                             AS prev_month_revenue,
  ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0
    / LAG(revenue) OVER (ORDER BY month), 1)                                     AS growth_pct
FROM monthly
ORDER BY month;

-- 2.3 Best and worst revenue months ranked
WITH monthly AS (
  SELECT
    STRFTIME('%Y-%m', order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value), 2)              AS revenue
  FROM orders o
  JOIN order_payments p ON o.order_id = p.order_id
  WHERE order_status = 'delivered'
  GROUP BY 1
)
SELECT
  month,
  revenue,
  RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM monthly
ORDER BY revenue DESC;

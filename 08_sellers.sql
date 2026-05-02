-- ============================================
-- MODULE 8: SELLER LEADERBOARD
-- E-Commerce SQL Analytics | Olist Dataset
-- ============================================

-- 8.1 Top 20 sellers ranked by revenue, rating and delivery speed
WITH seller_stats AS (
  SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id)                                         AS total_orders,
    ROUND(SUM(oi.price), 2)                                             AS total_revenue,
    ROUND(AVG(r.review_score), 2)                                       AS avg_rating,
    ROUND(AVG(JULIANDAY(o.order_delivered_customer_date) -
              JULIANDAY(o.order_purchase_timestamp)), 1)                 AS avg_delivery_days
  FROM order_items oi
  JOIN orders o        ON oi.order_id = o.order_id
  JOIN order_reviews r ON oi.order_id = r.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
  GROUP BY oi.seller_id
  HAVING total_orders >= 10
)
SELECT *,
  RANK() OVER (ORDER BY total_revenue   DESC) AS revenue_rank,
  RANK() OVER (ORDER BY avg_rating      DESC) AS rating_rank,
  RANK() OVER (ORDER BY avg_delivery_days)    AS speed_rank
FROM seller_stats
ORDER BY revenue_rank
LIMIT 20;

-- 8.2 Sellers with best rating (min 50 orders)
WITH seller_stats AS (
  SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id)   AS total_orders,
    ROUND(SUM(oi.price), 2)       AS total_revenue,
    ROUND(AVG(r.review_score), 2) AS avg_rating
  FROM order_items oi
  JOIN orders o        ON oi.order_id = o.order_id
  JOIN order_reviews r ON oi.order_id = r.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY oi.seller_id
  HAVING total_orders >= 50
)
SELECT *,
  RANK() OVER (ORDER BY avg_rating DESC) AS rating_rank
FROM seller_stats
ORDER BY avg_rating DESC
LIMIT 10;

-- 8.3 Seller state distribution
SELECT
  s.seller_state,
  COUNT(DISTINCT s.seller_id)    AS total_sellers,
  COUNT(DISTINCT oi.order_id)    AS total_orders,
  ROUND(SUM(oi.price), 2)        AS total_revenue
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY total_revenue DESC;

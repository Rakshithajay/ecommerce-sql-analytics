-- MODULE 4: PRODUCT PERFORMANCE
-- E-Commerce SQL Analytics | Olist Dataset

-- 4.1 Top 10 categories by revenue
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS category,
  COUNT(DISTINCT oi.order_id)            AS total_orders,
  ROUND(SUM(oi.price), 2)               AS total_revenue,
  ROUND(AVG(oi.price), 2)               AS avg_price
FROM order_items oi
JOIN products p              ON oi.product_id          = p.product_id
LEFT JOIN category_translation t ON p.product_category_name = t.product_category_name
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 10;

-- 4.2 Best rated categories (min 100 reviews)
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS category,
  COUNT(r.review_id)                     AS total_reviews,
  ROUND(AVG(r.review_score), 2)          AS avg_rating,
  SUM(CASE WHEN r.review_score >= 4 THEN 1 ELSE 0 END) AS positive_reviews,
  SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END) AS negative_reviews
FROM order_items oi
JOIN products p              ON oi.product_id          = p.product_id
LEFT JOIN category_translation t ON p.product_category_name = t.product_category_name
JOIN order_reviews r         ON oi.order_id            = r.order_id
GROUP BY 1
HAVING total_reviews > 100
ORDER BY avg_rating DESC
LIMIT 10;

-- 4.3 Worst rated categories (min 100 reviews)
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS category,
  ROUND(AVG(r.review_score), 2)          AS avg_rating,
  COUNT(r.review_id)                     AS total_reviews
FROM order_items oi
JOIN products p              ON oi.product_id          = p.product_id
LEFT JOIN category_translation t ON p.product_category_name = t.product_category_name
JOIN order_reviews r         ON oi.order_id            = r.order_id
GROUP BY 1
HAVING total_reviews > 100
ORDER BY avg_rating ASC
LIMIT 5;

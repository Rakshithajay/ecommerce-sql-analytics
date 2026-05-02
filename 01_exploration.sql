-- MODULE 1: DATA EXPLORATION
-- E-Commerce SQL Analytics | Olist Dataset

-- 1.1 Date range of the dataset
SELECT
  MIN(order_purchase_timestamp) AS first_order,
  MAX(order_purchase_timestamp) AS last_order
FROM orders;

-- 1.2 Row count across all tables
SELECT 'orders'               AS table_name, COUNT(*) AS rows FROM orders
UNION ALL
SELECT 'customers',                           COUNT(*) FROM customers
UNION ALL
SELECT 'order_items',                         COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments',                      COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews',                       COUNT(*) FROM order_reviews
UNION ALL
SELECT 'products',                            COUNT(*) FROM products
UNION ALL
SELECT 'sellers',                             COUNT(*) FROM sellers
UNION ALL
SELECT 'geolocation',                         COUNT(*) FROM geolocation
UNION ALL
SELECT 'category_translation',                COUNT(*) FROM category_translation;

-- 1.3 Order status breakdown
SELECT
  order_status,
  COUNT(*) AS count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY count DESC;

-- 1.4 NULL audit on orders table
SELECT
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)                        AS null_order_id,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)                     AS null_customer_id,
  SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END)                    AS null_status,
  SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END)        AS null_purchase_date,
  SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END)   AS null_delivery_date
FROM orders;

-- 1.5 Top 10 cities by number of customers
SELECT
  customer_city,
  customer_state,
  COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city, customer_state
ORDER BY total_customers DESC
LIMIT 10;

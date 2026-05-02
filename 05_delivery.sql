-- MODULE 5: DELIVERY PERFORMANCE
-- E-Commerce SQL Analytics | Olist Dataset

-- 5.1 Late delivery rate by state
SELECT
  c.customer_state,
  COUNT(*)                                                                        AS total_orders,
  SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
      THEN 1 ELSE 0 END)                                                          AS late_orders,
  ROUND(100.0 * SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
      THEN 1 ELSE 0 END) / COUNT(*), 1)                                           AS late_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY late_pct DESC;

-- 5.2 Average delivery days by state (fastest vs slowest)
SELECT
  c.customer_state,
  COUNT(*)                                                                        AS total_orders,
  ROUND(AVG(JULIANDAY(o.order_delivered_customer_date) -
            JULIANDAY(o.order_purchase_timestamp)), 1)                            AS avg_delivery_days,
  ROUND(MIN(JULIANDAY(o.order_delivered_customer_date) -
            JULIANDAY(o.order_purchase_timestamp)), 1)                            AS fastest_days,
  ROUND(MAX(JULIANDAY(o.order_delivered_customer_date) -
            JULIANDAY(o.order_purchase_timestamp)), 1)                            AS slowest_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;

-- 5.3 Overall delivery status summary (Early / Late)
SELECT
  CASE
    WHEN order_delivered_customer_date < order_estimated_delivery_date THEN 'Early'
    WHEN order_delivered_customer_date = order_estimated_delivery_date THEN 'On-time'
    WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late'
  END                                                                             AS delivery_status,
  COUNT(*)                                                                        AS total_orders,
  ROUND(COUNT(*) * 100.0 / (
    SELECT COUNT(*) FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
  ), 1)                                                                           AS percentage
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
GROUP BY 1
ORDER BY total_orders DESC;

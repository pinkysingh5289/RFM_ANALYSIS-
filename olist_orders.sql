SELECT COUNT(*) FROM olist_orders;

SELECT order_purchase_timestamp FROM olist_orders LIMIT 5;
SELECT COUNT(*) FROM olist_orders WHERE order_purchase_timestamp IS NULL;

SELECT MIN(order_purchase_timestamp) AS earliest_order,
       MAX(order_purchase_timestamp) AS latest_order
FROM olist_orders;

SELECT order_status, COUNT(*) AS order_count
FROM olist_orders
GROUP BY order_status
ORDER BY order_count DESC;
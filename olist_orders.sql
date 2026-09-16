SELECT COUNT(*) FROM olist_orders;

SELECT order_purchase_timestamp FROM olist_orders LIMIT 5;
SELECT COUNT(*) FROM olist_orders WHERE order_purchase_timestamp IS NULL;
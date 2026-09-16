
SELECT order_purchase_timestamp FROM olist_orders LIMIT 5;
SELECT COUNT(*) FROM olist_orders WHERE order_purchase_timestamp IS NULL;

SELECT MIN(order_purchase_timestamp) AS earliest_order,
       MAX(order_purchase_timestamp) AS latest_order
FROM olist_orders;

SELECT order_status, COUNT(*) AS order_count
FROM olist_orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS null_customer_unique_id
FROM olist_customers;

SELECT
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_purchase_date
FROM olist_orders;

SELECT
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS null_payment_value
FROM olist_order_payments;
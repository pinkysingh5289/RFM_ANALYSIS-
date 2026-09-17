
use rfm_analysis;

-- find distinct customer id and customer unique id 
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT customer_id) AS distinct_customer_id,
       COUNT(DISTINCT customer_unique_id) AS distinct_unique_id
FROM olist_customers;

-- find distinct order id and order item id 
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT order_id) AS distinct_order_id
FROM olist_order_items;

-- finding latest purchase date to use it as today 
SELECT MIN(order_purchase_timestamp) AS earliest_order,
       MAX(order_purchase_timestamp) AS latest_order
FROM olist_orders;

-- Count of order with Order Status
SELECT order_status, COUNT(*) AS order_count
FROM olist_orders
GROUP BY order_status
ORDER BY order_count DESC;

-- Finding how many null value is available 
SELECT
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS null_customer_unique_id
FROM olist_customers;

SELECT
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_purchase_date
FROM olist_orders;

SELECT
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS null_payment_value
FROM olist_order_payments;

-- Finding how many values are distinct 
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT order_id) AS distinct_order_ids
FROM olist_orders;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT review_id) AS distinct_review_ids
FROM staging_reviews;


-- count of customer having repeat-purchase
SELECT order_count, COUNT(*) AS num_customers
FROM (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS order_count
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
) t
GROUP BY order_count
ORDER BY order_count;

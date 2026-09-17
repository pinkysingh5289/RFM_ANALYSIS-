
-- Find each customer's first purchase month (cohort month)
SELECT c.customer_unique_id,
       MIN(DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01')) AS cohort_month
FROM olist_orders_clean o
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id;	

WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS order_month,
        MIN(DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01')) 
            OVER (PARTITION BY c.customer_unique_id) AS cohort_month
    FROM olist_orders_clean o
    JOIN olist_customers c ON o.customer_id = c.customer_id
)
SELECT * FROM customer_orders
LIMIT 20;
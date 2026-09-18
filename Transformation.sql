
-- Find each customer's first purchase month (cohort month)
SELECT c.customer_unique_id,
       MIN(DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01')) AS cohort_month
FROM olist_orders_clean o
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id;	


-- Verify with a repeat customer specifically
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


-- Calculate months since joining
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
SELECT 
    customer_unique_id,
    order_id,
    cohort_month,
    order_month,
    TIMESTAMPDIFF(MONTH, cohort_month, order_month) AS months_since_joining
FROM customer_orders
ORDER BY months_since_joining desc;


-- Build the actual cohort retention table
WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS order_month,
        MIN(DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01')) 
            OVER (PARTITION BY c.customer_unique_id) AS cohort_month
    FROM olist_orders_clean o
    JOIN olist_customers c ON o.customer_id = c.customer_id
),
cohort_data AS (
    SELECT 
        cohort_month,
        TIMESTAMPDIFF(MONTH, cohort_month, order_month) AS months_since_joining,
        customer_unique_id
    FROM customer_orders
)
SELECT 
    cohort_month,
    months_since_joining,
    COUNT(DISTINCT customer_unique_id) AS active_customers
FROM cohort_data
GROUP BY cohort_month, months_since_joining
ORDER BY cohort_month, months_since_joining asc;


-- Convert to retention percentages
WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS order_month,
        MIN(DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01')) 
            OVER (PARTITION BY c.customer_unique_id) AS cohort_month
    FROM olist_orders_clean o
    JOIN olist_customers c ON o.customer_id = c.customer_id
),
cohort_data AS (
    SELECT 
        cohort_month,
        TIMESTAMPDIFF(MONTH, cohort_month, order_month) AS months_since_joining,
        customer_unique_id
    FROM customer_orders
),
cohort_counts AS (
    SELECT 
        cohort_month,
        months_since_joining,
        COUNT(DISTINCT customer_unique_id) AS active_customers
    FROM cohort_data
    GROUP BY cohort_month, months_since_joining
),
cohort_sizes AS (
    SELECT cohort_month, active_customers AS cohort_size
    FROM cohort_counts
    WHERE months_since_joining = 0
)
SELECT 
    cc.cohort_month,
    cc.months_since_joining,
    cc.active_customers,
    cs.cohort_size,
    ROUND(cc.active_customers * 100.0 / cs.cohort_size, 2) AS retention_pct
FROM cohort_counts cc
JOIN cohort_sizes cs ON cc.cohort_month = cs.cohort_month
ORDER BY cc.cohort_month, cc.months_since_joining;
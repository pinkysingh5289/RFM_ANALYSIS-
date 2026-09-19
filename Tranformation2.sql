
-- RFM Analysis — Recency
SELECT 
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp) AS last_order_date,
    DATEDIFF(
        (SELECT MAX(order_purchase_timestamp) FROM olist_orders_clean), 
        MAX(o.order_purchase_timestamp)
    ) AS recency_days
FROM olist_orders_clean o
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY recency_days desc
LIMIT 100;


-- RFM — Frequency
SELECT 
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS frequency
FROM olist_orders_clean o
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY frequency DESC
LIMIT 20;

-- RFM — Monetary
SELECT 
    c.customer_unique_id,
    SUM(p.payment_value) AS monetary
FROM olist_orders_clean o
JOIN olist_customers c ON o.customer_id = c.customer_id
JOIN olist_order_payments p ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY monetary DESC
LIMIT 20;


-- Combine Recency, Frequency, and Monetary into one table
WITH recency_cte AS (
    SELECT 
        c.customer_unique_id,
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM olist_orders_clean), 
            MAX(o.order_purchase_timestamp)
        ) AS recency_days
    FROM olist_orders_clean o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
frequency_cte AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS frequency
    FROM olist_orders_clean o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
monetary_cte AS (
    SELECT 
        c.customer_unique_id,
        SUM(p.payment_value) AS monetary
    FROM olist_orders_clean o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    JOIN olist_order_payments p ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
)
SELECT 
    r.customer_unique_id,
    r.recency_days,
    f.frequency,
    m.monetary
FROM recency_cte r
JOIN frequency_cte f ON r.customer_unique_id = f.customer_unique_id
JOIN monetary_cte m ON r.customer_unique_id = m.customer_unique_id
ORDER BY m.monetary DESC
LIMIT 20;


-- Score each metric 1–5 using NTILE
WITH recency_cte AS (
    SELECT 
        c.customer_unique_id,
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM olist_orders_clean), 
            MAX(o.order_purchase_timestamp)
        ) AS recency_days
    FROM olist_orders_clean o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
frequency_cte AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS frequency
    FROM olist_orders_clean o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
monetary_cte AS (
    SELECT 
        c.customer_unique_id,
        SUM(p.payment_value) AS monetary
    FROM olist_orders_clean o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    JOIN olist_order_payments p ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
),
rfm_base AS (
    SELECT 
        r.customer_unique_id,
        r.recency_days,
        f.frequency,
        m.monetary
    FROM recency_cte r
    JOIN frequency_cte f ON r.customer_unique_id = f.customer_unique_id
    JOIN monetary_cte m ON r.customer_unique_id = m.customer_unique_id
)
SELECT 
    customer_unique_id,
    recency_days,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
FROM rfm_base
ORDER BY monetary DESC
LIMIT 20;
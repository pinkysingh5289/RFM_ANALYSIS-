
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
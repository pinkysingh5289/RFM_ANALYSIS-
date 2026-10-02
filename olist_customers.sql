select count(*) from olist_customers;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT customer_id) AS distinct_customer_id,
       COUNT(DISTINCT customer_unique_id) AS distinct_unique_id
FROM olist_customers;
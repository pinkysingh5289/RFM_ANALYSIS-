
use rfm_analysis;

create table  olist_orders_clean  as 
select *
from olist_orders
where order_status = 'delivered' ;

select count(*) from olist_orders_clean;

-- Check for invalid payment values
SELECT COUNT(*) AS invalid_payments
FROM olist_order_payments
WHERE payment_value <= 0;

-- Inspect the invalid payment rows
SELECT *
FROM olist_order_payments
WHERE payment_value <= 0;

-- Check payment_type for the zero-value rows
SELECT order_id, payment_type, payment_value
FROM olist_order_payments
WHERE payment_value = 0;



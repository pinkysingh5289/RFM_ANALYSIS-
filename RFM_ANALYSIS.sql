use RFM_analysis;

SHOW TABLES;

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/olist/olist_customers_dataset.csv'
INTO TABLE olist_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from olist_customers;

-- ==========================================
-- TABLE: PRODUCT CATEGORY TRANSLATION
-- ==========================================

CREATE TABLE olist_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/olist/product_category_name_translation.csv'
INTO TABLE olist_category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM olist_category_translation;
SELECT * FROM olist_category_translation LIMIT 10;

-- ==========================================
-- TABLE: SELLERS
-- ==========================================

CREATE TABLE olist_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/olist/olist_sellers_dataset.csv'
INTO TABLE olist_sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM olist_sellers;
SELECT * FROM olist_sellers LIMIT 10;

-- ==========================================
-- TABLE: PRODUCTS
-- ==========================================

CREATE TABLE olist_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/olist/olist_products_dataset.csv'
INTO TABLE olist_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify
SELECT COUNT(*) FROM olist_products;
SELECT * FROM olist_products LIMIT 10;

-- ==========================================
-- TABLE: ORDERS
-- ==========================================


CREATE TABLE staging_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp VARCHAR(30),
    order_approved_at VARCHAR(30),
    order_delivered_carrier_date VARCHAR(30),
    order_delivered_customer_date VARCHAR(30),
    order_estimated_delivery_date VARCHAR(30)
);

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/olist/olist_orders_dataset.csv'
INTO TABLE staging_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify staging load worked
SELECT COUNT(*) FROM staging_orders;

-- ==========================================
-- TABLE: ORDER REVIEWS
-- ==========================================
CREATE TABLE staging_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date VARCHAR(30),
    review_answer_timestamp VARCHAR(30)
);

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/olist/olist_order_reviews_dataset.csv'
INTO TABLE staging_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify staging load
SELECT COUNT(*) FROM staging_reviews;


-- ==========================================
-- TABLE: ORDER PAYMENTS
-- ==========================================

CREATE TABLE olist_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/olist/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify
SELECT COUNT(*) FROM olist_order_payments;
SELECT * FROM olist_order_payments LIMIT 10;

-- ==========================================
-- TABLE: ORDER ITEMS
-- ==========================================


CREATE TABLE staging_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date VARCHAR(30),
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/olist/olist_order_items_dataset.csv'
INTO TABLE staging_order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify staging load
SELECT COUNT(*) FROM staging_order_items;


-- ==========================================
-- TABLE: GEOLOCATION (optional — large file)
-- ==========================================

CREATE TABLE olist_geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(5)
);

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/olist/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) FROM olist_geolocation;
SELECT * FROM olist_geolocation LIMIT 10;
CREATE DATABASE olist_ecommerce;

USE olist_ecommerce;

CREATE TABLE customers (
	customer_id VARCHAR (50) PRIMARY KEY,
    customer_unique_id VARCHAR (50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR (100),
    customer_state VARCHAR (10)
);

CREATE TABLE sellers (
	seller_id VARCHAR (50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR (100),
    seller_state VARCHAR (10)
);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

CREATE TABLE category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    FOREIGN KEY (product_category_name)
        REFERENCES category_translation(product_category_name)
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
	);
    
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY(order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY(order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

SELECT * FROM category_translation;
SELECT * FROM products;
SELECT * FROM order_reviews;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE order_reviews;
SET FOREIGN_KEY_CHECKS = 1;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/avnee/OneDrive/Desktop/sql/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id,
 customer_unique_id,
 customer_zip_code_prefix,
 customer_city,
 customer_state);
 
LOAD DATA LOCAL INFILE 'C:/Users/avnee/OneDrive/Desktop/sql/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(seller_id,
 seller_zip_code_prefix,
 seller_city,
 seller_state); 
 
LOAD DATA LOCAL INFILE 'C:/Users/avnee/OneDrive/Desktop/sql/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id,
 order_item_id,
 product_id,
 seller_id,
 shipping_limit_date,
 price,
 freight_value);
 
 LOAD DATA LOCAL INFILE 'C:/Users/avnee/OneDrive/Desktop/sql/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id,
 payment_sequential,
 payment_type,
 payment_installments,
 payment_value);
 
 
 LOAD DATA LOCAL INFILE 'C:/Users/avnee/OneDrive/Desktop/sql/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(geolocation_zip_code_prefix,
 geolocation_lat,
 geolocation_lng,
 geolocation_city,
 geolocation_state);

LOAD DATA LOCAL INFILE 'C:/Users/avnee/OneDrive/Desktop/sql/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id,
 customer_id,
 order_status,
 @order_purchase_timestamp,
 @order_approved_at,
 @order_delivered_carrier_date,
 @order_delivered_customer_date,
 @order_estimated_delivery_date)
SET
order_purchase_timestamp = NULLIF(@order_purchase_timestamp,''),
order_approved_at = NULLIF(@order_approved_at,''),
order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date,''),
order_delivered_customer_date = NULLIF(@order_delivered_customer_date,''),
order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date,'');

LOAD DATA LOCAL INFILE 'C:/Users/avnee/OneDrive/Desktop/sql/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id,
 order_id,
 review_score,
 @review_comment_title,
 @review_comment_message,
 @review_creation_date,
 @review_answer_timestamp)
SET
review_comment_title = NULLIF(@review_comment_title,''),
review_comment_message = NULLIF(@review_comment_message,''),
review_creation_date = NULLIF(@review_creation_date,''),
review_answer_timestamp = NULLIF(@review_answer_timestamp,'');

SELECT COUNT(*) FROM order_reviews;
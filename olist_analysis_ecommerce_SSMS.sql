USE olist_web_ecommerce;

-- Data Collection -- 

-- Joining tables, selecting necessary columns and creating temporary tables for querying 

SELECT 
olist_orders_dataset.order_id,
olist_orders_dataset.customer_id,
olist_orders_dataset.order_status,
olist_orders_dataset.order_purchase_timestamp,
olist_orders_dataset.order_delivered_customer_date,
olist_customers_dataset.customer_unique_id,
olist_customers_dataset.customer_zip_code_prefix,
olist_customers_dataset.customer_city,
olist_customers_dataset.customer_state
INTO #customer_order
FROM olist_customers_dataset 
INNER JOIN olist_orders_dataset 
ON olist_customers_dataset.customer_id = olist_orders_dataset.customer_id;


SELECT 
olist_order_items_dataset.order_id,
olist_order_items_dataset.order_item_id,
olist_order_items_dataset.product_id,
olist_order_items_dataset.seller_id,
olist_order_items_dataset.price,
olist_order_items_dataset.freight_value,
#customer_order.customer_id,
#customer_order.order_status,
#customer_order.order_purchase_timestamp,
#customer_order.order_delivered_customer_date,
#customer_order.customer_unique_id,
#customer_order.customer_zip_code_prefix,
#customer_order.customer_city,
#customer_order.customer_state
INTO #customer_order_items
FROM olist_order_items_dataset
LEFT JOIN #customer_order 
ON olist_order_items_dataset.order_id = #customer_order.order_id;


SELECT 
#customer_order_items.order_id,
#customer_order_items.order_item_id,
#customer_order_items.product_id,
#customer_order_items.seller_id,
#customer_order_items.price,
#customer_order_items.freight_value,
#customer_order_items.customer_id,
#customer_order_items.order_status,
#customer_order_items.order_purchase_timestamp,
#customer_order_items.order_delivered_customer_date,
#customer_order_items.customer_unique_id,
#customer_order_items.customer_zip_code_prefix,
#customer_order_items.customer_city,
#customer_order_items.customer_state, 
olist_order_payments_dataset.payment_type,
olist_order_payments_dataset.payment_installments,
olist_order_payments_dataset.payment_value
INTO #customer_order_payments
FROM #customer_order_items
LEFT JOIN olist_order_payments_dataset 
ON #customer_order_items.order_id = olist_order_payments_dataset.order_id;


SELECT 
#customer_order_payments.order_id,
#customer_order_payments.order_item_id,
#customer_order_payments.product_id,
#customer_order_payments.seller_id,
#customer_order_payments.price,
#customer_order_payments.freight_value,
#customer_order_payments.customer_id,
#customer_order_payments.order_status,
#customer_order_payments.order_purchase_timestamp,
#customer_order_payments.order_delivered_customer_date,
#customer_order_payments.customer_unique_id,
#customer_order_payments.customer_zip_code_prefix,
#customer_order_payments.customer_city,
#customer_order_payments.customer_state, 
#customer_order_payments.payment_type,
#customer_order_payments.payment_installments,
#customer_order_payments.payment_value,
olist_order_reviews_dataset.review_score
INTO #customer_order_reviews
FROM #customer_order_payments
LEFT JOIN olist_order_reviews_dataset 
ON #customer_order_payments.order_id = olist_order_reviews_dataset.order_id;


SELECT 
#customer_order_reviews.order_id,
#customer_order_reviews.order_item_id,
#customer_order_reviews.product_id,
#customer_order_reviews.seller_id,
#customer_order_reviews.price,
#customer_order_reviews.freight_value,
#customer_order_reviews.customer_id,
#customer_order_reviews.order_status,
#customer_order_reviews.order_purchase_timestamp,
#customer_order_reviews.order_delivered_customer_date,
#customer_order_reviews.customer_unique_id,
#customer_order_reviews.customer_zip_code_prefix,
#customer_order_reviews.customer_city,
#customer_order_reviews.customer_state, 
#customer_order_reviews.payment_type,
#customer_order_reviews.payment_installments,
#customer_order_reviews.payment_value,
#customer_order_reviews.review_score,
olist_products_dataset.product_category_name
INTO #customer_order_products
FROM #customer_order_reviews
LEFT JOIN olist_products_dataset
ON #customer_order_reviews.product_id = olist_products_dataset.product_id;


SELECT 
#customer_order_products.order_id,
#customer_order_products.order_item_id,
#customer_order_products.product_id,
#customer_order_products.seller_id,
#customer_order_products.price,
#customer_order_products.freight_value,
#customer_order_products.customer_id,
#customer_order_products.order_status,
#customer_order_products.order_purchase_timestamp,
#customer_order_products.order_delivered_customer_date,
#customer_order_products.customer_unique_id,
#customer_order_products.customer_zip_code_prefix,
#customer_order_products.customer_city,
#customer_order_products.customer_state, 
#customer_order_products.payment_type,
#customer_order_products.payment_installments,
#customer_order_products.payment_value,
#customer_order_products.product_category_name,
#customer_order_products.review_score,
olist_sellers_dataset.seller_zip_code_prefix,
olist_sellers_dataset.seller_city,
olist_sellers_dataset.seller_state
INTO #complete_data
FROM #customer_order_products
LEFT JOIN olist_sellers_dataset
ON #customer_order_products.seller_id = olist_sellers_dataset.seller_id;


-- Data Cleaning --

-- Remove duplicate rows by using SELECT DISTINCT syntax 

SELECT DISTINCT *
INTO #clean_data
FROM #complete_data

-- Checking if missing values on each column exists -- 

SELECT *
FROM #clean_data
WHERE order_purchase_timestamp IS NULL -- No missing values

SELECT *
FROM #clean_data
WHERE order_delivered_customer_date IS NULL -- Has missing values
 
DELETE FROM #clean_data
WHERE order_delivered_customer_date IS NULL -- removing rows with null values, I removed the 2533 rows with date null values because its hard to analyze data without date values.
SELECT *
FROM #clean_data
WHERE order_id IS NULL -- No missing values

SELECT *
FROM #clean_data
WHERE order_item_id IS NULL -- No missing values

SELECT *
FROM #clean_data
WHERE product_id IS NULL -- No missing values

SELECT *
FROM #clean_data
WHERE seller_id IS NULL -- No missing values

SELECT *
FROM #clean_data
WHERE customer_id IS NULL -- No missing values

SELECT *
FROM #clean_data
WHERE customer_unique_id IS NULL -- No missing values

SELECT *
FROM #clean_data
WHERE product_category_name IS NULL -- Has missing values

UPDATE #clean_data SET product_category_name = 'others' WHERE product_category_name IS NULL  -- Replace  missing values on product category name column by 'others'

SELECT *
FROM #clean_data
WHERE price IS NULL -- No missing values

SELECT *
FROM #clean_data
WHERE freight_value IS NULL -- No missing values

SELECT *
FROM #clean_data
WHERE payment_value IS NULL -- Has missing values

UPDATE #clean_data SET payment_value = 108.6 WHERE payment_value IS NULL  -- replace null values by the median value of the payment_value column, choosing median over mean because of the presence of extreme outliers. Computed the median value using pandas in python.


SELECT *
FROM #clean_data
WHERE review_score IS NULL -- Has missing values

UPDATE #clean_data SET review_score = 5.0 WHERE review_score IS NULL -- replace null values by the median value of the review_score column. Compute the median value using pandas in python.

SELECT *
FROM #clean_data
WHERE payment_type IS NULL

UPDATE #clean_data SET payment_type = 'others' WHERE payment_type IS NULL -- replace null values by 'others' of the payment type column

SELECT * FROM #clean_data

-- EXPLORATORY DATA ANALYSIS -- 

-- Day of Week Trend Analysis 
set datefirst 1; -- setting the first day of the week. 1 means sunday

SELECT 
DATEPART(weekday,order_purchase_timestamp) AS dayofweek, 
COUNT(DISTINCT order_id) count_of_orders 
FROM #clean_data
GROUP BY DATEPART(weekday, order_purchase_timestamp)  -- this is the equivalent of grouping by two columns by using dt.dayofweek()


-- Monthly Trend Analysis 

SELECT 
YEAR(order_purchase_timestamp) AS yr, 
MONTH(order_purchase_timestamp) AS  mo,
COUNT(DISTINCT order_id) AS count_of_orders
FROM #clean_data
GROUP BY YEAR(order_purchase_timestamp),  -- this is the equivalent of grouping by two columns by using resample
MONTH(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp) ASC,
MONTH(order_purchase_timestamp) ASC

-- Product Categories With the most sales

SELECT 
product_category_name,
COUNT(DISTINCT order_id) AS count_of_orders
FROM #clean_data
GROUP BY product_category_name
ORDER BY COUNT(DISTINCT order_id) DESC

-- Product Categories with the least sales

SELECT 
product_category_name,
COUNT(DISTINCT order_id) AS count_of_orders
FROM #clean_data
GROUP BY product_category_name
ORDER BY COUNT(DISTINCT order_id) ASC

-- States of Brazil with the most Sales

SELECT 
customer_city,
COUNT(DISTINCT order_id) AS count_of_orders
FROM #clean_data
GROUP BY customer_city
ORDER BY COUNT(DISTINCT order_id) DESC


-- Average Delivery Time Analysis 

SELECT 
product_category_name, 
AVG(DATEDIFF(Day, order_purchase_timestamp, order_delivered_customer_date)) AS days_of_delivery
FROM #clean_data
GROUP BY product_category_name
ORDER BY AVG(DATEDIFF(Day, order_purchase_timestamp, order_delivered_customer_date)) DESC

-- Payment Method Used by the Customers 

SELECT 
payment_type,
COUNT(DISTINCT order_id) AS count_of_orders
FROM #clean_data
GROUP BY payment_type
ORDER BY COUNT(DISTINCT order_id) DESC

-- Customer Life Time Value Based on Product Category
SELECT 
product_category_name,
COUNT(DISTINCT order_id) * AVG(payment_value) * 2 AS Customer_LifeTime_Value
FROM #clean_data
GROUP BY product_category_name
ORDER BY COUNT(DISTINCT order_id) * AVG(payment_value) * 2 DESC

-- Customer Satisfaction based on Review Scores

SELECT 
product_category_name,
AVG(review_score) as review_scores
FROM #clean_data
GROUP BY product_category_name
ORDER BY AVG(review_score) ASC   --Review Scores Ascending (Low Customer Satisfaction)

SELECT 
product_category_name,
AVG(review_score) as review_scores
FROM #clean_data
GROUP BY product_category_name
ORDER BY AVG(review_score) DESC   --Review Scores Descending (High Customer Satisfaction)

USE olist_web_ecommerce;

SELECT DISTINCT 
zip_code_prefix,
MIN(lat) AS lat,
MIN(city) AS city,
MIN(country_state) AS country_sate,
MIN(long) AS long
INTO geo_location
FROM olist_geolocation_dataset
GROUP BY zip_code_prefix 
ORDER BY zip_code_prefix ASC


SELECT DISTINCT
customer_id,
city, 
country_sate,
lat, 
long
INTO #geo_customers
FROM geo_location
INNER JOIN olist_customers_dataset 
ON geo_location.zip_code_prefix = olist_customers_dataset.customer_zip_code_prefix


SELECT DISTINCT 
order_id,
olist_orders_dataset.customer_id,
city, 
country_sate,
lat, 
long,
order_purchase_timestamp,
order_delivered_customer_date,
order_status
INTO #customer_location
FROM olist_orders_dataset 
LEFT JOIN #geo_customers
ON olist_orders_dataset.customer_id = #geo_customers.customer_id


SELECT 
#customer_location.order_id,
product_id, 
seller_id,
customer_id,
city,
country_sate, 
lat, 
long,
order_purchase_timestamp,
order_delivered_customer_date,
order_status,
(price + freight_value) AS total_sales
INTO #customer_sales_location
FROM #customer_location
LEFT JOIN olist_order_items_dataset
ON #customer_location.order_id = olist_order_items_dataset.order_id


SELECT 
#customer_sales_location.order_id,
product_id, 
seller_id,
customer_id,
city,
country_sate, 
lat, 
long,
order_purchase_timestamp,
order_delivered_customer_date,
order_status,
review_score,
total_sales
INTO #customer_sales_location_review
FROM #customer_sales_location
LEFT JOIN olist_order_reviews_dataset
ON #customer_sales_location.order_id = olist_order_reviews_dataset.order_id 


SELECT 
#customer_sales_location_review.order_id,
#customer_sales_location_review.product_id, 
seller_id,
customer_id,
city,
country_sate, 
lat, 
long,
order_purchase_timestamp,
order_delivered_customer_date,
product_category_name,
product_weight_g,
order_status,
review_score,
total_sales
INTO #customer_sales_location_review_products
FROM #customer_sales_location_review
LEFT JOIN olist_products_dataset
ON #customer_sales_location_review.product_id = olist_products_dataset.product_id


SELECT 
#customer_sales_location_review_products.order_id,
#customer_sales_location_review_products.product_id, 
seller_id,
customer_id,
city,
country_sate, 
lat, 
long,
order_purchase_timestamp,
order_delivered_customer_date,
product_category_name,
product_weight_g,
order_status,
review_score,
total_sales,
payment_type,
payment_value
INTO olist_data -- Final Data
FROM #customer_sales_location_review_products
LEFT JOIN olist_order_payments_dataset
ON #customer_sales_location_review_products.order_id = olist_order_payments_dataset.order_id




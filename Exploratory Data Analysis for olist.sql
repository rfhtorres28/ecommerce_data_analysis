USE olist_web_ecommerce


-- Total Orders and Sales by Week -- 
SET datefirst 1;

SELECT
DATEPART(WEEKDAY, order_purchase_timestamp) as day_of_week,
COUNT(order_id) as orders,
AVG(payment_value) as revenue
INTO daily_orders_sales
FROM cleaned_data
WHERE order_status = 'delivered'
GROUP BY DATEPART(WEEKDAY, order_purchase_timestamp)


-- Total Orders and Sales by Month -- 

SET datefirst 1;

SELECT
MONTH(order_purchase_timestamp) as monthly,
COUNT(order_id) as orders,
AVG(payment_value) as revenue
INTO monthly_orders_sales
FROM cleaned_data
WHERE order_status = 'delivered'
GROUP BY MONTH(order_purchase_timestamp)



-- Total Orders and Sales by Month (2016-2018) -- 
SET datefirst 1;

SELECT
YEAR(order_purchase_timestamp) as yr,
MONTH(order_purchase_timestamp) as mo,
COUNT(order_id) as orders,
AVG(payment_value) as revenue
INTO monthly_orders_sales
FROM cleaned_data
WHERE order_status = 'delivered'
GROUP BY YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp)



-- Number of Orders by Product Category 
SELECT 
product_category_name,
COUNT(order_id) as count_of_orders
INTO no_of_orders_product_category
FROM cleaned_data
GROUP BY product_category_name
ORDER BY COUNT(DISTINCT order_id) DESC


-- Preferred Payment Method -- 
SELECT 
payment_type,
COUNT(order_id) as orders_count
INTO payment_method
FROM cleaned_data
GROUP BY payment_type
ORDER BY COUNT(DISTINCT order_id) DESC



-- Shippment Status Report --
SELECT 
order_status,
COUNT(order_id) as orders_count
INTO shippment_status
FROM cleaned_data
GROUP BY order_status
ORDER BY COUNT(DISTINCT order_id) DESC


-- Average Time of Delivery --
SELECT 
product_category_name,
AVG(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS delivery_time
INTO average_deliver_time
FROM cleaned_data
GROUP BY product_category_name
ORDER BY AVG(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) DESC



-- Customer Review Scores --
SELECT 
product_category_name,
ROUND(AVG(CAST(review_score as FLOAT)), 2) as review_score  -- change the data type to float first then get the average to increase the accuracy
INTO customer_review_scores
FROM cleaned_data
GROUP BY product_category_name
ORDER BY AVG(review_score) DESC

-- orders by citystate 
SELECT 
country_state,
COUNT(order_id) as count_of_orders
INTO orders_by_state
FROM cleaned_data
GROUP BY country_state
ORDER BY COUNT(DISTINCT order_id) DESC

-- number of sellers by citystate 
SELECT
country_state,
COUNT(seller_id) as count_of_sellers
FROM cleaned_data
GROUP BY country_state
ORDER BY COUNT(seller_id) DESC


-- Customer Lifetime Value 
SELECT 
product_category_name,
COUNT(order_id) * AVG(payment_value) * 2 as customer_lifetime_value
INTO customer_lifetime_value_product
FROM cleaned_data
GROUP BY product_category_name


-- Total Sales Revenue
SELECT 
SUM(payment_value) as Revenue
INTO total_revenue
FROM cleaned_data

-- Total Orders
SELECT 
COUNT(order_id) as orders
INTO total_orders
FROM cleaned_data

-- Customer Satisfaction Rate
SELECT 
CAST(COUNT(CASE WHEN review_score IN (4,5) THEN order_id ELSE NULL END) as FLOAT) / 
COUNT(order_id) as customer_satisfaction_rate
INTO customer_satisfaction_rate
FROM cleaned_data






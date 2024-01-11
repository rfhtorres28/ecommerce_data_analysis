# E-Commerce Sales Analysis

### Project Overview
Hello there! This project is all about the analysis of Brazilian Olist Web Ecommerce Performance that happens during 2016-2018. I performed the analysis using Microsoft SQL Server Management Studio and Python for Data Quality Assessment and Exploratory Data Analysis. For Data Visualization, I used Power BI and Python's Matplotlib and Seaborn Libraries.  


### Data Sources 
The CSV files were downloaded from kaggle website. I create a database on SQL Server and created tables for each file. 

### Tools 
* SQL Server - Data Wrangling / Exploratory Data Analysis
* Python - Data Cleaning / Exploratory Data Analysis
* Power BI - Data Visualization
* Excel - Data Visualization

### First Phase 
 In the initial phase of data preparation, the following tasks were performed: 

 1. Using SQL Server to join multiple tables into one complete table of data.
 2. Transfer the complete data to Python for data cleaning.
 3. Remove duplicate rows, change the format of column names, detecting outliers and handling missing values.
 4. Send the cleaned data to SQL Server for Exploratory Data Analysis

### Second Phase
 EDA involves exploring the sales data to answer some of the following questions:

 1. What is the number of product orders on weekdays compare during weekends?
 2. What month has the most orders and sales?
 3. Which product category has the most orders and sales?
 4. Which country state has the most number of customers?
 5. Which product category has the least customer review score rating?
 6. What is the overall customer satisfaction rate?
 7. Which payment method most preferred to use by the customers? 

### SQL Implementation 

Total Sales and Orders by Day of Week
```
SET datefirst 1;

SELECT
DATEPART(WEEKDAY, order_purchase_timestamp) as day_of_week,
COUNT(order_id) as orders,
AVG(payment_value) as revenue
INTO daily_orders_sales
FROM cleaned_data
WHERE order_status = 'delivered'
GROUP BY DATEPART(WEEKDAY, order_purchase_timestamp)
```

 Total Orders and Sales by Month 
```
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
```


Number of Orders by Product Category 
```
SELECT 
product_category_name,
COUNT(order_id) as count_of_orders
INTO no_of_orders_product_category
FROM cleaned_data
GROUP BY product_category_name
ORDER BY COUNT(DISTINCT order_id) DESC
```

Preferred Payment Method 
```
SELECT 
payment_type,
COUNT(order_id) as orders_count
INTO payment_method
FROM cleaned_data
GROUP BY payment_type
ORDER BY COUNT(DISTINCT order_id) DESC
```

Shippment Status Report 
```
SELECT 
order_status,
COUNT(order_id) as orders_count
INTO shippment_status
FROM cleaned_data
GROUP BY order_status
ORDER BY COUNT(DISTINCT order_id) DESC
```

 Average Time of Delivery
```
SELECT 
product_category_name,
AVG(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS delivery_time
INTO average_deliver_time
FROM cleaned_data
GROUP BY product_category_name
ORDER BY AVG(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) DESC
```


Customer Review Scores
```
SELECT 
product_category_name,
ROUND(AVG(CAST(review_score as FLOAT)), 2) as review_score  -- change the data type to float first then get the average to increase the accuracy
INTO customer_review_scores
FROM cleaned_data
GROUP BY product_category_name
ORDER BY AVG(review_score) DESC
```

Orders by State 
```
SELECT 
country_state,
COUNT(order_id) as count_of_orders
INTO orders_by_state
FROM cleaned_data
GROUP BY country_state
ORDER BY COUNT(DISTINCT order_id) DESC
```

Customer Lifetime Value 
```
SELECT 
product_category_name,
COUNT(order_id) * AVG(payment_value) * 2 as customer_lifetime_value
INTO customer_lifetime_value_product
FROM cleaned_data
GROUP BY product_category_name
```

Total Sales Revenue
```
SELECT 
SUM(payment_value) as Revenue
INTO total_revenue
FROM cleaned_data
```

Total Orders
```
SELECT 
COUNT(order_id) as orders
INTO total_orders
FROM cleaned_data
```

Customer Satisfaction Rate
```
SELECT 
CAST(COUNT(CASE WHEN review_score IN (4,5) THEN order_id ELSE NULL END) as FLOAT) / 
COUNT(order_id) as customer_satisfaction_rate
INTO customer_satisfaction_rate
FROM cleaned_data
```


### Insights and Recommendation

1. From the Day of Week Trend graph, it can be observed that the number of orders declines during weekdays and increases during 
weekends. I think most people during weekends have no work and has more time shopping online. Olist marketing team should focus more on
making effective campaign strategy during weekdays to increase its order sales. 

3. For Monthly Sales Trend in 2016-2018, the number of orders vs time  increases as time goes by. It peaks around
November-December of 2017 and goes down at January of 2018 but increases again as month goes by. It shows that 
Olist marketing strategy peforms well during this time period. 

4. Products in the Bed, Table, Bath category has the most number of orders. It also has the highest
consumer life time value. This means that most costumers in the data buys this product category. Olist should continue
the service and marketing strategy they are currently implementing to this product category to maintain these good metric values.

5. Insurance services has the least number of orders and received the lowest review score. Maybe the high average delivery time
was the reason for this low metric value. Olist should focus more on delivering this service to the costumer fast as possible to attain a 
high customer satisfaction. 

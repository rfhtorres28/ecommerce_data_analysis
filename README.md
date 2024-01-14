# OLIST E-Commerce Performance Sales Analysis

## Authors
* [rfhtorres28](https://github.com/rfhtorres28)
  
## Project Overview
Hello there! This project is all about the analysis of Brazilian Olist Web Ecommerce Performance that happens during 2016-2018. I performed the analysis using Microsoft SQL Server Management Studio and Python for Data Quality Assessment and Exploratory Data Analysis. I first used SQL Server to join tables from the CSV files since it is much easier to use SQL for Data Wrangling specifically combining data tables.Then I used python for data cleaning since it has more statistical tools that can help me detect and assess outliers for numeric data columns. It has also boxplot graphs for easy visualization of outliers. For Data Visualization, I used Power BI and Python's Matplotlib and Seaborn Libraries. I also used python
for Exploratory Data Analysis just to show that EDA is also possible in python. 

## Data Source
* The CSV files were downloaded from kaggle website. I created a database on SQL Server and make tables for each file. 

## Tools 
* SQL Server - Data Wrangling / Exploratory Data Analysis
* Python - Data Cleaning / Exploratory Data Analysis
* Power BI / Matplotlib and Seaborn Libraries - Data Visualization

  
# Methods

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

### Last Phase
  For each questions, I used group-by with aggregation method and created a table for it. Each resulting table was transferred to Power Bi for Data Visualization. 

## Python Data Cleaning Process 
Notebook file code for Data Cleaning is uploaded in the repository section. 

Steps: 

1. Load the CSV file using pd.read_csv()
2. Remove unecessary characters on column title and capitalize each word.
3. Repeat step 2 for each category columns.
4. Select necessary columns for analysis.
5. Drop duplicate rows.
6. Detect outliers by graphing each numeric column using boxplot.
7. If the graph is skewed distribution and has potential outliers, use inter quartile rule for removing outliers.
8. If the graph is symmetric distribution, use standard deviation rule for removing outliers.
9. If the outliers are valid values for each column, just retain them.
10. If the count of outliers are almost 10% of the total values on that column, retain them. Removing the outliers or replacing them can affect the accuracy of the result since 10% is significant.
11. Detect null values and replace them with zero or median value.
12. If the numeric column has null values with extreme outliers, use the median value as a replacement for null values instead of mean value since it can be affected due to presence of extreme outliers.
13. For categorical column, if the number of null values is significant, I replace them with 'Others' category for categorical columns.
14. Inspect each columns if they have correct data types.
15. Transfer the cleaned dataframe to SQL Server for Exploratory Data Analysis.



### SQL EDA Implementation 

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

## Overview of the Results 

#### Using Power BI 

![olist_ecommerce_insight_final-1](https://github.com/rfhtorres28/ecommerce_data_analysis/assets/153373159/dc4eb53d-b6e9-47a1-b2b8-1f75e0bffe4c)
![olist_ecommerce_insight_final-2](https://github.com/rfhtorres28/ecommerce_data_analysis/assets/153373159/df5d99a3-f91a-4a96-bf0a-3311fbf5b726)
![olist_ecommerce_insight_final-3](https://github.com/rfhtorres28/ecommerce_data_analysis/assets/153373159/116428a7-d136-4b29-bb1f-7e569b0d07d2)

#### Using Matplotlib and Seaborn
* See the jupyter notebook file for the visualization results. 


### Insights and Recommendation

1. From the time series graph, it can be observed that the number of orders declines during weekdays and increases during 
weekends from the dayweek graph. I think most people during weekends have no work and has more time shopping online. For month, september and october
has the least count of orders. Olist marketing team should focus more on making effective campaign strategy during these periods to increase its order sales. 

  
2. Products in the Bed, Table, Bath category has the most number of orders. It also has the highest
consumer life time value. This means that most costumers in the data buys this product category. Olist should continue
the service and marketing strategy they are currently implementing to this product category to maintain these good metric values.

3. Insurance services has the least number of orders and received the lowest review score. Maybe the high average delivery time
was the reason for this low metric value. Olist should focus more on delivering this service to the costumer fast as possible to attain a 
high customer satisfaction.

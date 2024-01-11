# E-Commerce Sales Analysis

### Project Overview
Hello there! This project is all about the analysis of Brazilian Olist Web Ecommerce Performance that happens during 2016-2018. I performed the analysis using Microsoft SQL Server Management Studio and Python for Data Quality Assessment and Exploratory Data Analysis. For Data Visualization, I used Power BI and Python's Matplotlib and Seaborn Libraries.  


### Data Sources 
The CSV files are downloaded from kaggle website. I create a database on SQL Server and created tables for each file. 

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
























 

Insights drawn from the analysis:

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

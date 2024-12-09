# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL. The SQL Project is made using MS SQL Server.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sale_db` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
create database sql_project_p1;

use sql_project_p1

Create Table retail_sale_db (
	transactions_id	int primary key,
	sale_date	date,
	sale_time	time,
	customer_id	int,
	gender	varchar(15),
	age	int,
	category varchar(15),	
	quantiy	int,
	price_per_unit float,	
	cogs	float,
	total_sale float
)
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **Renaming the Column**: Renaming the Column name from 'Quantiy' to 'Quantity'.
```sql
select count(*) FROM retail_sale_db;
select count(distinct customer_id) from retail_sale_db;
select distinct category from retail_sale_db;

select * from retail_sale_db 
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or 
	category is null
	or 
	quantiy is null
	or
	cogs is null
	or 
	total_sale is null
	or 
	age is null

delete from retail_sale_db
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or 
	category is null
	or 
	quantiy is null
	or
	cogs is null
	or 
	total_sale is null
	or
	age is null

EXEC sp_rename 'retail_sale_db.quantiy', 'Quantity', 'COLUMN'
```


### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select * from retail_sale_db
where sale_date = '2022-11-02'
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is >= 4 in the month of Nov-2022**:
```sql
select *
from retail_sale_db
where category = 'Clothing'
  and format(sale_date, 'yyyy-MM') = '2022-11'
  and quantity >= 4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category, 
sum(total_sale) [Sale by Category],
count(*) [Total Order Count]
from retail_sale_db
group by category
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select 
round(avg(age), 2) as avg_age
from retail_sale_db
where category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail_sale_db
where total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select category, gender, count(*) [Total Transactions Made]
from retail_sale_db
group by gender, category
order by category
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
select year, month, round([average Sale], 2) as [average sale] from
(
select
	YEAR(sale_date) as year,
	MONTH(sale_date) as month,
	avg(total_sale) as [average Sale],
	rank() over(partition by YEAR(sale_date) order by avg(total_sale) desc) as ranks
from retail_sale_db
group by 
YEAR(sale_date), 
MONTH(sale_date)) as t1
where ranks = 1
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select top 5
customer_id, sum(total_sale) as [Total Sales]
from retail_sale_db
group by customer_id
order by sum(total_sale) desc
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select  
category,
COUNT(distinct customer_id) as [Category Wise Customer Count]
from retail_sale_db
group by category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
with hourly_sales as
(
select *,
case 
	when DATEPART(hour, sale_time) < 12 then 'Morning'
	when DATEPART(hour, sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as shift
from retail_sale_db)

select 
shift,
count(*) as Total_Orders
from hourly_sales
group by shift
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating high ticket purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Anik Das

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/anik-das171/)

Thank you for your support, and I look forward to connecting with you!

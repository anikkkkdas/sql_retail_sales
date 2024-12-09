-- SQL Retail Sales Analysis -- P1
create database sql_project_p1
use sql_project_p1

-- Creating the Tables

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

-- Finding out the Null Values

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


-- Data Cleaning (Deleating Null Values)

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

-- Renaming the Column name from 'Quantiy' to 'Quantity'

EXEC sp_rename 'retail_sale_db.quantiy', 'Quantity', 'COLUMN';


-- Data Exploration

-- How many Sales we have ?

select count(total_sale) as Total_Sales_count
from retail_sale_db

-- How many unique customers we have ?

select count(distinct customer_id) as [Total Unique Customers]
from retail_sale_db

-- How Many Categories we Have ?

select distinct category
from retail_sale_db

-- Data Analysis and Business Key Problems



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sale_db
where sale_date = '2022-11-02'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is >=4 in the month of Nov-2022

SELECT *
FROM retail_sale_db
WHERE category = 'Clothing'
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
  AND quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, 
sum(total_sale) [Sale by Category],
count(*) [Total Order Count]
from retail_sale_db
group by category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
round(avg(age), 2) as avg_age
from retail_sale_db
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sale_db
where total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(*) [Total Transactions Made]
from retail_sale_db
group by gender, category
order by category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

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

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select top 5
customer_id, sum(total_sale) as [Total Sales]
from retail_sale_db
group by customer_id
order by sum(total_sale) desc

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select  
category,
COUNT(distinct customer_id) as [Category Wise Customer Count]
from retail_sale_db
group by category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

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


------------------------------------------------------------------------ END ---------------------------------------------------------------------------

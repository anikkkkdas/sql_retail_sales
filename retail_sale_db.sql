-- =======================================================================================================================
--											SQL Retail Sales Analysis Project
-- =======================================================================================================================
-- ====================================================================
--							Data Cleaning
-- ====================================================================
use RetailAnalyticsProject
select 
	*
from SalesDB
where
	age is null or 
	category is null or 
	cogs is null or 
	customer_id is null or 
	gender is null or 
	price_per_unit is null or 
	quantiy is null or 
	sale_date is null or 
	sale_time is null or 
	total_sale is null or
	transactions_id  is null

-- ====================================================================
--		Updating Null values in Age Column with Avg Age per Gender
-- ====================================================================
UPDATE SalesDB
SET age = sub.avg_age
FROM SalesDB s
JOIN (
    SELECT gender, AVG(age * 1.0) AS avg_age
    FROM SalesDB
    WHERE age IS NOT NULL
    GROUP BY gender
) sub
    ON s.gender = sub.gender
WHERE s.age IS NULL

-- ====================================================================
--		Deleting Rows with Null values in Measures Columns
-- ====================================================================
DELETE from SalesDB
where
	age is null or 
	category is null or 
	cogs is null or 
	customer_id is null or 
	gender is null or 
	price_per_unit is null or 
	quantiy is null or 
	sale_date is null or 
	sale_time is null or 
	total_sale is null or
	transactions_id  is null

-- ====================================================================
--							Checking Duplicate Entries
-- ====================================================================
SELECT 
	transactions_id, 
	COUNT(*) AS count_trnc
FROM SalesDB
GROUP BY transactions_id
HAVING COUNT(*) > 1

-- ====================================================================
--							Data Exploration
-- ====================================================================
-- How many sales we have?
SELECT 
	count(*) as TotalSales
FROM SalesDB
-- How many uniuque customers we have ?
SELECT
	COUNT(DISTINCT customer_id) as NoOfCustomers
FROM SalesDB

-- =========================================================================
--	Data Analysis & Business Key Problems & Answers [Analysis & Findings]
-- =========================================================================

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select
	*
from SalesDB
where sale_date = '2022-11-05'

/*
Q.2 Write a SQL query to retrieve all transactions where the category is 
'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
*/

select 
	*
from SalesDB
where 
		category = 'Clothing' 
	and quantiy > 3
	and MONTH(sale_date) = 11 
	and year(sale_date) = 2022

-- ====================
--		Alternatively
-- ====================

SELECT 
	*
FROM SalesDB
WHERE category = 'Clothing'
  AND quantiy > 3
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select
	category,
	sum(total_sale) as TotalSales
from SalesDB
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
	category,
	avg(age) as AvgCustomerAge
from SalesDB
where category = 'Beauty'
group by category

-- ====================
--		Alternatively
-- ====================

select
	category,
	avg(age) as AvgCustomerAge
from SalesDB
group by category
having category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select
	*
from SalesDB
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select
	gender,
	category,
	COUNT(transactions_id) as NoOfTransactions
from SalesDB
group by 
	gender,
	category
order by
	category,
	NoOfTransactions

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select
	Year,
	Month,
	AvgSales
from
(
select
	YEAR(Sale_date) as Year,
	month(sale_date) as Month,
	avg(total_sale) as AvgSales,
	ROW_NUMBER()OVER(PARTITION BY YEAR(Sale_date) ORDER BY avg(total_sale) desc) as AvgSalesRank
	from SalesDB
group by 
	YEAR(Sale_date),
	month(sale_date)
)x
where AvgSalesRank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select
	top 5
	customer_id,
	sum(total_sale) as TotalSales
from SalesDB
group by 
	customer_id
order by 
	sum(total_sale) desc

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select
	category,
	count(distinct customer_id) as UniqueCustomerCount
from SalesDB
group by 
	category
order by 
	UniqueCustomerCount desc

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select
	*,
	CASE 
		WHEN DATEPART(hour,sale_time) <= 12 THEN 'Morning'
		WHEN DATEPART(hour,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as ShiftTiming
from SalesDB

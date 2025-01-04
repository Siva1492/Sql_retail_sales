-- SQL Retail Sales Analysis 
Create database sql_project_p2;



--Create Table
DROP TABLE IF EXISTS retail_sales;
Create Table retail_sales
	        (
	            transctions_id INT PRIMARY KEY,
	            sale_date DATE,
	            sale_time TIME,
	            customer_id INT,
	            gender VARCHAR(15),
	            age INT,
	            category VARCHAR(15),
	            quantity int,
	            price_per_unit FLOAT,
	            cogs FLOAT,
	            total_sale FLOAT
	        );
Select * from retail_sales;


Select count(*) from retail_sales;

-- Data Cleaning
Select * from retail_sales
	where transactions_id is NULL;


Select * from retail_sales
	where sale_date is NULL;


Select * from retail_sales
	where sale_time is NULL;

Select * from retail_sales
	where
	transctions_id is NULL 
	or
    sale_date is NULL
    or
   sale_time is NULL
    or 
   gender is NULL
    or
   category is NULL
    or 
   quantity IS NULL
    or 
   cogs is null
    or 
  total_sale is null;

Delete from retail_sales
where 
    transctions_id is NULL 
	or
    sale_date is NULL
    or
    sale_time is NULL
    or 
    gender is NULL
    or
    category is NULL
    or 
    quantity IS NULL
    or 
    cogs is null
    or 
   total_sale is null;


-- Data Exploration
-- How many sales we have?
Select count(*) as total_sale from retail_sales;

-- How many unique customers we have ?
select count(distinct customer_id) as total_sale from retail_sales;

select distinct category from retail_sales;


--- Data Analysis & Business Key Problems & Answers

-- Write a SQL query to retrieve all columns date made on 22-11-05
select * from retail_sales where sale_date ='2022-11-05';


--Q.2 Write a sql query to retrieve all transactions where the category is 'Clothing' and the quantity sold is morethan 4 in the month of Nov-2022
Select *
from retail_sales
where 
	category = 'Clothing'
    AND 
    TO_CHAR(sale_date,'YYYY-MM')='2022-11'
    AND 
    quantity >=4;

--Q.3 Write a sql query to calculate the total sales(total_sale)for the category 
select category,
	sum(total_sale) as net_sale,
	COUNT(*) as total_orders
from retail_sales
GROUP By 1;

--Q.4 write a query to find the average age of customers who purchased items from the 'Beauty' category.
select 
	ROUND(AVG(age),2) as avg_age
	from retail_sales 
	where category ='Beauty';

-- Q.5 Write a sql query to find all transactions where the total_sale is greater than 1000.
Select * from retail_sales
	where total_sale > 1000;

-- Q.6 Write a sql query to find the total number of transactions (transactions_id) made by each gender in each category
Select  
	category,
    gender,
    count(*) as total_trans
From retail_sales
	group by category, gender
	order by 1;

-- Write a sql query to calculate the average sale for each month.Find out best selling month in each year 
select 
	year,
	month,
	avg_sale
	from
(
Select 
	Extract (YEAR From sale_date) as year,
	Extract (MONTH From sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) order by AVG(total_sale)DESC) as rank
  from retail_sales
	GROUP BY 1,2
	) as t1
	where rank=1;

-- Q.8 Write a sql query to find the top 5 Customers based on the highest total sales
Select 
	Customer_id,
Sum(total_sale) as total_sales 
	From retail_sales
	GROUP BY 1
	order by 2 desc
	limit 5;
	group by Customer_id;

-- Q.9 Write a sql query to find the number of unique customers who purchased items form each category
  Select 
        Category ,
     Count (Distinct customer_id) as Unique_Customers  
      from retail_sales
	  Group By category;
-- Q.10 Write a sql query each shift and number of orders(Example Morning<= 12,Afternoon Between 12 & 17 ,Evening >17)
WITH hourly_sale 
	AS 
	(
	Select *,
    CASE
        WHEN Extract(HOUR FROM sale_time)<12 THEN 'Morning'
        WHEN Extract(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'EVENING'
    END as shift
From retail_Sales
)
select
	shift,
	COUNT(*)as total_orders
FROM hourly_sale
GROUP BY shift;

-- End of the project.
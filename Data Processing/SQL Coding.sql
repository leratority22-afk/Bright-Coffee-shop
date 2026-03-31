---I want to see my table in the coding to start exploring each column
select * from `workspace`.`default`.`Bright_coffee_shop_sales` limit 10;

----------------------------------------------------------------------
-- 1. I want to check the Date Range 
----------------------------------------------------------------------
--They started collecting the data in 2023-01-01 
SELECT MIN(transaction_date) AS min_date 
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;

-- the duratuin of the data is 6 months 
-- they last collected the data 2023-06-30

SELECT MAX(transaction_date) AS latest_date
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;

-------------------------------------------------------------------
-- 2. Cheching the names of different stores
-------------------------------------------------------------------
--We have 3 stores and their names are Lower Manhattan, Hell's Kitchen, Astoria 
SELECT COUNT(DISTINCT store_location)  
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;

SELECT COUNT(DISTINCT store_id) AS number_of_stores 
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;

--------------------------------------------------------------------
--3. Checking product sold at our stores - 29 different types
--------------------------------------------------------------------
SELECT DISTINCT product_category
FROM  `workspace`.`default`.`Bright_coffee_shop_sales`;
------------------------------------------------------------------------
--4. checking product detail sold at our store - 80 different categories
-------------------------------------------------------------------------
SELECT DISTINCT product_detail
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;

SELECT DISTINCT product_type
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;

SELECT DISTINCT  product_category AS category,
                 product_detail AS product_name 
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;

------------------------------------------------------------------
--
--5. Checking product prices
------------------------------------------------------------------
SELECT MIN (unit_price) AS cheapest_price 
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;

SELECT MAX (unit_price) AS expensive_price 
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;
------------------------------------------------------------------
SELECT
COUNT(*) AS number_of_rows,
   COUNT(DISTINCT product_id) AS number_of_sales,
   COUNT(DISTINCT store_id) AS number_of_store 
FROM `workspace`.`default`.`Bright_coffee_shop_sales`; 

------------------------------------------------------------------
SELECT transaction_id,
       transaction_date,
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) AS Monthname,
       transaction_qty*unit_price AS revenue_per_tnx
FROM `workspace`.`default`.`Bright_coffee_shop_sales`;
------------------------------------------------------------------
--calculation the Revenue
------------------------------------------------------------------
SELECT unit_price,
       transaction_qty,
       unit_price * transaction_qty AS revenue
FROM  `workspace`.`default`.`Bright_coffee_shop_sales`  

--Combining functions to geta clean and enhanced data   

SELECT 
--Dates
       transaction_date,
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) AS Month_name, 
       date_format(transaction_time,'HH:mm:ss') AS purchase_time,
       
       CASE
           WHEN Dayname(transaction_date) IN ('sunday','saturday') THEN 'weekend'
           ELSE 'weekday' 
       END AS Day_classification, 
-- new columm added for Time bucket 

       CASE 
              WHEN date_format(transaction_time, 'HH:mm:ss') Between '05:00:00'AND '08:59:59' THEN '01.Rush Hour' 
              WHEN date_format(transaction_time, 'HH:mm:ss') Between '09:00:00'AND '11:59:59' THEN '02.Mid Morning'                         
              WHEN date_format(transaction_time, 'HH:mm:ss') Between '12:00:00'AND '15:59:59' THEN '03.Afternoon'
              WHEN date_format(transaction_time, 'HH:mm:ss') Between '16:00:00'AND '18:59:59' THEN '04.Rush Hour'
        END AS time_bucket,      
--Count of IDs 
 COUNT(DISTINCT transaction_id) AS Number_of_sales,
 COUNT(DISTINCT product_id) AS number_of_products,
 COUNT(DISTINCT store_id) AS number_of_stores,
 --Revenue
 SUM(transaction_qty*unit_price) AS revenue_per_day,

 -- Categorical columns
       store_location, 
       product_category,
       product_detail
FROM `workspace`.`default`.`Bright_coffee_shop_sales`
GROUP BY transaction_id,
         transaction_date,
         day_name,
         store_id, 
         store_location,
         unit_price, 
         product_category,
         product_detail,
         month_name,
         purchase_time,
         time_bucket,
         day_classification;

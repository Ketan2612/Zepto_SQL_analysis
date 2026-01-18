drop table if exists zepto;
create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(120) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
 
);

-- count of rows 

select count(*) from zepto;

-- sample data

select * from zepto limit 10;

-- checking null values

select 
count(*) filter (where sku_id IS NULL) AS sku_id_null,
count(*) filter (where category IS NULL) AS category_null,
count(*) filter (where name IS NULL) AS name_null,
count(*) filter (where mrp IS NULL) AS mrp_null,
count(*) filter (where discountPercent IS NULL) AS discountPercent_null,
count(*) filter (where availableQuantity IS NULL) AS availableQuantity_null,
count(*) filter (where discountedSellingPrice IS NULL) AS discountedSellingPrice_null,
count(*) filter (where weightInGms IS NULL) AS weightInGms_null,
count(*) filter (where outOfStock IS NULL) AS outOfStock_null,
count(*) filter (where quantity IS NULL) AS quantity_null
from zepto;

-- different product categories

select distinct category
from zepto
order by category;

-- products outOfstock or inStock

select outOfStock , COUNT(sku_id)
from zepto
group by outOfStock;

-- product names present multiple times

select name , count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

-- products with price is 0

select * from zepto
where mrp = 0 OR discountedSellingPrice = 0;

DELETE from zepto 
where mrp = 0;

-- convert paise to rupees

UPDATE zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp , discountedSellingPrice from zepto;

--Q1. Find the top 10 best-value products based on the discount percentage.

select distinct name , mrp , discountPercent
from zepto 
order by discountPercent DESC
LIMIT 10;

--Q2. What are the Products with High MRP but Out of Stock
select * from zepto;
select distinct name , mrp 
from zepto
where outOfStock = True 
order by mrp DESC;

--Q3.Calculate Estimated Revenue for each category

select category , SUM(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue;

--Q4. Find all products where MRP is greater than 500 and discount is less than 10%.

select distinct name , mrp , discountpercent 
from zepto
where mrp>500 AND discountpercent < 10
order by name ASC;

--Q5. Identify the top 5 categories offering the highest average discount percentage.

select category , ROUND(AVG(discountpercent),2) as highestAverageDiscount
from zepto
group by category
order by highestAverageDiscount DESC
LIMIT 5;

--Q6. Find the price per gram for products above 100g and sort by best value.

select distinct name , weightingms , discountedSellingPrice, ROUND(discountedSellingPrice/weightingms,2) AS price_per_gm
from zepto
where weightingms >= 100
order by price_per_gm;

--Q7.Group the products into categories like Low, Medium, Bulk.

SELECT DISTINCT name , weightingms , 
case when weightingms < 1000 then 'Low'
when weightingms < 4000 then 'Medium'
else 'Bulk'
end as weight_category
from zepto;

--Q8. What is the Total Inventory Weight Per Category 

select category , 
SUM(weightingms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight DESC;

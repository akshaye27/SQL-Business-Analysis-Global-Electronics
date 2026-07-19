-- =====================================================
-- Global Electronics Retailer SQL Analysis Project
-- Author: Akshaye Nair
-- Database: MySQL
-- Questions Solved: 28
-- =====================================================
-- Q1. What is the Date Range in Sales Table?
Select Min(str_to_date(`order date`,'%m/%d/%Y')) as Earliest_Date, Max(str_to_date(`order date`,'%m/%d/%Y')) as Latest_Date
From Sales;
-- ----------------------------------------------------------------------------------------------
-- Q2. Ensuring there's no duplicate Products, if there is how to display duplicated products?
-- First Part:
select count(*) as Total_Products, count(distinct ProductKey) as Unique_Products 
from products;

-- Second Part
select `Product Name`, count(*) as Duplicate_Count
from products
group by `product name`
having count(*) > 1
order by Duplicate_Count desc;
-- --------------------------------------------------------------------------------------

-- Q3. Are there any sales records that reference a Customer, Product, or Store that doesn't exist?

select s.customerkey 
from sales s left join customers c
on s.customerkey = c.customerkey
where c.CustomerKey is null;

select s.productkey 
from sales s left join products p
on s.productkey = p.productkey
where p.productkey is null;

select s.StoreKey 
from sales s left join stores st
on s.StoreKey = st.StoreKey
where st.StoreKey is null;

-- Final query
select s.`Order Number`, s.customerkey, s.productkey, s.StoreKey
from sales s
Left join customers c on s.customerkey = c.customerkey
Left Join products p on s.productkey = p.productkey
left join stores st on s.StoreKey = st.StoreKey
where c.customerkey is null OR p.productkey is Null or st.StoreKey is Null;

-- ------------------------------------------------------------------------
-- Q4 if there are any missing values in important business columns.
Select 
Count(Case when CustomerKey IS NULL Then 1 End) as Missing_CustomerKey,
Count(Case when ProductKey is null then 1 end) as Missing_ProductKey,
Count(Case when StoreKey is null then 1 end) as Missing_Storekey,
count(Case when `Order Date` is null then 1 end) as Missing_OrderDate,
count(Case when `Order Number` is null then 1 end) as Missing_OrderNumber
From Sales;

-- ------------------------------------------------------------
-- Q5 Total Customers by Country
Select Country, count(distinct CustomerKey) as Total_Customers
from Customers
group by country
order by count(distinct CustomerKey) desc;

-- ------------------------------------------------------------
-- Q6Top 10 Countries by Revenue 
select c.country, SUM(s.Quantity * Cast(Replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) AS Revenue
from customers c join sales s on c.customerkey = s.customerkey
join products p on p.ProductKey = s.productkey
group by c.country
order by Revenue desc
limit 10;
-- ---------------------------------------------------------------------
-- Q7 Top 10 Products by Revenue
select	p.`Product Name` as Product, SUM(s.Quantity * Cast(Replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) AS Revenue
from products p join sales s
on p.ProductKey = s.ProductKey
group by p.`Product Name`, p.ProductKey
order by Revenue desc
Limit 10;

-- ----------------------------------------------------
-- Q8 Which Brands generate highest revenue
select p.Brand as Brands, SUM(s.Quantity * Cast(Replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) AS Revenue
from products p join sales s
on p.ProductKey = s.ProductKey
group by Brands
order by Revenue desc
Limit 10;

-- ----------------------------------------------------------------
-- Q9 Which stores generate the highest total revenue?
select st.storekey, st.state, st.country, SUM(s.Quantity * Cast(Replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) AS Revenue
from stores st join sales s on st.storekey = s.storekey
join products p on p.productkey = s.productkey
group by st.storekey, st.state, st.country
order by revenue desc
limit 10;

-- ----------------------------------------------------------------
-- Q10 How much revenue comes from Online sales versus Physical Stores?
select
Case when s.storekey != 0 Then 'Physical Store' Else 'Online' End As Sales_Channel,
SUM(s.Quantity * Cast(Replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) As Revenue
From sales s join products p on s.productKey = p.ProductKey
group by Sales_Channel
order by Revenue desc;

select
if(s.storekey = 0, 'Online', 'Physical Store') as Sales_Channel,
sum(s.Quantity * Cast(replace(p.`Unit Price USD`, '$', '') As Decimal(10,2))) AS Revenue
From sales s join products p on s.productKey = p.ProductKey
group by Sales_Channel
order by Revenue desc;

-- -------------------------------------------
-- Q11 Monthly Revenue Trend
select YEAR(str_to_date(s.`Order Date`, '%m/%d/%Y')) AS Years,
month(str_to_date(s.`Order Date`, '%m/%d/%Y')) AS Months,
sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue
From Sales s join products p
on s.productkey = p.ProductKey
group by Years, Months
order by Years, Months;

select Date_Format(Str_To_date(s.`Order Date`, '%m/%d/%Y'), '%Y-%m') as Year_Month_Date,
sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue
From Sales s join products p
on s.productkey = p.ProductKey
group by Year_Month_Date
order by Year_Month_Date ASC;

-- -------------------------------------------------------
-- Q12 Annual Revenue Analysis
select
year(str_to_date(s.`Order Date`, '%m/%d/%Y')) as Years,
Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue
from Sales s join products p
on s.productkey = p.ProductKey
group by Years
order by Years desc;

-- --------------------------------------------------------
-- Q13 Weekday vs Weekend Revenue
-- str_to_date(s.`Order Date`, '%m/%d/%Y')
Select
Case 
when dayofweek(str_to_date(s.`Order Date`, '%m/%d/%Y')) = 1 then 'Weekend'
when dayofweek(str_to_date(s.`Order Date`, '%m/%d/%Y')) = 2 then 'Weekday'
when dayofweek(str_to_date(s.`Order Date`, '%m/%d/%Y')) = 3 then 'Weekday'
when dayofweek(str_to_date(s.`Order Date`, '%m/%d/%Y')) = 4 then 'Weekday'
when dayofweek(str_to_date(s.`Order Date`, '%m/%d/%Y')) = 5 then 'Weekday'
when dayofweek(str_to_date(s.`Order Date`, '%m/%d/%Y')) = 6 then 'Weekday'
when dayofweek(str_to_date(s.`Order Date`, '%m/%d/%Y')) = 7 then 'Weekend'
End as Day_Type,
Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue
from Sales s join products p
on s.productkey = p.ProductKey
group by Day_Type
order by Day_type desc;

select
Case
When dayofweek(str_to_date(s.`Order Date`, '%m/%d/%Y')) in (1,7) then 'Weekend' else 'Weekday' END as Day_Type,
Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue
from Sales s join products p
on s.productkey = p.ProductKey
group by Day_Type
order by Day_type desc;

-- -----------------------------------------------------------------
-- Q14 What is the average revenue generated per order?
select
avg(Revenue) as Average_Order_Value from (select s.`Order Number`, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue
from Sales s join products p
on s.productkey = p.ProductKey
group by s.`Order Number`) as Order_Totals;

-- -----------------------------------------------------------------
-- Q15 Repeat vs One-Time Customers
select customerkey, count(Distinct `Order Number`) as Total_Orders from Sales group by customerkey;

select
case when Total_Orders > 1 then 'Repeat Customers' Else 'One-Time Customers' End as Customer_Type, Count(*) as Customer_Count from (select customerkey, count(Distinct `Order Number`) as Total_Orders from Sales group by customerkey) AS Customer_Orders
group by Customer_Type;

-- ---------------------------------------------------------------------------------------
-- Q16 Customer Segmentation by Spending
select s.customerkey, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue from Sales s join products p
on s.productkey = p.ProductKey
group by s.customerkey;

select
case when revenue >= 10000 then 'High-Value'
when revenue >= 5000 then 'Mid-Value'
Else 'Low-Value'
end as Customer_Segmentation, Count(*) as Total_Customers from (select s.customerkey, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue from Sales s join products p
on s.productkey = p.ProductKey
group by s.customerkey) as Total_Revenue
group by Customer_Segmentation;

-- -----------------------------------------------------------
-- Q17 Products That Have Never Been Sold
select p.productkey as Product_Key, p.`product name` as Product_Name
from products p left join sales s 
on p.ProductKey = s.ProductKey
where s.productkey is null;

-- ----------------------------------------
-- Q18 Revenue Contribution by Category
select Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Total_Revenue from Sales s join products p
on p.ProductKey = s.ProductKey;

select p.category as Category, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Total_Revenue, (Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) / (select Sum(s1.Quantity * cast(replace(p1.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Total_Revenue from Sales s1 join products p1
on p1.ProductKey = s1.ProductKey))*100 as Percent_Revenue
from products p join sales s
on p.productKey = s.ProductKey
group by Category;


-- ----------------------------------------------------
-- Q19 Which customers have purchased products from more than one product category?
select s.customerkey as Customer, Count(Distinct p.Category) as Category_Count
from sales s join products p
on s.ProductKey = p.productkey
group by Customer
Having Category_Count > 1
order by Category_Count desc;

-- -----------------------------------------------------------------------------
-- Q20 Customer Segmentation by Spending (CTEs)
With Customer_Revenue As
(
select s.customerkey, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue from Sales s join products p
on s.productkey = p.ProductKey
group by s.customerkey
)
select
case when revenue >= 10000 then 'High-Value'
when revenue >= 5000 then 'Mid-Value'
Else 'Low-Value'
end as Customer_Segmentation, Count(*) as Total_Customers from Customer_Revenue
group by Customer_Segmentation;

-- ---------------------------------------------------------------------------
-- Q21 Top-Selling Product in Each Category (using Window Function and CTE)
With Top_Selling_Product as
(
select p.category as Categories, p.`Product Name` as Product_Name, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue 
from Sales s join products p
on s.productkey = p.ProductKey
group by Categories, Product_Name
),
Product_Rank as
(
select *, row_number() Over (partition by Categories order by Revenue desc) As Ranking
from Top_Selling_Product
)
select Categories, Product_Name, Revenue 
from Product_Rank
where Ranking = 1;

-- -----------------------------------------------------------------
-- Q22 Rank() vs Dense_Rank()
With Top_Selling_Product as
(
select p.category as Categories, p.`Product Name` as Product_Name, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue 
from Sales s join products p
on s.productkey = p.ProductKey
group by Categories, Product_Name
)

select *, rank() over (partition by Categories order by Revenue DESC) as Rank_Value,
dense_rank() over (partition by Categories order by Revenue DESC) as Dense_Rank_Value,
row_number() Over (partition by Categories order by Revenue desc) As Ranking
from Top_Selling_Product;

-- -----------------------------------------------------------
-- Q23 Top 3 products in each category
With Top_Selling_Product as
(
select p.category as Categories, p.`Product Name` as Product_Name, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue 
from Sales s join products p
on s.productkey = p.ProductKey
group by Categories, Product_Name
),
Product_Rank as
(
select *, dense_rank() Over (partition by Categories order by Revenue desc) As Ranking
from Top_Selling_Product
)
select Categories, Product_Name, Revenue 
from Product_Rank
where Ranking <= 3;

-- ---------------------------------------------------------------------------
-- Q24 Show the cumulative (running) revenue over time.
with Date_Revenue as
(
select Year(str_to_date(s.`Order Date`, '%m/%d/%Y')) as Years, Month(str_to_date(s.`Order Date`,'%m/%d/%Y')) as Months, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue
from Sales s join products p
on s.productkey = p.ProductKey
group by Years, Months
order by Years, Months asc
)
select *, sum(Revenue) over (order by Years, months) as Running_total
from Date_Revenue;

-- ------------------------------------------------------------------------
-- Q25 Calculate the month-over-month revenu change
with Date_Revenue as
(
select Year(str_to_date(s.`Order Date`, '%m/%d/%Y')) as Years, Month(str_to_date(s.`Order Date`,'%m/%d/%Y')) as Months, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue
from Sales s join products p
on s.productkey = p.ProductKey
group by Years, Months
order by Years, Months asc
)

select *, Lag(Revenue) over (Order by Years, Months) as Previous_Month_Revenue, Revenue - Lag(Revenue) over (Order by Years, Months) as Revenue_Difference
from Date_Revenue;  

-- ---------------------------------------------------------------------------
-- Q26 Calculate YoY Growth
with Date_Revenue as
(
select Year(str_to_date(s.`Order Date`, '%m/%d/%Y')) as Years, Sum(s.Quantity * cast(replace(p.`Unit Price USD`, '$', '') AS Decimal(10,2))) as Revenue
from Sales s join products p
on s.productkey = p.ProductKey
group by Years
order by Years asc
)
select *, Lag(Revenue) over (Order by Years) as Previous_Years_Revenue, ((Revenue - Lag(Revenue) over (Order by Years))/Lag(Revenue) over (Order by Years))*100 as Growth_Percent
from Date_Revenue;

-- ------------------------------------------------
-- Q27 How many customers purchased in consecutive years?
WITH Customer_Years AS
(
    SELECT DISTINCT
        s.CustomerKey,
        YEAR(STR_TO_DATE(s.`Order Date`, '%m/%d/%Y')) AS Years
    FROM Sales s
),
Customer_Previous AS
(
    SELECT
        CustomerKey,
        Years,
        LAG(Years) OVER (
            PARTITION BY CustomerKey
            ORDER BY Years
        ) AS Previous_Year
    FROM Customer_Years
)
SELECT
    Years,
    COUNT(CustomerKey) AS Returning_Customers
FROM Customer_Previous
WHERE Previous_Year = Years - 1
GROUP BY Years
ORDER BY Years;

-- -----------------------------------------------------------
-- Q28 Executive Business Report
WITH Order_Revenue AS
(
    SELECT
        s.`Order Number`,
        SUM(
            s.Quantity *
            CAST(REPLACE(p.`Unit Price USD`, '$', '') AS DECIMAL(10,2))
        ) AS Order_Revenue
    FROM Sales s
    JOIN Products p
        ON s.ProductKey = p.ProductKey
    GROUP BY s.`Order Number`
)

SELECT
    COUNT(DISTINCT s.`Order Number`) AS Total_Orders,
    COUNT(DISTINCT s.CustomerKey) AS Total_Customers,
    COUNT(DISTINCT s.ProductKey) AS Total_Products,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.`Unit Price USD`, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Revenue,
    ROUND(
        (
            SUM(
                s.Quantity *
                CAST(REPLACE(p.`Unit Price USD`, '$', '') AS DECIMAL(10,2))
            )
        ) / COUNT(DISTINCT s.`Order Number`),
        2
    ) AS Average_Order_Value,
    ROUND(
        (
            SUM(
                s.Quantity *
                CAST(REPLACE(p.`Unit Price USD`, '$', '') AS DECIMAL(10,2))
            )
        ) / COUNT(DISTINCT s.CustomerKey),
        2
    ) AS Average_Revenue_Per_Customer,

    ROUND(
        AVG(Order_Revenue),
        2
    ) AS Average_Order_Revenue
FROM Sales s
JOIN Products p
    ON s.ProductKey = p.ProductKey
JOIN Order_Revenue o
    ON s.`Order Number` = o.`Order Number`;
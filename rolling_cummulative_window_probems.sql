CREATE TABLE txn (
    txn_id INT PRIMARY KEY,
    txn_date DATE,
    customer_id INT,
    amount DECIMAL(10,2)
);

INSERT INTO txn (txn_id, txn_date, customer_id, amount) VALUES
(1, '2024-03-01', 101, 100.00),
(2, '2024-03-02', 102, 200.00),
(3, '2024-03-03', 101, 150.00),
(4, '2024-03-04', 103, 300.00),
(5, '2024-03-05', 102, 250.00),
(6, '2024-03-06', 101, 50.00),
(7, '2024-03-07', 103, 400.00);


select * from txn;

-- Write a SQL query to calculate the running total of the amount column ordered by txn_date.
select *,
sum(amount) over(order by txn_id) as running_total
from txn;

-- Running Total per Customer
select *,
sum(amount) over(partition by customer_id order by txn_id) as c_running_total
from txn;

-- Compute a running total for the last 3 transactions (rolling sum).

select *,
sum(amount) over(order by txn_date rows between 2 preceding and current row) as 3_day_rolling
from txn;

-- above is based on rows, it is wrong it should be based on previous txn date.
-- alternate 
with txn_by_day as
(select txn_date, sum(amount) as amount from txn group by 1)
select a.*, 
sum(amount) over(order by txn_date rows between 2 preceding and current row) as 3_day_txn_rolling
from txn_by_day a;

-- Write two different ways to compute the running total: 
-- one using window functions and another using self-joins or subqueries.

-- using window functions:
select *, 
sum(amount) over(order by txn_id) as cummu_sum
from txn;

-- using self join and subquery

select *, 
(select sum(b.amount) 
from txn b
where b.txn_id <= a.txn_id) as cumm_sum
from txn a;

-- alternate way

set @csum = 0;

select *, @csum := @csum + amount 
from txn;

-- --------------------------

CREATE TABLE sales1 (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    salesperson_id INT,
    region VARCHAR(50),
    sale_amount DECIMAL(10,2)
);

INSERT INTO sales1 (sale_id, sale_date, salesperson_id, region, sale_amount) VALUES
(1, '2024-03-01', 101, 'North', 500.00),
(2, '2024-03-02', 102, 'South', 1200.00),
(3, '2024-03-03', 101, 'North', 700.00),
(4, '2024-03-04', 103, 'East', 950.00),
(5, '2024-03-05', 102, 'South', 400.00),
(6, '2024-03-06', 101, 'North', 1300.00),
(7, '2024-03-07', 103, 'East', 800.00),
(8, '2024-03-08', 101, 'North', 650.00),
(9, '2024-03-09', 102, 'South', 1100.00),
(10, '2024-03-10', 103, 'East', 750.00);

select * from sales1;

--  Compute the running total of sale_amount, ordered by sale_date.
select *,
sum(sale_amount) over(order by sale_date) as cumm_sales
from sales1;

-- Compute the running total of sale_amount per salesperson_id, ordered by sale_date.

select *,
sum(sale_amount) over(partition by salesperson_id order by sale_date) as cumm_sales_by_user
from sales1;

--  Compute a rolling sum of sale_amount for the last 7 days for each salesperson.
with a as(
select sale_date, salesperson_id,  sum(sale_amount) as sale_amount
from sales1
group by 1,2
order by 1,2)
select *,
sum(sale_amount) over(partition by salesperson_id order by sale_date rows between 6 preceding and current row) as 7_day_runnin
from a;

-- Find the first date when the running total of all sales exceeded $10,000.
with a as(
select *,
sum(sale_amount) over(order by sale_date) as cumm_sales
from sales1),
b as (
select *, 
case when cumm_sales >= 5000 then 1 else 0 end as flag
from a)
select min(sale_date) from b where flag = 1;

-- Compute a running total for each region, but reset the total at the start of each month.
with a as(
select *, date_format(sale_date,"%y-%m") as month from sales1)
select *,
sum(sale_amount) over(partition by region, month order by sale_date) as run
from a;

--
SELECT *,
       SUM(sale_amount) OVER (PARTITION BY salesperson_id, EXTRACT(YEAR FROM sale_date), 
                              EXTRACT(QUARTER FROM sale_date) ORDER BY sale_date, sale_id) AS quarterly_running_total
FROM sales1
;



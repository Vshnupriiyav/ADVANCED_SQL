select * from Departments;
select * from Employees;

with ranking as(
select 
EmployeeID, FirstName, DepartmentID, Salary,
dense_rank() over(partition by DepartmentID order by Salary Desc) as rnk
from Employees)
select EmployeeID, FirstName, DepartmentName, Salary  from ranking a
inner join Departments b 
on a.DepartmentID = b.DepartmentID
where rnk <= 3;

-- average salary
with base_data as
(select * from Employees
where DateHired >= date_sub(now(), interval 5 year))
select avg(salary) as avg_salary from base_data;

-- employess wiht less tan avg salary in last 5 years
with base_data as
(select * from Employees
where DateHired >= date_sub(now(), interval 5 year)),
avg_calc as(
select avg(salary) as avg_salary from base_data),
base_data2 as(
select a.*, b.* from Employees a
cross join avg_calc b)
select * from base_data2 where Salary < avg_salary;

-- --------------------------------------
select * from sales_data;

-- convert to month, electronics and clothing
select month,
sum(case when category = "Electronics" then amount else 0 end) as "Electronics",
sum(case when category = "Clothing" then amount else 0 end) as "Clothing"
from sales_data
group by 1;


select * from user_activity;

with a as(
select *, 
row_number() over(partition by user_id order by activity_date),
date_sub(activity_date, interval row_number() over(partition by user_id order by activity_date) day) as grp
from user_activity
),
b as (
select user_id, grp, count(*) from a group by 1,2)
select * from b


;

WITH ranked_activity AS (
    SELECT 
        user_id, 
        activity_date, 
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY activity_date) AS rn,
        DATE_SUB(activity_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY activity_date) DAY) AS streak_group
    FROM user_activity
)
SELECT 
    user_id, 
    MAX(streak_length) AS longest_streak
FROM (
    SELECT user_id, streak_group, COUNT(*) AS streak_length
    FROM ranked_activity
    GROUP BY user_id, streak_group
) streaks
GROUP BY user_id
ORDER BY user_id;



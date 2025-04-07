-- Problem 1

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;
select players, count(1) as num_matches_played, sum(fl_won) as num_matches_won, count(1) - sum(fl_won) as num_matches_lost
from(
select team_1 as players, case when Winner = Team_1 then 1 else 0 end as fl_won from icc_world_cup
union all
select Team_2 as players, case when Winner = Team_2 then 1 else 0 end as fl_won from icc_world_cup) a
group by 1;


-- problem 2

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;
select * from customer_orders;

with new as(
select customer_id, order_date, 
min(order_date) over(partition by customer_id order by order_date) as first_order_Date
 from customer_orders)
select order_date, 
count(case when order_date = first_order_date then customer_id end) as num_new_customers,
count(case when order_date != first_order_date then customer_id end) as num_repeat_customers
from new group by 1;

-- problem 3

create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR');

select * from entries;

with a as (
select name, floor, 
rank() over(partition by floor order by count(1) desc) as rnk
from entries
group by 1,2)
select a.name, a.floor as max_visited, 
count(a.name) as num_times_visited,
group_concat(distinct resources separator ',') as floors_visted
from  a 
join entries b on a.name = b.name 
where a.rnk = 1
group by 1,2;


-- problem 4
-- write a query to provide the date for nth occurence of sunday in future from given date 

SET @given_date = '2025-04-06';
SET @n = 2; 

-- Find the next Sunday
SET @days_to_sunday = (6 - WEEKDAY(@given_date)) % 6;
select @days_to_sunday 

-- Calculate the nth Sunday from the given date
SELECT @given_date AS given_date,
@days_to_sunday,
WEEKDAY(@given_date) AS weekday_of_given_date,
DATE_ADD(@given_date, INTERVAL @days_to_sunday + (@n - 1) * 7 DAY) AS nth_sunday_date;


-- problem 5

Create table friend (pid int, fid int);
insert into friend (pid , fid ) values ('1','2');
insert into friend (pid , fid ) values ('1','3');
insert into friend (pid , fid ) values ('2','1');
insert into friend (pid , fid ) values ('2','3');
insert into friend (pid , fid ) values ('3','5');
insert into friend (pid , fid ) values ('4','2');
insert into friend (pid , fid ) values ('4','3');
insert into friend (pid , fid ) values ('4','5');

create table person (PersonID int,	Name varchar(50),	Score int);
insert into person(PersonID,Name ,Score) values('1','Alice','88');
insert into person(PersonID,Name ,Score) values('2','Bob','11');
insert into person(PersonID,Name ,Score) values('3','Devis','27');
insert into person(PersonID,Name ,Score) values('4','Tara','45');
insert into person(PersonID,Name ,Score) values('5','John','63');
select * from person;
select * from friend;

select a.pid, b.Name, num_friends, total_Score from
(
select pid, count(fid) as num_friends, sum(score) as total_Score 
from (
select b.*, score
from friend b
join  person a  on a.PersonID = b.fid) a
group by 1
having sum(score) > 100) a
join person b 
on a.pid = b.PersonID;


-- problem 6
Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users1 (users_id int, banned varchar(50), role varchar(50));
Truncate table Trips;
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
Truncate table Users;
insert into Users1 (users_id, banned, role) values ('1', 'No', 'client');
insert into Users1 (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users1 (users_id, banned, role) values ('3', 'No', 'client');
insert into Users1 (users_id, banned, role) values ('4', 'No', 'client');
insert into Users1 (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users1 (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users1 (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users1 (users_id, banned, role) values ('13', 'No', 'driver');

select * from Trips;
select * from Users1;

select request_at,
round(COALESCE(sum(case when status = 'completed' then 0 else 1 end) , null) *100/  count(id),2) as cancellation_rate
from(
select a.* from Trips a
inner join Users1 b on a.client_id = b.users_id
inner join Users1 c on a.driver_id = c.users_id
where b.banned = "No" and c.banned = "No") a
group by 1;

-- problem 7
create table players
(player_id int,
group_id int);

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int);

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

select * from players;
select * from matches;


with cte as
(select first_player as player, first_score as score 
from matches 
union all 
select second_player as player, second_score as score 
from matches) ,
cte2 as
(
select b.group_id, a.player,  sum(score) as score
from cte a
join players b
on a.player = b.player_id
group by 1,2)
select *,
rank() over(partition by group_id order by score desc, player) as rnk 
from cte2;

-- problem 8
create table users2 (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users2 values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);
 
select * from users2;
select * from items; 
select * from orders;

with cte as(
select seller_id, item_id
from(
select a.order_date, a.seller_id, a.item_id, b.item_brand,
rank() over(partition by seller_id order by order_date) as rnk
from orders a
join items b on a.item_id = b.item_id) a
where rnk = 2)
select user_id as seller_id, case when c.item_brand = a.favorite_brand then 'yes' else 'no' end as 2nd_favorite_prdt_sold
from users2 a
left join cte b on a.user_id = b.seller_id
left join items c on b.item_id = c.item_id;

-- problem 9
create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success');

select * from tasks;

select min(date_value) as start_date, max(date_value) as end_date, state
from(
SELECT 
    date_value, state,
     ROW_NUMBER() OVER (PARTITION BY state ORDER BY date_value),
    DATE_SUB(date_value, INTERVAL ROW_NUMBER() OVER (PARTITION BY state ORDER BY date_value) DAY) AS group_id
FROM tasks) a
group by group_id, state
order by start_date;

-- problem 10:
create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

select * from spending;

with all_spend as(
select spend_date,  user_id, max(platform) as platform, count(distinct user_id) as num_users, sum(amount) as total_amount
from spending 
group by 1,2
having count(platform) = 1

union all

select spend_date, user_id, 'both'  as platform, count(distinct user_id) as num_users, sum(amount) as total_amount
from spending 
group by 1,2
having count(platform) = 2

union all 

select  distinct spend_date, null user_id, 'both'  as platform, 0 as num_users, 0 as total_amount
from spending 
group by 1,2)
select spend_date, platform, count(distinct user_id) as num_users, sum(total_amount) as total_amount
from all_spend
group by 1,2;

-- problem 11:

create table sales (
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);

select * from sales;

with recursive cte as (
select min(period_start) as dates, max(period_end) as max_date from sales
union all
select date_add(dates, interval 1 day) as dates, max_date from cte
where dates <max_date)
select year(dates) as year, product_id, sum(average_daily_sales) as total_amount from cte
inner join sales on dates between period_start and period_end
group by 1,2
order by 1,2;

-- problem 12

create table orders1
(
order_id int,
customer_id int,
product_id int
);

insert into orders1 VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products (
id int,
name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

select * from orders1;
select * from products;

select pair, count(*) as num
from(
SELECT 
    a.order_id, 
    CONCAT(c.name, '-', d.name) AS pair
FROM orders1 a 
INNER JOIN orders1 b 
    ON a.order_id = b.order_id
inner join products c on a.product_id = c.id 
inner join products d on b.product_id = d.id 
WHERE a.product_id != b.product_id 
AND a.product_id > b.product_id) a
group by 1;

-- problem 13
CREATE TABLE users3 (
    user_id INT,
    name VARCHAR(20),
    join_date DATE
);

INSERT INTO users3 (user_id, name, join_date) VALUES
(1, 'Jon', STR_TO_DATE('2020-02-14', '%Y-%m-%d')), 
(2, 'Jane', STR_TO_DATE('2020-02-14', '%Y-%m-%d')), 
(3, 'Jill', STR_TO_DATE('2020-02-15', '%Y-%m-%d')), 
(4, 'Josh', STR_TO_DATE('2020-02-15', '%Y-%m-%d')), 
(5, 'Jean', STR_TO_DATE('2020-02-16', '%Y-%m-%d')), 
(6, 'Justin', STR_TO_DATE('2020-02-17', '%Y-%m-%d')),
(7, 'Jeremy', STR_TO_DATE('2020-02-18', '%Y-%m-%d'));

CREATE TABLE events1 (
    user_id INT,
    type VARCHAR(10),
    access_date DATE
);

INSERT INTO events1 (user_id, type, access_date) VALUES
(1, 'Pay', STR_TO_DATE('2020-03-01', '%Y-%m-%d')), 
(2, 'Music', STR_TO_DATE('2020-03-02', '%Y-%m-%d')), 
(2, 'P', STR_TO_DATE('2020-03-12', '%Y-%m-%d')),
(3, 'Music', STR_TO_DATE('2020-03-15', '%Y-%m-%d')), 
(4, 'Music', STR_TO_DATE('2020-03-15', '%Y-%m-%d')), 
(1, 'P', STR_TO_DATE('2020-03-16', '%Y-%m-%d')), 
(3, 'P', STR_TO_DATE('2020-03-22', '%Y-%m-%d'));

select * from users3;
select * from events1;

with denominator as (
select user_id, join_date from users3 where user_id in (select user_id from events1 where type = 'Music')),
numerator as(
select user_id, access_date from events1 where type = 'P' and
user_id in (select user_id from denominator)),
sets as(
select a.*, b.access_date ,DATEDIFF(access_date, join_date) AS date_difference
from denominator a 
left join numerator b on a.user_id = b.user_id)
select round(count(case when date_difference < 31 then access_date end)/count(join_date),2)*100 as music_subs_rate
from sets;

-- problem 14


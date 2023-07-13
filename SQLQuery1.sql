drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date);
INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);
select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;
select a.userid, sum(b.price) total_amt_spent from sales a inner join product b on b.product_id=a.product_id group by userid;
select userid, count(distinct created_date) distinct_days from sales group by userid;
select * from (select *, rank() over(partition by userid order by created_date desc) rnk from sales) a where rnk =1
select userid, count(product_id)from sales where product_id=(select top 1 product_id from sales group by product_id order by count(product_id) desc)
group by userid 
select * from 
(select *, rank() over(partition by userid order by created_date) rnk from 
(select a.userid,a.created_date,a.product_id, b.gold_signup_date from sales a inner join goldusers_signup b on a.userid<=b.userid and created_date>gold_signup_date) c)d where rnk=1
select * from 
(select *, rank() over(partition by userid order by created_date desc) rnk from 
(select b.userid,a.created_date,a.product_id, b.gold_signup_date from sales a inner join goldusers_signup b on a.userid>=b.userid and created_date>gold_signup_date) c)d where rnk=1
select userid, count(created_date) as order_purchased,sum(price) as total_amt_purchased from(select c.*, d.price from (select b.userid,a.created_date,a.product_id, b.gold_signup_date from sales a inner join goldusers_signup b on a.userid=b.userid and created_date<=gold_signup_date)c inner join product d on c.product_id=d.product_id)e group by userid
select * from sales
select*, rank()over (order by total_points_earned desc)rnk from (select userid,sum(point_obtained) as total_points_earned from(select e.*, amt/ points as point_obtained from(select d.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.product_id, c. userid, sum(price)amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id)c
group by userid,product_id)d)e)f group by userid)g ;
select c.*, d.price*0.5 as zomato_points from(select a.userid, a.product_id, a.created_date, b.gold_signup_date from sales a inner join goldusers_signup b on a.userid=b.userid 
and created_date>=gold_signup_date and created_date<=DATEADD(Year,1,gold_signup_date))c inner join product d on d.product_id=c.product_id;

select e.*, case when rnk=0 then 'na' else rnk end as rnkk from
(select c.*, cast ((case when gold_signup_date is null then 0 else rank() over(partition by userid order by created_date desc)end) as varchar)as rnk from (select a.userid,a.created_date,a.product_id, b.gold_signup_date from sales a left join goldusers_signup b on a.userid<=b.userid and created_date>gold_signup_date)c)e;
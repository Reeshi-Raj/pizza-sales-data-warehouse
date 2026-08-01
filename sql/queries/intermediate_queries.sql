use pizza_sales_project;

# 1.The restaurant owner wants to identify the Top 5 pizzas that generated the highest revenue.
select pt.name,
        sum(p.price*od.quantity) as revenue
from pizzas p inner join order_details od 
on p.pizza_id=od.pizza_id
inner join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
group by pt.pizza_type_id,pt.name
order by revenue desc
limit 5;

# 2.The finance team wants to know how much revenue each pizza category contributes to the business.
select pt.category,
		sum(p.price*od.quantity) as revenue
from pizzas p inner join order_details od 
on p.pizza_id=od.pizza_id
inner join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
group by pt.category
order by revenue desc;

# 3.The marketing team wants to know which pizza sizes generate the highest revenue.
select p.size,
		sum(p.price*od.quantity) as revenue
from pizzas p inner join order_details od 
on p.pizza_id=od.pizza_id
inner join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
group by p.size
order by revenue desc;

# 4.The operations manager wants to identify the busiest hour of the day based on the number of orders placed.
select hour(o.order_time) as hr,
		count(*) as total_orders
from orders o
group by hour(o.order_time)
order by total_orders desc;

# 5.The restaurant owner wants to identify pizzas that have never been ordered.
select p.pizza_id,
		pt.name,
        p.size
from pizzas p inner join pizza_types pt 
on p.pizza_type_id=pt.pizza_type_id
left join order_details od
on p.pizza_id=od.pizza_id
where od.order_id is null;
 
 # 6.Find all orders in which more than 5 pizzas were purchased (total quantity in that order > 5).
 select o.order_id,
		sum(quantity) as total_pizzas_ordered
 from orders o inner join order_details od
 on o.order_id=od.order_id
 group by o.order_id
 having total_pizzas_ordered>5;
 
 # 7.The restaurant owner wants to identify all pizza categories whose total revenue is greater than the average revenue across all categories.
 select pt.category,
		round(sum(p.price*od.quantity),2) as revenue
 from pizzas p inner join order_details od 
on p.pizza_id=od.pizza_id
inner join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
 group by pt.category
 having revenue>(select round(sum(pizzas.price*order_details.quantity)/count(distinct pt.category),2) as avg_revenue_per_category
					from pizzas inner join order_details 
					on pizzas.pizza_id=order_details);
#note: Average revenue across all categories, including categories with zero sales." on this query this query will fail we have to use left join starting from pizza_types table

# 8.Find the top 3 pizza categories by total quantity sold (not revenue).
select pt.category,
		sum(od.quantity) as total_quantity
from pizza_types pt inner join pizzas p
on pt.pizza_type_id=p.pizza_type_id
inner join order_details od 
on p.pizza_id=od.pizza_id
group by pt.category
order by total_quantity desc
limit 3;

# 9.The restaurant owner wants to identify pizzas that generated revenue higher than the average revenue of all pizza types.
with revenue_per_pizza_type as(
	select pt.name,
			pt.category,
			sum(p.price*od.quantity) as revenue 
	from pizza_types pt inner join pizzas p
	on pt.pizza_type_id=p.pizza_type_id
	inner join order_details od 
	on p.pizza_id=od.pizza_id 
    group by pt.name,pt.category
)
select * 
from revenue_per_pizza_type t
where t.revenue >
(
    select avg(revenue)
    from revenue_per_pizza_type
); -- can not use agg function with where due to execution order
    
# 10.Find the top-selling pizza (by quantity) within each category.
with sales_per_pizza as (
select pt.category as category,
		pt.name,
        sum(od.quantity) as total_sales
from pizza_types pt inner join pizzas p
	on pt.pizza_type_id=p.pizza_type_id
	inner join order_details od 
	on p.pizza_id=od.pizza_id 
group by pt.category,pt.pizza_type_id,pt.name
),
max_sales_per_category as (
    select category,
           max(total_sales) as max_sales
    from sales_per_pizza
    group by category
)
select spp.category,
       spp.name,
       spp.total_sales
from sales_per_pizza spp
join max_sales_per_category mspc
    on spp.category = mspc.category
   and spp.total_sales = mspc.max_sales
order by spp.category;

# 11.The restaurant owner wants to identify all orders whose total bill amount is greater than the average order value.
with bill_per_order as (
select o.order_id,
		o.order_date,
        sum(quantity*price) as total_bill
from order_details od inner join pizzas p
on od.pizza_id=p.pizza_id
inner join orders o
on o.order_id=od.order_id
group by o.order_id,o.order_date
)
select * from bill_per_order bpo
where bpo.total_bill> (
select avg(total_bill) from bill_per_order 
);

# 12.Classify every order into three categories based on its total bill.
select od.order_id,
		sum(quantity*price) as total_bill,
        case
			when sum(quantity*price) < 20 then 'low_value'
			when sum(quantity*price) > 40 then 'high_value'
			else 'middle_value'
        end as order_category
from pizza_types pt inner join pizzas p
	on pt.pizza_type_id=p.pizza_type_id
	inner join order_details od 
	on p.pizza_id=od.pizza_id 
group by od.order_id;

## 13.The restaurant manager wants to know on which weekdays the restaurant receives the highest number of orders.
select dayname(o.order_date) as 'weekday',
		count(distinct o.order_id) as total_orders
from orders o inner join order_details od
on o.order_id=od.order_id
group by dayname(o.order_date) -- weekday also works here :)
order by total_orders desc;

# 14.The restaurant owner wants to identify the first order placed on each day.
with earliest_time_of_order_per_day as (
select o.order_date,
		min(o.order_time) as earliest_order_time
from orders o
group by o.order_date
)
select o.order_date,
		o.order_id,
        o.order_time
from earliest_time_of_order_per_day cte inner join orders o
on cte.order_date=o.order_date
and cte.earliest_order_time=o.order_time;

# 15.Find all dates on which the restaurant earned more revenue than the previous day.
WITH revenue_per_day AS (
    SELECT o.order_date,
           SUM(od.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
    GROUP BY o.order_date
),
previous_date AS (
    SELECT r1.order_date,
           (
               SELECT MAX(r2.order_date)
               FROM revenue_per_day r2
               WHERE r2.order_date < r1.order_date
           ) AS prev_date
    FROM revenue_per_day r1
)
SELECT cur.order_date,
       cur.revenue
FROM previous_date pd
JOIN revenue_per_day cur
    ON cur.order_date = pd.order_date
JOIN revenue_per_day prev
    ON prev.order_date = pd.prev_date
WHERE cur.revenue > prev.revenue
ORDER BY cur.order_date;

# 16.Find the most popular pizza size based on total quantity sold and also show its percentage contribution to total pizzas sold.
WITH quantity_per_size AS (
    SELECT p.size,
           SUM(od.quantity) AS total_quantity
    FROM pizzas p
    JOIN order_details od
        ON p.pizza_id = od.pizza_id
    GROUP BY p.size
)
SELECT size,
       total_quantity,
       ROUND(
           total_quantity /
           (SELECT SUM(total_quantity)
            FROM quantity_per_size) * 100,
           2
       ) AS percentage_contribution
FROM quantity_per_size
ORDER BY total_quantity DESC
LIMIT 1;

# 17.Find the monthly revenue and the number of orders placed in each month.
select monthname(o.order_date) as 'month',
			count(distinct o.order_id) as total_orders,
            round(sum(od.quantity*p.price),2) as revenue
from pizzas p inner join order_details od on 
p.pizza_id=od.pizza_id inner join orders o
on o.order_id=od.order_id
group by monthname(o.order_date);

# 18.Find the average number of pizzas ordered per order for each month.
select monthname(o.order_date) as 'month',
			count(distinct o.order_id) as total_orders,
            sum(od.quantity) as total_pizzas,
            round(sum(od.quantity)/count(distinct o.order_id),2) as avg_pizzas_per_order
from pizzas p inner join order_details od on 
p.pizza_id=od.pizza_id inner join orders o
on o.order_id=od.order_id
group by monthname(o.order_date);

# 19.Find the percentage contribution of each pizza category to the total revenue.
with revenue_per_category as(
	select pt.category as category,
			sum(p.price*od.quantity) as revenue
    from pizzas p inner join pizza_types pt
    on p.pizza_type_id=pt.pizza_type_id
    inner join order_details od
    on p.pizza_id=od.pizza_id
    group by pt.category
)
select rpc.category,
	rpc.revenue ,
    round((rpc.revenue/(select sum(revenue)
    from revenue_per_category))*100,2) as revenue_contribution
from revenue_per_category as rpc;

# 20.Find the top 5 pizza types by revenue, but include their percentage contribution to the total revenue.
with revenue_per_pizza as (
	select pt.name as pizza_name,
			pt.category as category,
            sum(p.price*od.quantity) as revenue
    from pizzas p inner join pizza_types pt
    on p.pizza_type_id=pt.pizza_type_id
    inner join order_details od
    on p.pizza_id=od.pizza_id
    group by pt.pizza_type_id
)
select rpp.pizza_name,
		rpp.category,
        rpp.revenue,
        round((rpp.revenue/(select sum(revenue)
        from revenue_per_pizza))*100,2) as percentage_contribution_in_revenue
from revenue_per_pizza as rpp
order by rpp.revenue desc
limit 5;


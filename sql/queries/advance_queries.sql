use pizza_sales_project;

# 1.Find the highest-revenue pizza type within each category.
with pizza_sales as (
    select
        pt.pizza_type_id,
        pt.name,
        pt.category,
        sum(p.price * od.quantity) AS revenue
    from pizza_types pt
    join pizzas p
        on pt.pizza_type_id = p.pizza_type_id
    join order_details od
        on p.pizza_id = od.pizza_id
    group by
        pt.pizza_type_id,
        pt.name,
        pt.category
)
select
    ps.category,
    ps.name,
    ps.revenue
from pizza_sales ps
where ps.revenue = (
    select max(other.revenue)
    from pizza_sales other
    where other.category = ps.category # main crux of correlated subquery
);

# 2.Find the top-selling pizza type within each category based on total quantity sold.
with pizza_sales as (
    select
        pt.pizza_type_id,
        pt.name,
        pt.category,
        sum(od.quantity) as total_quantity
    from pizza_types pt
    join pizzas p
        on pt.pizza_type_id = p.pizza_type_id
    join order_details od
        on p.pizza_id = od.pizza_id
    group by
        pt.pizza_type_id,
        pt.name,
        pt.category
)
select
    ps.category,
    ps.name,
    ps.total_quantity
from pizza_sales ps
where ps.total_quantity = (
    select max(other.total_quantity)
    from pizza_sales other
    where other.category = ps.category 
);

# 3.Rank all pizza types within each category based on total revenue, highest revenue getting Rank 1.
with pizza_wise_revenue as (
	select pt.category,
			pt.name,
            sum(p.price*od.quantity) as revenue
    from pizza_types pt
    inner join pizzas p
        on pt.pizza_type_id = p.pizza_type_id
    inner join order_details od
        on p.pizza_id = od.pizza_id
	group by pt.name,pt.category
)
select pwr.category,
		pwr.name,
        pwr.revenue,
        rank() over(partition by pwr.category order by revenue desc) as 'rank'
from pizza_wise_revenue pwr;

# 4.Find the top 3 highest-revenue pizza types within each category. Include all ties.
with pizza_wise_revenue as (
	select pt.category,
			pt.name,
            sum(p.price*od.quantity) as revenue
    from pizza_types pt
    inner join pizzas p
        on pt.pizza_type_id = p.pizza_type_id
    inner join order_details od
        on p.pizza_id = od.pizza_id
	group by pt.name,pt.category
),
ranked_pwr as (
	select pwr.category,
		pwr.name,
        pwr.revenue,
        dense_rank() over(partition by pwr.category order by revenue desc) as 'rank'
	from pizza_wise_revenue pwr
)
select *
from ranked_pwr
where ranked_pwr.rank<=3;

# 5.Find the longest streak of consecutive days on which the restaurant received at least one order.
with distinct_dates as (
    select distinct order_date
    from orders
),
date_groups as (
    select
        order_date,
        date_sub(
            order_date,
            interval row_number() over (
                order by order_date
            ) day
        ) as group_id
    from distinct_dates
),
streaks as (
    select
        min(order_date) as streak_start,
        max(order_date) as streak_end,
        count(*) as number_of_days
    from date_groups
    group by group_id
)
select *
from streaks
order by number_of_days desc
limit 1;

# 6.For each day, calculate the day's revenue and the cumulative (running) revenue up to that day.
with daily_revenue as (
	select o.order_date,
			sum(p.price*od.quantity) as revenue
    from pizzas p inner join order_details od
    on p.pizza_id=od.pizza_id
    inner join orders o 
    on o.order_id=od.order_id
    group by o.order_date
)
select dr.order_date,
		dr.revenue,
        sum(dr.revenue) over(order by  dr.order_date 
        rows between unbounded preceding and current row) as cumulative_revenue
from daily_revenue dr;

# 7.Find the busiest hour of the day and show what percentage of all orders were placed during that hour.
with orders_per_hour as(
select hour(o.order_time)as 'hour',
		count(distinct o.order_id) as total_orders
from orders o 
group by hour(o.order_time)
),
hour_stats as (
    select
        hour,
        total_orders,
        round(
            total_orders /
            sum(total_orders) over () * 100,
            2
        ) as percentage_contribution
    from orders_per_hour
)
select *
from hour_stats
order by total_orders desc
limit 1;

# 8.Find the month-over-month revenue growth percentage.
with monthly_revenue as (
	select month(o.order_date) as month_number, # month_number hoga ye
			monthname(o.order_date) as `month`,
			sum(p.price*od.quantity) as revenue
    from pizzas p inner join order_details od
    on p.pizza_id=od.pizza_id inner join
    orders o on o.order_id=od.order_id
    group by monthname(o.order_date),month(o.order_date)
    order by month(o.order_date) asc
)
select mr.month,
		mr.revenue,
        lag(mr.revenue) over(order by mr.month_number) as prev_month_revenue,
        round((mr.revenue - lag(mr.revenue) over(order by mr.month_number))/lag(mr.revenue) over(order by mr.month_number) *100,2) as percentage_growth
from monthly_revenue mr;

# 9.Find the percentage of orders that contain more than 3 pizzas.
with pizzas_per_order as (
	select o.order_id as `id`,
			sum(od.quantity) as total_pizzas
    from orders o inner join order_details od
    on o.order_id=od.order_id
    group by o.order_id
)
select sum( if(ppo.total_pizzas>3,1,0)) as no_of_large_orders,
		count(*) as total_orders,
        round(sum( if(ppo.total_pizzas>3,1,0))/
        count(*) *100,2) as percentage
from pizzas_per_order ppo;

# 10.Find the first and last order of each day, along with the time difference between them.
with first_last_order as (
	select o.order_date,
		min(o.order_time) as first_order_time,
        max(o.order_time) as last_order_time
    from orders o
    group by o.order_date
)
select flo.order_date,
		flo.first_order_time,
        flo.last_order_time,
        timestampdiff(hour,flo.first_order_time,flo.last_order_time) as hours_difference
from first_last_order flo;

# 11.Find the average time between consecutive orders for each day.
with prev_time as (
	select o.order_date,
			o.order_time,
			lag(o.order_time) over(partition by o.order_date order by o.order_time) as prev_order_time
    from orders o
),
sec_bwn_consecutive_orders as (
	select pt.order_date,
			pt.order_time,
			pt.prev_order_time,
		timestampdiff(second,pt.prev_order_time,pt.order_time) as gap_in_sec
    from prev_time pt
)
select sbco.order_date,
		avg(sbco.gap_in_sec)/60.0 as average_min_btw_orders
from sec_bwn_consecutive_orders sbco
group by sbco.order_date;

# 12.Find the busiest day of the week based on the total number of orders. If multiple days tie, return all of them.
with orders_per_day as(
	select dayname(o.order_date) as 'day',
			count(*) as total_orders
    from orders o 
    group by dayname(o.order_date)
),
ranked_days_by_orders_per_day as (
	select *,
			dense_rank() over(order by total_orders desc) as 'rank'
    from orders_per_day as opd
)
select * from
ranked_days_by_orders_per_day t
where t.rank=1;

# 13.Find the top 3 dates that generated the highest revenue, and for each of those dates also show the total number of orders placed.
with revenue_per_day as (
    select
        o.order_date,
        sum(p.price * od.quantity) as revenue,
        count(distinct o.order_id) as total_orders
    from orders o
    join order_details od
        on o.order_id = od.order_id
    join pizzas p
        on od.pizza_id = p.pizza_id
    group by o.order_date
),
ranked_days as (
    select
        order_date,
        revenue,
        total_orders,
        dense_rank() over (
            order by revenue desc
        ) as `rank`
    from revenue_per_day
)
select
    order_date,
    revenue,
    total_orders
from ranked_days
where `rank` <= 3
order by revenue desc;

# 14.Find the dates on which the average order value was higher than the overall average order value.
with avg_order_value_per_date as (
	select o.order_date,
			round(sum(p.price*od.quantity)/count(distinct o.order_id),2) as date_avg_value
    from pizzas p inner join order_details od
    on p.pizza_id=od.pizza_id
    inner join orders o on o.order_id=od.order_id
    group by o.order_date
)
select * 
from avg_order_value_per_date t
where t.date_avg_value>(
	select round(sum(p.price*od.quantity)/count(distinct o.order_id),2) as avg_value
    from pizzas p inner join order_details od
    on p.pizza_id=od.pizza_id
    inner join orders o on o.order_id=od.order_id
    );

# 15.Find the date on which the restaurant generated the highest revenue per hour of operation.
with daily_stats as (
    select
        o.order_date,
        sum(p.price * od.quantity) as revenue,
        min(o.order_time) as first_order_time,
        max(o.order_time) as last_order_time
    from orders o
    join order_details od
        on o.order_id = od.order_id
    join pizzas p
        on od.pizza_id = p.pizza_id
    group by o.order_date
),
efficiency as (
    select
        order_date,
        revenue,
        first_order_time,
        last_order_time,
        round(
            time_to_sec(
                timediff(last_order_time, first_order_time)
            ) / 3600,
            2
        ) as active_hours,
        round(
            revenue /
            (
                time_to_sec(
                    timediff(last_order_time, first_order_time)
                ) / 3600
            ),
            2
        ) as revenue_per_hour
    from daily_stats
),
ranked_days as (
    select *,
           dense_rank() over (
               order by revenue_per_hour desc
           ) as `rank`
    from efficiency
)
select
    order_date,
    revenue,
    active_hours,
    revenue_per_hour
from ranked_days
where `rank` = 1;


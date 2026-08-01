use pizza_sales_project;

# 1.Daily sales summary
create view daily_sales_summary as
select
    o.order_date,
    count(distinct o.order_id) as total_orders,
    round(sum(p.price * od.quantity),2) as revenue
from orders o
inner join order_details od
    on o.order_id = od.order_id
inner join pizzas p
    on od.pizza_id = p.pizza_id
group by o.order_date;

# 2.Pizza performance view
create view pizza_performance as
select
    pt.name as pizza_name,
    pt.category,
    sum(od.quantity) as total_quantity_sold,
    round(sum(p.price * od.quantity), 2) as total_revenue
from pizza_types pt
inner join pizzas p
    on pt.pizza_type_id = p.pizza_type_id
inner join order_details od
    on p.pizza_id = od.pizza_id
group by
    pt.pizza_type_id,
    pt.name,
    pt.category;
    
# 3.Monthly sales summary
create view monthly_sales_summary as
select
    month(o.order_date) as month_no,
    monthname(o.order_date) as month_name,
    count(distinct o.order_id) as total_orders,
    round(sum(p.price * od.quantity), 2) as total_revenue
from orders o
inner join order_details od
    on o.order_id = od.order_id
inner join pizzas p
    on od.pizza_id = p.pizza_id
group by
    month(o.order_date),
    monthname(o.order_date);
    
# 4. Category Performance
create view category_performance as
select
    pt.category,
    count(distinct pt.pizza_type_id) as total_pizza_types,
    sum(od.quantity) as total_quantity_sold,
    round(sum(p.price * od.quantity), 2) as total_revenue
from pizza_types pt
inner join pizzas p
    on pt.pizza_type_id = p.pizza_type_id
inner join order_details od
    on p.pizza_id = od.pizza_id
group by
    pt.category;

# 5. Order Summary view
create view order_summary as
select
    o.order_id,
    o.order_date,
    sum(od.quantity) as total_pizzas,
    round(sum(p.price * od.quantity), 2) as total_bill
from orders o
inner join order_details od
    on o.order_id = od.order_id
inner join pizzas p
    on od.pizza_id = p.pizza_id
group by
    o.order_id,
    o.order_date;
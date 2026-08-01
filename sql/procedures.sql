use pizza_sales_project;

# 1.Get All Orders of a Particular Date
delimiter $$
create procedure get_orders_by_date(
    in p_order_date date
)
begin
    select *
    from orders
    where order_date = p_order_date;

end $$
delimiter ;
call get_orders_by_date('2015-01-15');

# 2.revenue between two dates
delimiter $$
create procedure get_revenue_between_dates(
    in p_start_date date,
    in p_end_date date
)
begin
    select
        round(sum(p.price * od.quantity), 2) as total_revenue
    from pizzas p
    inner join order_details od
        on p.pizza_id = od.pizza_id
    inner join orders o
        on o.order_id = od.order_id
    where o.order_date between p_start_date and p_end_date;

end $$
delimiter ;
call get_revenue_between_dates('2015-01-01', '2015-03-31');

# 3.orders above a given bill amount
delimiter $$
create procedure get_orders_above_bill(
    in p_min_bill decimal(10,2)
)
begin
    with bill_per_order as (
        select
            o.order_id,
            o.order_date,
            round(sum(p.price * od.quantity), 2) as total_bill
        from orders o
        inner join order_details od
            on o.order_id = od.order_id
        inner join pizzas p
            on od.pizza_id = p.pizza_id
        group by
            o.order_id,
            o.order_date
    )
    select *
    from bill_per_order
    where total_bill > p_min_bill
    order by total_bill desc;
end $$
delimiter ;
call get_orders_above_bill(40);

# 4.category wise revenue report
delimiter $$
create procedure category_revenue_report()
begin
    select
        pt.category,
        round(sum(p.price * od.quantity), 2) as revenue
    from pizza_types pt
    inner join pizzas p
        on pt.pizza_type_id = p.pizza_type_id
    inner join order_details od
        on p.pizza_id = od.pizza_id
    group by pt.category
    order by revenue desc;
end $$
delimiter ;
call category_revenue_report();

# 5.pizza sales by category
delimiter $$
create procedure get_pizza_sales_by_category(
    in p_category varchar(20)
)
begin
    select
        pt.name as pizza_name,
        sum(od.quantity) as total_quantity_sold,
        round(sum(p.price * od.quantity), 2) as revenue
    from pizza_types pt
    inner join pizzas p
        on pt.pizza_type_id = p.pizza_type_id
    inner join order_details od
        on p.pizza_id = od.pizza_id
    where pt.category = p_category
    group by
        pt.pizza_type_id,
        pt.name
    order by total_quantity_sold desc;
end $$
delimiter ;
call get_pizza_sales_by_category('classic');

# 6.get revenue by category (with validation)
delimiter $$
create procedure get_category_revenue(
    in p_category varchar(20)
)
begin
    if exists (
        select 1
        from pizza_types
        where category = p_category
    ) then
        select
            pt.category,
            round(sum(p.price * od.quantity), 2) as revenue
        from pizza_types pt
        inner join pizzas p
            on pt.pizza_type_id = p.pizza_type_id
        inner join order_details od
            on p.pizza_id = od.pizza_id
        where pt.category = p_category
        group by pt.category;

    else
        select 'invalid category' as message;
    end if;
end $$
delimiter ;
call get_category_revenue('banana');

# 7.total revenue using out parameter
delimiter $$
create procedure get_total_revenue(
    out p_total_revenue decimal(10,2)
)
begin
    select round(sum(p.price * od.quantity), 2)
    into p_total_revenue
    from pizzas p
    inner join order_details od
        on p.pizza_id = od.pizza_id;
end $$
delimiter ;
set @revenue = 0;
call get_total_revenue(@revenue);
select @revenue;

# 8.update pizza price
delimiter $$
create procedure update_pizza_price(
    in p_pizza_id varchar(30),
    in p_new_price decimal(5,2)
)
begin
    update pizzas
    set price = p_new_price
    where pizza_id = p_pizza_id;
    if row_count() > 0 then
        select 'price updated successfully' as message;
    else
        select 'pizza id not found' as message;
    end if;
end $$
delimiter ;
call update_pizza_price('bbq_ckn_l', 22.50);
-- we can add validations in procedurs while updation




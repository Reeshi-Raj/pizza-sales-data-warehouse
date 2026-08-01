use pizza_sales_project;

# 1.Prevent invalid quantity
delimiter $$
create trigger check_quantity_before_insert
before insert
on order_details
for each row
begin
    if new.quantity <= 0 then
        signal sqlstate '45000'
        set message_text = 'quantity must be greater than zero';
    end if;
end $$
delimiter ;

# 2.prevent invalid price update
delimiter $$
create trigger check_price_before_update
before update
on pizzas
for each row
begin
    if new.price <= 0 then
        signal sqlstate '45000'
        set message_text = 'price must be greater than zero';
    end if;
end $$
delimiter ;

# 3.audit new orders
create table order_audit(

    audit_id int auto_increment primary key,

    order_id int,

    action_type varchar(20),

    action_time datetime
);
delimiter $$
create trigger log_new_order
after insert
on orders
for each row
begin
    insert into order_audit(
        order_id,
        action_type,
        action_time
    )
    values(
        new.order_id,
        'insert',
        now()
    );
end $$
delimiter ;

# 4.maintain pizza price history
create table pizza_price_history(
    history_id int auto_increment primary key,
    pizza_id varchar(30),
    old_price decimal(5,2),
    new_price decimal(5,2),
    updated_at datetime
);
delimiter $$
create trigger log_price_change
after update
on pizzas
for each row
begin
    if old.price != new.price then
        insert into pizza_price_history(
            pizza_id,
            old_price,
            new_price,
            updated_at
        )
        values(
            old.pizza_id,
            old.price,
            new.price,
            now()
        );
    end if;
end $$
delimiter ;

# 5.prevent deleting pizzas that are used in orders
delimiter $$
create trigger prevent_pizza_delete
before delete
on pizzas
for each row
begin
    if exists (
        select 1
        from order_details
        where pizza_id = old.pizza_id
    ) then
        signal sqlstate '45000'
        set message_text = 'cannot delete pizza because it exists in order history';
    end if;
end $$
delimiter ;

# 6.backup deleted orders
create table deleted_orders(
    backup_id int auto_increment primary key,
    order_id int,
    order_date date,
    order_time time,
    deleted_at datetime
);
delimiter $$
create trigger backup_deleted_order
after delete
on orders
for each row
begin
    insert into deleted_orders(
        order_id,
        order_date,
        order_time,
        deleted_at
    )
    values(
        old.order_id,
        old.order_date,
        old.order_time,
        now()
    );
end $$
delimiter ;






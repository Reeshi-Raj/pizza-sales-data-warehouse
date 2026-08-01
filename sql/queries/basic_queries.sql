/*
=====================================================
Project : Pizza Sales Analysis
File    : 01_basic.sql

Description:
Basic Business Analysis Queries
=====================================================
*/
USE pizza_sales_project;

# 1.The restaurant owner wants to know how many orders have been placed till date.
SELECT COUNT(*) AS total_orders
FROM orders;

# 2.How many pizzas were sold in total?
SELECT SUM(quantity) AS total_pizzas_sold
FROM order_details;

# 3.What is the total revenue generated?
SELECT ROUND(SUM(od.quantity * p.price),2) AS total_revenue
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id;

# 4.what is the average order value ?
SELECT ROUND(
    SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id),
    2
) AS average_order_value
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id;

# 5. List of all availabe pizza categories
SELECT DISTINCT category
FROM pizza_types;

# 6. total pizza types available
select count(pizza_type_id) as total_types
from pizza_types pt;

# 7. Most expensive pizza on the menu
SELECT pt.name,
       pt.category,
       p.price
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
WHERE p.price = (
    SELECT MAX(price)
    FROM pizzas
);

# 8. cheapest pizzas on the menu
SELECT pt.name,
       pt.category,
       p.price
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
WHERE p.price = (
    SELECT MIN(price)
    FROM pizzas
);

# 9. Show distribution of sizes of available pizzas on menu
select pizzas.size,
		count(pizzas.pizza_id) as total_pizzas
from pizzas
group by pizzas.size;

# 10. Find the total number of orders placed on each day.
select o.order_date,
		count(*) as total_orders
from orders o
group by o.order_date
order by o.order_date asc;
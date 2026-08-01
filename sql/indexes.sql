USE pizza_sales_project;

CREATE INDEX idx_orders_date
ON orders(order_date);

CREATE INDEX idx_order_details_order
ON order_details(order_id);

CREATE INDEX idx_order_details_pizza
ON order_details(pizza_id);

CREATE INDEX idx_pizzas_type
ON pizzas(pizza_type_id);

CREATE INDEX idx_pizza_types_category
ON pizza_types(category);

SHOW INDEX FROM orders;

SHOW INDEX FROM order_details;

SHOW INDEX FROM pizzas;

SHOW INDEX FROM pizza_types;
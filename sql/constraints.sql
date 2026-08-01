USE pizza_sales_project;

ALTER TABLE pizzas
ADD CONSTRAINT fk_pizzas_pizza_types
FOREIGN KEY (pizza_type_id)
REFERENCES pizza_types(pizza_type_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_pizzas
FOREIGN KEY (pizza_id)
REFERENCES pizzas(pizza_id);
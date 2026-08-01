USE pizza_sales_project;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL
);

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(30) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(30) NOT NULL,
    ingredients TEXT NOT NULL
);

CREATE TABLE pizzas (
    pizza_id VARCHAR(30) PRIMARY KEY,
    pizza_type_id VARCHAR(30) NOT NULL,
    size CHAR(2) NOT NULL,
    price DECIMAL(5,2) NOT NULL
);

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_id VARCHAR(30) NOT NULL,
    quantity INT NOT NULL
);
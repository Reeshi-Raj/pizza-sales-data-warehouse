\# Pizza Sales Data Warehouse using MySQL



\## Project Report



\### 1. Introduction



The Pizza Sales Data Warehouse project is a SQL-based analytical system developed using MySQL. The objective of this project is to analyze transactional sales data from a pizza restaurant and generate meaningful business insights using advanced SQL concepts.



The project demonstrates how relational databases can be used not only for storing transactional data but also for performing business intelligence and decision-making tasks. Instead of focusing only on writing SQL queries, this project emphasizes solving practical business problems such as revenue analysis, sales reporting, customer order analysis, inventory insights, and automated database operations.



Throughout the project, several advanced SQL features such as Common Table Expressions (CTEs), Window Functions, Stored Procedures, User Defined Functions, Views, Triggers, and Indexes have been implemented to simulate real-world database development practices.



\---



\# 2. Objectives



The primary objectives of this project are:



\* Design a normalized relational database for pizza sales.

\* Import and manage transactional sales data using MySQL.

\* Perform analytical queries to extract business insights.

\* Build reusable SQL components using Views, Stored Procedures, and Functions.

\* Implement database automation using Triggers.

\* Optimize query execution using Indexes.

\* Create a structured SQL project suitable for portfolio and interview demonstrations.



\---



\# 3. Dataset Description



The project uses four relational tables.



\## orders



Stores information about every customer order.



| Column     | Description                    |

| ---------- | ------------------------------ |

| order\_id   | Unique order identifier        |

| order\_date | Date of the order              |

| order\_time | Time when the order was placed |



\---



\## order\_details



Stores the individual pizzas included in each order.



| Column           | Description              |

| ---------------- | ------------------------ |

| order\_details\_id | Unique row identifier    |

| order\_id         | Associated order         |

| pizza\_id         | Ordered pizza            |

| quantity         | Number of pizzas ordered |



\---



\## pizzas



Contains pricing and size information for every pizza.



| Column        | Description                   |

| ------------- | ----------------------------- |

| pizza\_id      | Unique pizza identifier       |

| pizza\_type\_id | Pizza category reference      |

| size          | Pizza size (S, M, L, XL, XXL) |

| price         | Selling price                 |



\---



\## pizza\_types



Contains descriptive information about pizza varieties.



| Column        | Description           |

| ------------- | --------------------- |

| pizza\_type\_id | Pizza type identifier |

| name          | Pizza name            |

| category      | Pizza category        |

| ingredients   | Ingredients used      |



\---



\# 4. Database Schema



The database consists of four related tables connected through primary key and foreign key relationships.



Relationship Summary:



\* One Pizza Type can have multiple Pizza Sizes.

\* One Pizza can appear in multiple Order Details.

\* One Order can contain multiple Order Details.



The database schema follows normalization principles and minimizes data redundancy.



\---



\# 5. SQL Features Implemented



The project demonstrates a wide range of SQL concepts.



\## Basic SQL



\* Filtering

\* Sorting

\* Aggregate Functions

\* Group By

\* Having

\* Joins



\## Intermediate SQL



\* Subqueries

\* Correlated Subqueries

\* Common Table Expressions (CTEs)

\* Window Functions

\* Ranking Functions



\## Advanced SQL



\* Running Totals

\* Revenue Analysis

\* Monthly Growth Analysis

\* Customer Order Analysis

\* Time-based Analytics



\## Database Programming



\* Stored Procedures

\* User Defined Functions

\* Views

\* Triggers



\## Performance Optimization



\* Index Creation

\* Query Optimization



\---



\# 6. Business Insights Generated



The project answers several practical business questions, including:



\* Which pizza generates the highest revenue?

\* Which pizza category performs best?

\* Which month records the highest sales?

\* What is the average value of customer orders?

\* How many pizzas are sold per order?

\* Which hours experience the highest sales activity?

\* How does monthly revenue change over time?

\* Which days generate above-average revenue?

\* Which products contribute the most to total sales?



These insights help management understand customer behavior, identify profitable products, and improve business decision-making.



\---



\# 7. Database Automation



The project includes several database automation features.



\## Stored Procedures



Stored procedures were created for reusable business operations such as reporting, filtering, and analytical calculations.



\## User Defined Functions



Functions were developed for reusable calculations including order revenue, loyalty points, discount calculations, and billing logic.



\## Triggers



Triggers automatically perform validation, auditing, history maintenance, and backup operations whenever data is inserted, updated, or deleted.



\---



\# 8. Project Outcomes



By completing this project, the following SQL concepts were practiced:



\* Relational Database Design

\* Data Import

\* Complex SQL Queries

\* Window Functions

\* Common Table Expressions

\* Views

\* Stored Procedures

\* User Defined Functions

\* Triggers

\* Indexing

\* Query Optimization



The project also improved problem-solving skills by converting real business requirements into SQL solutions.



\---



\# 9. Future Improvements



The project can be extended by integrating:



\* Power BI Dashboard

\* Tableau Dashboard

\* Python Data Analysis

\* Sales Forecasting

\* Customer Segmentation

\* Inventory Prediction

\* Web-based Reporting Dashboard



These enhancements would transform the project into a complete Business Intelligence solution.



\---



\# 10. Conclusion



This project demonstrates how MySQL can be used to solve real-world business problems through efficient database design and advanced SQL programming. By combining analytical queries with reusable database objects such as Views, Stored Procedures, Functions, and Triggers, the project provides a scalable and maintainable solution for restaurant sales analysis.



Overall, the project serves as a comprehensive demonstration of SQL development skills and showcases practical database concepts commonly used in industry.




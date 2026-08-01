\# Business Problems Solved



This document summarizes the real business problems addressed in this project and the SQL techniques used to solve them.



| Business Problem                                      | SQL Feature Used                | Business Value                                                   |

| ----------------------------------------------------- | ------------------------------- | ---------------------------------------------------------------- |

| Find the pizzas generating the highest revenue        | Aggregate Functions, GROUP BY   | Identifies the most profitable products.                         |

| Calculate revenue contribution of each pizza category | GROUP BY, Joins                 | Helps management understand category-wise performance.           |

| Identify the busiest ordering hours                   | Date \& Time Functions, GROUP BY | Assists in staff scheduling and resource planning.               |

| Analyze monthly revenue trends                        | CTEs, Window Functions (LAG)    | Measures month-over-month business growth.                       |

| Find days with above-average order value              | Aggregate Functions, Subqueries | Identifies high-performing business days.                        |

| Calculate average time gap between consecutive orders | CTEs, Window Functions          | Measures customer ordering frequency during operating hours.     |

| Identify large customer orders                        | Conditional Aggregation         | Helps analyze bulk ordering behavior.                            |

| Find months with the lowest number of orders          | CTEs, Ranking Functions         | Detects periods with low customer demand.                        |

| Generate daily sales summary                          | Views                           | Provides a reusable reporting layer for daily business analysis. |

| Generate monthly sales summary                        | Views                           | Simplifies monthly reporting and dashboard creation.             |

| Generate pizza performance reports                    | Views                           | Provides sales and revenue information for every pizza.          |

| Generate category-wise performance reports            | Views                           | Compares sales across pizza categories.                          |

| Calculate order revenue                               | User Defined Functions          | Eliminates repeated revenue calculations across queries.         |

| Calculate total pizzas in an order                    | User Defined Functions          | Provides reusable order-level metrics.                           |

| Calculate customer loyalty points                     | User Defined Functions          | Demonstrates reusable business logic for customer rewards.       |

| Calculate final bill after discount                   | User Defined Functions          | Implements billing calculations using reusable functions.        |

| Validate order quantity before insertion              | BEFORE INSERT Trigger           | Prevents invalid business data from entering the database.       |

| Validate pizza price before update                    | BEFORE UPDATE Trigger           | Ensures product prices remain valid.                             |

| Maintain audit records for newly inserted orders      | AFTER INSERT Trigger            | Automatically logs important database activities.                |

| Maintain pizza price history                          | AFTER UPDATE Trigger            | Preserves historical pricing information for analysis.           |

| Prevent deletion of pizzas used in previous orders    | BEFORE DELETE Trigger           | Protects historical transactional data.                          |

| Backup deleted orders                                 | AFTER DELETE Trigger            | Prevents accidental loss of important order records.             |

| Generate reusable business reports                    | Stored Procedures               | Reduces repetitive SQL code and improves maintainability.        |

| Improve query execution speed                         | Indexes                         | Optimizes performance for frequently executed queries.           |



\---



\## Overall Business Impact



The implemented SQL solutions help answer practical business questions related to sales analysis, product performance, revenue tracking, operational efficiency, and data integrity.



The project demonstrates how SQL can be used not only for querying data but also for automating business rules, improving performance, and building reusable reporting components commonly used in real-world database systems.




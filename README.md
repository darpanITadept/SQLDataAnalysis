Certainly, here are all the SQL queries from your project's README.md:

```markdown
# SQL Data Analysis and Reporting System

![Project Logo](project_logo.png)

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

...

## Usage

To use this SQL Data Analysis and Reporting System, follow these steps:

1. Navigate to the relevant SQL solution in the repository based on your data analysis requirements.

2. Copy the SQL query from the README or the provided `.sql` file.

3. Paste the query into your SQL client and execute it against your database.

4. Review the results and generate insightful reports from your data.

5. Customize the queries as needed for your specific use case.

Here are all the SQL queries from the project:

### Solution 1: Display employee information hired in September

```sql
SELECT
   employee_id AS "Employee Number",
   last_name || ', ' || first_name AS "Full Name",
   job_title,
   to_char(hire_date, '"["Month ddth "of" YYYY"]"') AS "START DATE" 
FROM
   employees 
WHERE
   hire_date <= '30-09-16' 
   AND hire_date >= '01-09-16' 
ORDER BY
   hire_date DESC;
```

### Solution 2: Total sale amount per salesperson

```sql
SELECT
   NVL(o.salesman_id, 0) AS "Employee Number",
   to_char(round(SUM(i.quantity*i.unit_Price), 2), '$99,999,999.99') AS "Total_Sale" 
FROM
   orders o 
   INNER JOIN
      order_items i 
      ON o.order_id = i.order_id 
GROUP BY
   o.salesman_id 
ORDER BY
   o.salesman_id;
```

### Solution 3: Total number of orders per customer in the range 35-45

```sql
SELECT
   c.CUSTOMER_ID AS "Customer Id",
   c.NAME,
   NVL(COUNT(ORDER_ID), 0) AS "Total Orders" 
FROM
   CUSTOMERS c 
   LEFT JOIN
      ORDERS o 
      ON c.CUSTOMER_ID = o.CUSTOMER_ID 
WHERE
   c.CUSTOMER_ID >= 35 
   AND c.customer_id <= 45 
GROUP BY
   c.CUSTOMER_ID,
   c.NAME 
ORDER BY
   COUNT(order_id);
```

### Solution 4: Orders and order details for customer ID 44

```sql
SELECT
   c.CUSTOMER_ID AS "Customer Id",
   c.NAME,
   o.ORDER_ID,
   to_char(o.order_date, 'DD"-"Mon"-"YY'),
   SUM(quantity) AS "Total Items",
   to_char(round(SUM(i.quantity*i.unit_Price), 2), '$9,999,999.99') AS "Total Amount" 
FROM
   CUSTOMERS c 
   INNER JOIN
      ORDERS o 
      ON c.CUSTOMER_ID = o.CUSTOMER_ID 
   INNER JOIN
      order_items i 
      ON o.order_id = i.order_id 
WHERE
   c.CUSTOMER_ID = 44 
GROUP BY
   c.customer_id,
   c.name,
   o.order_id,
   o.order_date 
ORDER BY
   SUM(QUANTITY * UNIT_PRICE) DESC;
```

### Solution 5: Total orders, items, and amount for customers with over 30 orders

```sql
SELECT
   c.customer_id,
   c.name,
   COUNT(i.item_id) AS "Total Number OF Orders",
   SUM(quantity) AS "Total Items",
   to_char(round(SUM(i.quantity*i.unit_Price), 2), '$9,999,999.99') AS "Total Amount" 
FROM
   customers c 
   INNER JOIN
      orders o 
      ON c.customer_id = o.customer_id 
   INNER JOIN
      order_items i 
      ON o.order_id = i.order_id 
GROUP BY
   c.name,
   c.customer_id 
HAVING
   COUNT(i.order_id) > 30 
ORDER BY
   COUNT(i.item_id);
```

### Solution 6: Lowest product standard cost by warehouse and category

```sql
SELECT
   i.warehouse_id AS "Warehouse ID",
   w.warehouse_name AS "Warehouse Name",
   c.category_id AS "Category ID",
   c.category_name AS "Category Name",
   TO_CHAR(round(MIN(p.standard_cost), 2), '$999.99') AS "Lowest Cost" 
FROM
   warehouses w 
   INNER JOIN
      inventories i 
      ON w.warehouse_id = i.warehouse_id 
   INNER JOIN
      products p 
      ON i.product_id = p.product_id 
   INNER JOIN
      product_categories c 
      ON p.category_id = c.category_id 
GROUP BY
   i.warehouse_id,
   w.warehouse_name,
   c.category_id,
   c.category_name 
HAVING
   MIN(p.standard_cost) NOT BETWEEN 200 AND 500 
ORDER BY
   i.warehouse_id,
   w.warehouse_name,
   c.category_id,
   c.category_name;
```

### Solution 7: Total number of orders per month

```sql
SELECT
   to_char(ORDER_DATE, 'MONTH') AS "MONTH",
   COUNT(ORDER_ID) 
FROM
   ORDERS 
GROUP BY
   EXTRACT(MONTH 
FROM
   ORDER_DATE),
   to_char(ORDER_DATE, 'MONTH') 
ORDER BY
   EXTRACT(MONTH 
FROM
   ORDER_DATE);
```

### Solution 8: Products with list price higher than highest standard cost by warehouse

```sql
SELECT
   p1.product_id "Product ID",
   p1.product_name "Product Name",
   TO_CHAR((round(p1.list_price, 2)), '$9,999.99') "Price" 
FROM
   products p1 
WHERE
   p1.list_price > ANY(
   SELECT
      MAX(p2.standard_cost) 
   FROM
      products p2 
      INNER JOIN
         inventories i 
         ON p2.product_id = i.product_id 
      INNER JOIN
         warehouses w 
         ON i.warehouse_id = w.warehouse_id 
      INNER JOIN
         locations l 
         ON w.location_id = l.location_id 
      INNER JOIN
         countries c 
         ON l.country_id = c.country_id 
      INNER JOIN
         regions r 
         ON c.region_id = r.region_id 
   WHERE
      UPPER (r.region_name) != 'AMERICA' 
   GROUP BY
      w.warehouse_id) 
   ORDER BY
      TO_CHAR((round(p1.list_price, 2)), '$9,999.99') DESC;
```

### Solution 9: Most expensive and cheapest products by list price

```sql
SELECT
   PRODUCT_ID,
   PRODUCT_NAME,
   to_char((round(LIST_PRICE, 2)), '$9,999.99') as "Price"
FROM
   PRODUCTS 
WHERE
   LIST_PRICE = 
   (
      SELECT
         MAX(MAX_PRICE) 
      FROM
         (
            SELECT
               MAX(LIST_PRICE) AS MAX_PRICE 
            FROM
               PRODUCTS 
            GROUP BY
               PRODUCT_ID 
         )
   )
   OR LIST_PRICE = 
   (
      SELECT
         MIN(MIN_PRICE) 
      FROM
         (
            SELECT
               MIN(LIST_PRICE) AS MIN_PRICE 
            FROM
               PRODUCTS 
            GROUP BY
               PRODUCT_ID 
         )
   )
;

```markdown
### Solution 10: Customer Purchase Amount Statistics

```sql
-- Number of customers with total purchase amount over the average
SELECT
   COUNT(*) AS "Customers with Purchase Amount > Average"
FROM
   (
      SELECT
         c.customer_id 
      FROM
         customers c 
         INNER JOIN
            orders o 
            ON c.customer_id = o.customer_id 
         INNER JOIN
            order_items oi 
            ON oi.order_id = o.order_id 
      GROUP BY
         c.customer_id 
      HAVING
         SUM(oi.quantity * oi.unit_price) > (
         SELECT
            AVG(oi.quantity * oi.unit_price) 
         FROM
            order_items oi
         )
   ) AS over_avg

UNION ALL

-- Number of customers with total purchase amount below the average
SELECT
   COUNT(*) AS "Customers with Purchase Amount < Average"
FROM
   (
      SELECT
         c.customer_id 
      FROM
         customers c 
         INNER JOIN
            orders o 
            ON c.customer_id = o.customer_id 
         INNER JOIN
            order_items oi 
            ON oi.order_id = o.order_id 
      GROUP BY
         c.customer_id 
      HAVING
         SUM(oi.quantity * oi.unit_price) < (
         SELECT
            AVG(oi.quantity * oi.unit_price) 
         FROM
            order_items oi
         )
   ) AS under_avg

UNION ALL

-- Total number of customers
SELECT
   COUNT(*) AS "Total Customers"
FROM
   customers;
```

These queries provide statistics on customer purchase amounts, including the number of customers with purchase amounts above and below the average, as well as the total number of customers.

## Contributing

Contributions are welcome! If you have any SQL solutions or improvements to existing ones, please feel free to submit a pull request. Make sure to follow the project's coding standards and documentation guidelines.

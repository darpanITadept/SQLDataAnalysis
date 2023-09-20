--BEGIN
--*******************************************************************************
--Question 1--
--Display the employee number, full employee name, job title,
--and hire date of all employees hired in September with the most recently
--hired employees displayed first. 

--Solution 1--
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

-----------------------------------------------------------------------------------------

--Question 2--
--The company wants to see the total sale amount per sales person (salesman)
--for all orders. Assume that online orders do not have any sales representative.
--For online orders (orders with no salesman ID), consider the salesman ID as 0.
--Display the salesman ID and the total sale amount for each employee. 
--Sort the result according to employee number.

--Solution 2--
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

-----------------------------------------------------------------------------------------

--Question 3--
--Display customer Id, customer name and total number of orders
--for customers that the value of their customer ID is in values from 35 to 45. 
--Include the customers with no orders in your report if their customer ID falls 
--in the range 35 and 45.  
--Sort the result by the value of total orders. 

--Solution 3--
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

-----------------------------------------------------------------------------------------

--Question 4--
--Display customer ID, customer name, and the order ID and the order
--date of all orders for customer whose ID is 44.

--a.)Show also the total quantity and the total amount of each customer�s order.
--b.)Sort the result from the highest to lowest total order amount.

--Solution 4--
SELECT
   c.CUSTOMER_ID AS"Customer Id",
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
   SUM(QUANTITY * UNIT_PRICE)DESC ;

-----------------------------------------------------------------------------------------

--Question 5--
--5.Display customer Id, name, total number of orders, the total number of items
--ordered, and the total order amount for customers who have more than 30 orders.
--Sort the result based on the total number of orders.

--Solution 5--
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

-----------------------------------------------------------------------------------------

--Question 6--
--Display Warehouse Id, warehouse name, product category Id, product category name,
--and the lowest product standard cost for this combination.
--� In your result, include the rows that the lowest standard cost is less then $200.
--�   Also, include the rows that the lowest cost is more than $500.
--�   Sort the output according to Warehouse Id, warehouse name and then product category Id,
--  and product category name.

--Solution 6--
SELECT
   i.warehouse_id AS "Warehouse ID",
   w.warehouse_name AS "Warehouse Name",
   c.category_id AS "Category ID",
   c.category_name AS "Category Name",
   TO_CHAR(round(MIN(p.standard_cost), 2), '$999.99')AS "Lowest Cost" 
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

-----------------------------------------------------------------------------------------

--Question 7--
--Display the total number of orders per month. Sort the result from January to December.

--Solution 7--
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

-----------------------------------------------------------------------------------------

--Question 8--
--Display product Id, product name for products that their list price is more
--than any highest product standard cost per warehouse outside Americas regions.
--(You need to find the highest standard cost for each warehouse that is located 
--outside the Americas regions. Then you need to return all products that their
--list price is higher than any highest standard cost of those warehouses.)
--Sort the result according to list price from highest value to the lowest.

--Solution 8--
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
      
-----------------------------------------------------------------------------------------

--Question 9--
--Write a SQL statement to display the most expensive and the cheapest product (list price).
--Display product ID, product name, and the list price.

--Solution 9--
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

-----------------------------------------------------------------------------------------

--Question 10--
--Write a SQL query to display the number of customers with total order amount
--over the average amount of all orders, the number of customers with total order 
--amount under the average amount of all orders, number of customers with no orders,
--and the total number of customers.
--See the format of the following result.

--Solution 10--
SELECT
   * 
FROM
   (
      SELECT
         'Number of customers with total purchase amount over average: ' || COUNT(*) as "Customer Report"
      FROM
         (
            SELECT
(c.customer_id) 
            FROM
               customers c 
               INNER JOIN
                  orders o 
                  ON c.customer_id = o.customer_id 
               INNER JOIN
                  order_items c 
                  ON c.order_id = o.order_id 
            GROUP BY
               c.customer_id 
            HAVING
               SUM(c.quantity*c.unit_price) > (
               SELECT
                  AVG(quantity*unit_price) 
               FROM
                  order_items)
         )
   )
   
UNION ALL

SELECT
   'Number of customers with total purchase amount below average: ' || COUNT(*) as "Customer Report"
FROM
   (
      SELECT
(a.customer_id) 
      FROM
         customers A 
         INNER JOIN
            orders o 
            ON c.customer_id = o.customer_id 
         INNER JOIN
            order_items c 
            ON c.order_id = o.order_id 
      GROUP BY
         c.customer_id 
      HAVING
         SUM(c.quantity * c.unit_price) < (
         SELECT
            AVG (quantity * unit_price) 
         FROM
            order_items)
   )
   
UNION ALL

SELECT
   'Total number of customers: ' || COUNT(*) as "Customer Report"
FROM
   customers;
-----------------------------------------------------------------------------------------

--*******************************************************************************
--END OF THE ASSIGNMENT
--THANK YOU!!!

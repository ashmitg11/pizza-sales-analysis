/* Pizza Sales Project sql
Author: Ashmit Gupta */

# 1. Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

# 2. Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

# 3. Identify the highest-priced pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

# 4. Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

# 5. List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

# 6. Join the necessary tables to find the total quantity of each pizza category ordered

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;


# 7. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id)
FROM
    orders AS order_count
GROUP BY HOUR(order_time);

# 8 Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    CATEGORY, COUNT(NAME)
FROM
    PIZZA_TYPES
GROUP BY CATEGORY;

# 9. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(TOTAL_QUANTITY), 0) AS AVG_PIZZA_ORDERED_PER_DAY
FROM 
    (SELECT ORDERS.ORDER_DATE, 
            SUM(ORDER_DETAILS.QUANTITY) AS TOTAL_QUANTITY
        FROM ORDERS
        JOIN ORDER_DETAILS ON ORDERS.ORDER_ID = ORDER_DETAILS.ORDER_ID
        GROUP BY ORDERS.ORDER_DATE) AS ORDER_QUANTITY;

# 10. Determine the top 3 most ordered pizza types based on revenue

SELECT PIZZA_TYPES.NAME, 
SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE 
FROM pizza_types JOIN PIZZAS 
ON PIZZAS.PIZZA_TYPE_ID = PIZZA_TYPES.PIZZA_TYPE_ID 
JOIN ORDER_DETAILS 
ON ORDER_DETAILS.PIZZA_ID =PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.NAME ORDER BY REVENUE DESC LIMIT 3 ;

 # 11. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                    SUM(order_details.quantity * pizzas.price)
                FROM order_details
				JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100,2) AS revenue_percentage
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue_percentage DESC;

# 12. Analyze the cumulative revenue generated over time.

SELECT ORDER_DATE,
SUM(REVENUE) OVER(ORDER BY ORDER_DATE) AS CUM_REVENUE 
FROM 
(select orders.order_date,
sum(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE
FROM order_details JOIN PIZZAS
ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
JOIN ORDERS
ON ORDERS.ORDER_ID = ORDER_DETAILS.ORDER_ID
GROUP BY ORDERS.ORDER_DATE ) AS SALES ;

# 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.


SELECT NAME, REVENUE 
FROM
(SELECT CATEGORY,NAME,REVENUE,
RANK()OVER (PARTITION BY CATEGORY ORDER BY REVENUE DESC) AS RN 
FROM
(SELECT PIZZA_TYPES.CATEGORY, PIZZA_TYPES.NAME,
SUM((ORDER_DETAILS.QUANTITY)* PIZZAS.PRICE )AS REVENUE
FROM PIZZA_TYPES JOIN PIZZAS
ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
JOIN order_details
ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.CATEGORY,PIZZA_TYPES.NAME ) AS A) AS B
WHERE RN <= 3 ;


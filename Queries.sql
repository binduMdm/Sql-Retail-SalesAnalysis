-- Customers
SELECT top 5 * FROM customers 
-- Orders
SELECT top 5 * FROM orders 
-- Order Items
SELECT * FROM order_items 
-- Products
SELECT * FROM products 
-- Categories
SELECT * FROM categories 

-- Check NULLs in customers
SELECT COUNT(*) AS null_names FROM customers WHERE customer_name IS NULL;
SELECT COUNT(*) AS null_city FROM customers WHERE city IS NULL;

-- Check NULLs in orders
SELECT COUNT(*) AS null_amounts FROM orders WHERE total_amount IS NULL;

-- Duplicate customers
SELECT customer_id, COUNT(*) 
FROM customers 
GROUP BY customer_id 
HAVING COUNT(*) > 1;

-- Duplicate orders
SELECT order_id, COUNT(*) 
FROM orders 
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- Orders without a valid customer
SELECT o.*
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT 
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.city,
    p.product_name,
    cat.category_name,
    oi.quantity,
    oi.item_price,
    (oi.quantity * oi.item_price) AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id;

--Top 5 Categories by Revenue
SELECT 
    cat.category_name,
    SUM(oi.quantity * oi.item_price) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY total_revenue DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
---The Land and Understand categories dominate sales, suggesting high-performing product lines that can be prioritized for promotions or restocking.

----Monthly Revenue Trend
SELECT 
    FORMAT(o.order_date, 'yyyy-MM') AS month,
    SUM(oi.quantity * oi.item_price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY FORMAT(o.order_date, 'yyyy-MM')
ORDER BY month;
--Peak sales months: Nov 2024, Sep 2024, Oct 2024 – possibly driven by holidays or promotions.
--Lowest month: May 2025, which may indicate an off-season or drop in customer engagement.

--City-wise Total Revenue
SELECT 
    c.city,
    SUM(oi.quantity * oi.item_price) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.city
ORDER BY total_revenue DESC;
--New Tannerville is the highest-earning city. This city could be prioritized for marketing or inventory expansion.
--Top 5 cities contribute significantly to the business revenue. Regional focus may boost efficiency.
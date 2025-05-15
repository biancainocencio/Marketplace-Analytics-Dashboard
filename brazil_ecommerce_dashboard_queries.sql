
-- Average review score for late orders
WITH late_orders AS (
    SELECT DISTINCT o.order_id
    FROM `abi_data.orders` o
    WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
),
late_order_reviews AS (
    SELECT r.review_score
    FROM `abi_data.reviews` r
    JOIN late_orders lo ON r.order_id = lo.order_id
    WHERE r.review_score IS NOT NULL
)
SELECT AVG(review_score) AS avg_review_score_for_late_orders
FROM late_order_reviews;


-- Repeat Purchase Rate (Overall)
WITH customer_order_counts AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM `abi_data.customers` c
    JOIN `abi_data.orders` o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),
repeat_customers AS (
    SELECT COUNT(customer_unique_id) AS repeat_customers
    FROM customer_order_counts
    WHERE total_orders > 1
),
total_customers AS (
    SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
    FROM `abi_data.customers`
)
SELECT (r.repeat_customers * 100.0 / t.total_customers) AS repeat_purchase_rate
FROM repeat_customers r, total_customers t;


-- Average Revenue per Customer
SELECT 
    (SUM(oi.price) / COUNT(DISTINCT c.customer_unique_id)) AS avg_revenue_per_customer
FROM `abi_data.customers` c
JOIN `abi_data.orders` o ON c.customer_id = o.customer_id
JOIN `abi_data.order_items` oi ON o.order_id = oi.order_id;


-- On-time Delivery Rate
WITH approved_orders AS (
    SELECT order_id, order_delivered_customer_date, order_estimated_delivery_date
    FROM `abi_data.orders`
    WHERE order_status != "canceled"
      AND order_delivered_customer_date IS NOT NULL 
      AND order_estimated_delivery_date IS NOT NULL
),
on_time_deliveries AS (
    SELECT COUNT(order_id) AS on_time_orders
    FROM approved_orders
    WHERE order_delivered_customer_date <= order_estimated_delivery_date
),
total_approved_orders AS (
    SELECT COUNT(order_id) AS total_count
    FROM approved_orders
)
SELECT (ot.on_time_orders * 100.0 / t.total_count) AS percent_on_time_deliveries
FROM on_time_deliveries ot, total_approved_orders t;

-- Additional queries omitted in this snippet for brevity...
-- Full script in the output file

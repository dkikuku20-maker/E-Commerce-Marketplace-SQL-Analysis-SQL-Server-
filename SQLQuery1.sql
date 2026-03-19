-- we check the total revenue
SELECT SUM(payment_value) AS total_revenue
FROM payments;

--then we check revenue by payment type
SELECT 
	payment_type,
	SUM(payment_value) AS total_revenue
FROM payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- then we need to check payment count by payment type
SELECT 
	payment_type,
	COUNT(*) AS number_of_payments
FROM payments
GROUP BY payment_type
ORDER BY number_of_payments DESC;

SELECT * 
FROM payments;
--we then check average payment by payment type
SELECT 
	payment_type,
	ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM payments
GROUP BY payment_type
ORDER BY avg_payment_value DESC;

--we check then high valued paymemts
SELECT *
FROM payments
WHERE payment_value > (
	SELECT AVG(payment_value)
	FROM payments
);

--the next is about installemnt analysis
SELECT 
	payment_installments,
	COUNT(*) AS number_of_payments,
	SUM(payment_value) AS total_revenue
FROM payments
GROUP BY payment_installments 
ORDER BY payment_installments DESC;

SELECT 
	payment_type,
	COUNT(*)*100.0/ (SELECT COUNT(*) FROM payments) AS payment_percentage
FROM payments
GROUP BY payment_type
ORDER BY payment_percentage DESC;

-- we showing the payment method and the price asociated with each order
-- we use oi = order_items tble and p = payments table
SELECT 
	oi.order_id,
	oi.price,
	p.payment_type,
	p.payment_value

FROM order_items oi
JOIN payments p
ON oi.order_id = p.order_id;

-- some of the tables failed to load, so we are focusing on the part of the business i can analyze
-- next we check what are the top 10 largest payments on the platform
SELECT TOP 10
	payment_value,
	payment_type,
	payment_installments
FROM payments
ORDER BY payment_value DESC;

-- we then check average number of installments customers use 
SELECT
	AVG(payment_installments) AS avg_installments
FROM payments;

-- the average payment amount for each number of installments

SELECT payment_installments,
	AVG(payment_value) AS avg_payment
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- Lets check the percentage of payments that are made in full 
SELECT
	ROUND(COUNT(*)* 100.0 / (SELECT COUNT(*) FROM payments), 2) AS full_payment_percentage
FROM payments
WHERE payment_installments = 1;

--we check which payments method are most used for high value payments 
SELECT
	payment_type,
	COUNT(*) AS number_of_high_payments
FROM payments
WHERE payment_value > 500
GROUP BY payment_type
ORDER BY number_of_high_payments DESC;

-- Which payment methods bring in the most revenue from high-value payments

SELECT
	payment_type,
	SUM(payment_value) AS total_revenue
FROM payments
WHERE payment_value > 500
GROUP BY payment_type
ORDER BY total_revenue DESC;


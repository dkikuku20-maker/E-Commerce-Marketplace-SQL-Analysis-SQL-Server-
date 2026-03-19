SELECT * 
FROM sellers

-- Check which seller generated more revenue
-- FOR EACH SELLER , how much total rev did they generate
--Break the data into groups, then calculate something for each group
SELECT
	seller_id,
	SUM(price) AS total_rev
FROM order_items
GROUP BY seller_id
ORDER BY total_rev DESC;

-- which sellers charge the highest average product price (how expensive their items are)

SELECT
	seller_id,
	AVG(price) AS total_rev
FROM order_items
GROUP BY seller_id
ORDER BY total_rev DESC;

--which sellers have both high rev and high average price 
SELECT
	seller_id,
	SUM(price) AS tota_revenue,
	AVG(price) AS avg_price
FROM order_items
GROUP BY seller_id
ORDER BY avg_price DESC;

-- we gonna show only sellers whose total rev is gretter than 1000,000

SELECT
	seller_id,
	SUM(price) AS total_revenue
FROM order_items
GROUP BY seller_id
HAVING SUM(price) > 100000
ORDER BY total_revenue DESC;

-- who is our high performing sellers 

SELECT 
	seller_id,
	SUM(price) AS TOTAL_REV,
	AVG(price) AS AVG_PRICE
FROM order_items
GROUP BY seller_id
HAVING SUM(price) > 100000 AND AVG(price) > 200
ORDER BY TOTAL_REV DESC, AVG_PRICE DESC;

-- WHICH SELLERS CHARGE THE HIGHEST FREIGH COST
-- WE use avg because we want to see which sellers charge higher shipping per order on avg
-- not just who has the highest shipping
SELECT 
	seller_id,
	AVG(freight_value) AS AVG_FREIGHT
FROM order_items
GROUP BY seller_id
ORDER BY AVG_FREIGHT DESC;

---Show the top 10 sellers with the highest average freight cost
--BUT only include sellers who have at least 50 orders
SELECT TOP 10
    seller_id,
    COUNT(*) AS number_of_orders,
    AVG(freight_value) AS avg_freight
FROM order_items
GROUP BY seller_id
HAVING COUNT(*) >= 50
ORDER BY avg_freight DESC;
-- WHICH STATE HAS THE MOST CUSTOMERS

SELECT *
FROM customers
	
SELECT 
	customer_state,
	customer_city,
	COUNT(*) AS MOST_CUSTOMERS
FROM customers
GROUP BY customer_state, customer_city
ORDER BY MOST_CUSTOMERS DESC;

--what is the distribution of review scores

SELECT * 
FROM reviews

SELECT 
	review_score,
	COUNT(*) AS reviews_count
FROM reviews
GROUP BY review_score
ORDER BY reviews_count DESC;

-- WHAT PERCENTAGE OF REVIEWS ARE 1-STAR, 2-STAR , ETC
SELECT 
	review_score,
	COUNT(*) AS reviews_count,
	COUNT(*) * 100.0/ (SELECT COUNT(*) FROM reviews) AS percentage
FROM reviews
GROUP BY review_score
ORDER BY review_score;

-- lets find sellers associated with bad reviews 
-- since we dont have every table working , we can not prove causation perfevtly
-- we will find which sellers apppear most often on orders with bad reviews
-- reviews -> order_id <- order_items

SELECT
    oi.seller_id,
    COUNT(*) AS bad_review_count
FROM reviews r
JOIN order_items oi
    ON r.order_id = oi.order_id
WHERE r.review_score <= 2
GROUP BY oi.seller_id
ORDER BY bad_review_count DESC;

-- which sellers have the highest percentage of bad reviews

SELECT
    oi.seller_id,
    COUNT(CASE WHEN r.review_score <= 2 THEN 1 END) AS bad_reviews,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN r.review_score <= 2 THEN 1 END) * 100.0 / COUNT(*) AS bad_review_percentage
FROM reviews r
JOIN order_items oi
    ON r.order_id = oi.order_id
GROUP BY oi.seller_id
ORDER BY bad_review_percentage DESC;
SELECT * FROM customer_analysis.customers limit 20;

-- Q1 What are the tottal revenue genrated by male and female customers?
SELECT gender , SUM(purchased_amount) AS 'total_revenue'
FROM customer_analysis.customers
GROUP BY gender ;

-- Q2 Which customers used a discount but still spent more than the average purchase amount ?
SELECT customer_id , purchased_amount
FROM customer_analysis.customers
WHERE discount_applied = 'YES' AND purchased_amount > (SELECT AVG(purchased_amount) FROM customer_analysis.customers) ;

-- Q3 Which is the top 5 products with the highest review ratings?
SELECT item_purchased , ROUND(AVG(review_rating),2) AS 'Avg_Product_Rating' 
FROM customer_analysis.customers
GROUP BY item_purchased
ORDER BY Avg_Product_rating DESC limit 5 ;

-- Q4 Compares the average purcahsed amount between standard and express shipping type?
SELECT shipping_type , ROUND(AVG(purchased_amount),2) AS 'Avg_purchased_amount'
FROM customer_analysis.customers
WHERE shipping_type in ('Standard' , 'Express') 
GROUP BY shipping_type ;


-- Q5 Do Subscriber customers spend more? compare average spend and total revenue between subscribers and non-subscriber?
SELECT subscription_status,
COUNT(subscription_status) AS 'Number' ,
ROUND(AVG(purchased_amount),2) AS 'avg_spend',
ROUND(SUM(purchased_amount)) AS 'total_revenue'
FROM customer_analysis.customers
GROUP BY subscription_status
ORDER BY avg_spend AND total_revenue DESC ;

-- Q6 Which 5 product have the heighest percentage of purchases with discounts applied?
-- (means which product heavily rely on discount)
SELECT item_purchased,
ROUND((SUM(CASE WHEN discount_applied = 'YES' THEN 1 ELSE 0 END) / COUNT(*)) *100 , 2) AS 'discount_rate'
FROM customer_analysis.customers
GROUP BY item_purchased
ORDER BY discount_rate DESC limit 5 ;

-- Q7 Segment customers into new ,Returning, and loyal based on their total number of previous-
-- purchases and show the count of each segment
 WITH customer_type AS (
			SELECT customer_id , previous_purchases,
            CASE
				WHEN previous_purchases = 1 THEN 'New'
                WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
                ELSE 'Loyal'
                END AS customer_segement
			FROM customer_analysis.customers
            )
SELECT customer_segement, COUNT(*) AS 'Number Of Customers'
FROM customer_type
GROUP BY customer_segement ;

-- Q what are the top 3 most purchased product within each category?
WITH item_counts AS (
		SELECT category, item_purchased,
        COUNT(customer_id) AS 'total_orders',
        ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS 'item_rank'
        FROM customer_analysis.customers
        GROUP BY category, item_purchased
        )
SELECT item_rank , category , item_purchased , total_orders
FROM item_counts
WHERE item_rank <= 3 ;

-- Q Are customer who are repeat buyers(more thean 5 previous purchases) also likely to subscribe ?
SELECT subscription_status,
COUNT(customer_id) AS 'repaet_buyers'
FROM customer_analysis.customers
WHERE previous_purchases > 5 
GROUP BY subscription_status ;

-- Q What is the revenue contribution of each age group ?
SELECT age_group,
SUM(purchaseD_amount) AS 'total_revenue'
FROM customer_analysis.customers
GROUP BY age_group
ORDER BY total_revenue DESC ; 
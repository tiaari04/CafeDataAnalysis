SELECT *
FROM cafe_staging;

/* Find which product sold the most in total */
SELECT item, SUM(quantity) as sum_quantity, SUM(total_spent) as sum_total
FROM cafe_staging
WHERE item IS NOT NULL
GROUP BY item
ORDER BY sum_quantity DESC;


/* Monthly ranks of item sold */
SELECT *
FROM cafe_staging
WHERE transaction_date IS NOT NULL
ORDER BY transaction_date DESC;

SELECT item, SUM(quantity) as sum_quantity, 
	SUBSTRING(transaction_date::text FROM 6 FOR 2) as transaction_month
FROM cafe_staging
WHERE item IS NOT NULL AND quantity IS NOT NULL AND 
	transaction_date IS NOT NULL
GROUP BY item, transaction_month
ORDER BY transaction_month ASC, sum_quantity DESC;

WITH sold_by_month AS (
	SELECT item, SUM(quantity) as sum_quantity, 
		SUBSTRING(transaction_date::text FROM 6 FOR 2) as transaction_month
	FROM cafe_staging
	WHERE item IS NOT NULL AND quantity IS NOT NULL AND 
		transaction_date IS NOT NULL
	GROUP BY item, transaction_month
)
SELECT item, sum_quantity, transaction_month, 
	DENSE_RANK() OVER(PARTITION BY transaction_month
	ORDER BY sum_quantity DESC) ranking
FROM sold_by_month
ORDER BY transaction_month, ranking;


/* Top 3 items sold each month, quantity sold, and total earned per product */
WITH sold_by_month AS (
	SELECT item, SUM(quantity) as sum_quantity, SUM(total_spent) AS sum_total,
		SUBSTRING(transaction_date::text FROM 6 FOR 2) as transaction_month
	FROM cafe_staging
	WHERE item IS NOT NULL AND quantity IS NOT NULL AND 
		transaction_date IS NOT NULL AND total_spent IS NOT NULL
	GROUP BY item, transaction_month
),
monthly_ranking AS (
	SELECT item, sum_quantity, sum_total, transaction_month, 
		DENSE_RANK() OVER(PARTITION BY transaction_month
		ORDER BY sum_quantity DESC) ranking
	FROM sold_by_month
)
SELECT *
FROM monthly_ranking
WHERE ranking <= 3;


/* How much was earned from takeaway vs in store orders */
SELECT cafe_staging.location, SUM(total_spent)
FROM cafe_staging
WHERE cafe_staging.location IS NOT NULL
GROUP BY cafe_staging.location;


/* How much was earned from takeaway vs in store orders by item */
WITH purchase_location AS (
	SELECT cafe_staging.location p_location, item, SUM(total_spent) total
	FROM cafe_staging
	GROUP BY cafe_staging.location, item
)
SELECT *
FROM purchase_location
WHERE p_location IS NOT NULL AND item IS NOT NULL AND total IS NOT NULL
ORDER BY item, p_location;


/* Total sales in each month */
SELECT SUBSTRING(transaction_date::text FROM 6 FOR 2) transaction_month, SUM(total_spent) total
FROM cafe_staging
WHERE transaction_date IS NOT NULL AND total_spent IS NOT NULL
GROUP BY transaction_month
ORDER BY transaction_month ASC;


/* Rolling total by month */
WITH rolling_total AS (
	SELECT SUBSTRING(transaction_date::text FROM 6 FOR 2) transaction_month, SUM(total_spent) total
	FROM cafe_staging
	WHERE total_spent IS NOT NULL AND transaction_date IS NOT NULL
	GROUP BY transaction_month
)
SELECT transaction_month, total, SUM(total) OVER(ORDER BY transaction_month)
FROM rolling_total;
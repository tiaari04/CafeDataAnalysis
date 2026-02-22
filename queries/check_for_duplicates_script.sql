/* Checked for duplicates*/

SELECT *, ROW_NUMBER() OVER(
PARTITION BY transaction_id, item, quantity, price_per_unit, 
total_spent, payment_method, c.location, transaction_date) as row_num
FROM cafe_staging c
ORDER BY row_num DESC;

WITH dup_cte AS (
SELECT *, ROW_NUMBER() OVER(
PARTITION BY transaction_id) as row_num
FROM cafe_staging c
)
SELECT *
FROM dup_cte
WHERE row_num > 1;


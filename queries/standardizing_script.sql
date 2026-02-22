/* Standardizing Data and Updating NULLs and Emptys*/

SELECT *
FROM cafe_staging;

DELETE FROM cafe_staging
WHERE transaction_id = 'Transaction ID';

/* Check if any transaction_ids are incorrectly formatted */
SELECT *
FROM cafe_staging
WHERE transaction_id NOT LIKE 'TXN_%'
ORDER BY transaction_id;

/* Change 'UNKNOWN' AND 'ERROR' to NULL */
SELECT *
FROM cafe_staging
WHERE (item LIKE 'UNKNOWN' OR item LIKE 'ERROR')
OR (quantity LIKE 'UNKNOWN' OR quantity LIKE 'ERROR')
OR (price_per_unit LIKE 'UNKNOWN' OR price_per_unit LIKE 'ERROR')
OR (total_spent LIKE 'UNKNOWN' OR total_spent LIKE 'ERROR')
OR (payment_method LIKE 'UNKNOWN' OR payment_method LIKE 'ERROR')
OR (cafe_staging.location LIKE 'UNKNOWN' OR cafe_staging.location LIKE 'ERROR')
OR (transaction_date LIKE 'UNKNOWN' OR transaction_date LIKE 'ERROR');

UPDATE cafe_staging
SET item = NULL
WHERE (item LIKE 'UNKNOWN' OR item LIKE 'ERROR');

SELECT *
FROM cafe_staging
WHERE item LIKE 'UNKNOWN' OR item LIKE 'ERROR';

UPDATE cafe_staging
SET quantity = NULL
WHERE (quantity LIKE 'UNKNOWN' OR quantity LIKE 'ERROR');

UPDATE cafe_staging
SET price_per_unit = NULL
WHERE (price_per_unit LIKE 'UNKNOWN' OR price_per_unit LIKE 'ERROR');

UPDATE cafe_staging
SET total_spent = NULL
WHERE (total_spent LIKE 'UNKNOWN' OR total_spent LIKE 'ERROR');

UPDATE cafe_staging
SET payment_method = NULL
WHERE (payment_method LIKE 'UNKNOWN' OR payment_method LIKE 'ERROR');

UPDATE cafe_staging
SET location = NULL
WHERE (cafe_staging.location LIKE 'UNKNOWN' OR cafe_staging.location LIKE 'ERROR');

UPDATE cafe_staging
SET transaction_date = NULL
WHERE (transaction_date LIKE 'UNKNOWN' OR transaction_date LIKE 'ERROR');

/* SET NULL transaction_date values to '1901-01-01' and set type to date*/
SELECT *
FROM cafe_staging
WHERE transaction_date IS NULL;

ALTER TABLE cafe_staging
ALTER COLUMN transaction_date SET DATA TYPE date
USING transaction_date::date;

SELECT *
FROM cafe_staging
WHERE transaction_date = '1901-01-01';

/* Alter quantity table to smallint*/
ALTER TABLE cafe_staging
ALTER COLUMN quantity SET DATA TYPE smallint
USING quantity::smallint;

/* Alter price_per_unit table to real*/
ALTER TABLE cafe_staging
ALTER COLUMN price_per_unit SET DATA TYPE real
USING price_per_unit::real;

/* Alter total_spent table to real*/
ALTER TABLE cafe_staging
ALTER COLUMN total_spent SET DATA TYPE real
USING total_spent::real;

/* Update total_spent based on quantity and price_per_unit */
SELECT quantity, price_per_unit, total_spent, (quantity * price_per_unit) AS new_total
FROM cafe_staging
WHERE total_spent IS NULL AND quantity IS NOT NULL AND price_per_unit IS NOT NULL;

UPDATE cafe_staging
SET total_spent = quantity * price_per_unit
WHERE total_spent IS NULL AND quantity IS NOT NULL AND price_per_unit IS NOT NULL;

/* Update quantity based on total_spent and price_per_unit */
SELECT quantity, price_per_unit, total_spent, (total_spent / price_per_unit) AS new_quantity
FROM cafe_staging
WHERE quantity IS NULL AND total_spent IS NOT NULL AND price_per_unit IS NOT NULL;

UPDATE cafe_staging
SET quantity = total_spent / price_per_unit
WHERE quantity IS NULL AND total_spent IS NOT NULL AND price_per_unit IS NOT NULL;

/* Update price_per_unit based on total_spent and quantity */
SELECT quantity, price_per_unit, total_spent, (total_spent / quantity) AS new_price_per_unit
FROM cafe_staging
WHERE price_per_unit IS NULL AND total_spent IS NOT NULL AND quantity IS NOT NULL;

UPDATE cafe_staging
SET price_per_unit = total_spent / quantity
WHERE price_per_unit IS NULL AND total_spent IS NOT NULL AND quantity IS NOT NULL;

/* Update NULL items if possible*/
SELECT item, AVG(price_per_unit) price
FROM cafe_staging
GROUP BY item
ORDER BY price;

SELECT *
FROM cafe_staging
WHERE price_per_unit = 1 AND item IS NULL;

UPDATE cafe_staging
SET item = CASE
	WHEN price_per_unit = 1 AND item IS NULL THEN 'Cookie'
	WHEN price_per_unit = 1.5 AND item IS NULL THEN 'Tea'
	WHEN price_per_unit = 2 AND item IS NULL THEN 'Coffee'
	WHEN price_per_unit = 5 AND item IS NULL THEN 'Salad'
	ELSE item 
END
WHERE item IS NULL;

SELECT price_per_unit, AVG(price_per_unit)
FROM cafe_staging
WHERE item IS NULL
GROUP BY price_per_unit;


CREATE TABLE cafe_staging
(LIKE cafe_data);

INSERT INTO cafe_staging
SELECT * 
FROM cafe_data;

SELECT * 
FROM cafe_staging;
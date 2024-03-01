-- Provide list of all customers, with their first name, last name and e-mail address.
SELECT
	first_name,
	last_name,
	LOWER(email)
FROM 
	customer

-- Order customer list by last name starting from A to Z. If last name is the same, 
-- order it by first name in same order.
SELECT
	first_name,
	last_name,
	LOWER(email)
FROM 
	customer
ORDER BY 
	last_name ASC, 
	first_name ASC

-- Create a list of all districts customers are from. 
SELECT DISTINCT
	district
FROM 
	address
ORDER BY 
	district ASC

-- What is the latest rental date? 
SELECT DISTINCT
	DATE(rental_date) as date 
FROM 
	rental
ORDER BY 
	date DESC
LIMIT 1

-- How many films does company have? 
SELECT 
	COUNT (*)
FROM 
	film 

-- How many distinct last names of the customers are there? 
SELECT 
	COUNT (DISTINCT last_name)
FROM 
	customer 

-- How many payments where made by the customer with id 100?
SELECT 
	COUNT(*)
FROM 
	payment
WHERE 
	customer_id = 100

-- What rental have not been returned yet? 
SELECT 
	*
FROM 
	rental
WHERE 
	return_date IS NULL

-- Provide list of all the payment_ids with an amount less than or equal to 2$.
SELECT 
	payment_id,
	amount
FROM 
	payment
WHERE
	amount <= 2
ORDER BY 
	amount ASC

-- Provide list of all the payments of the customer 322, 346 and 354 where the amount
-- is either less than 2$ or greater than 10$. It should be ordered by 
-- the customer (ascending) and as second condition order by amount in descending order.
SELECT 
	*
FROM 
	payment
WHERE 
	customer_id IN (322, 346, 354)
	AND
	(amount < 2 OR amount > 10)
ORDER BY 
	customer_id ASC,
	amount DESC

-- How many payments have been made on January 26th and January 27th 2020 witn an amount
-- between 1,99$ and 3,99$.
SELECT 
	COUNT(*)
FROM 
	payment
WHERE 
	payment_date BETWEEN '2020-01-26' AND '2020-01-27 23:59'
	AND
	amount BETWEEN 1.99 AND 3.99

-- There have been 6 complaints of customers about their payments
-- customer_id: 12, 25, 67, 93, 124, 234
-- The concerned payments are all the payments of these customers with amounts 4,99$, 7,99$ 
-- and 9,99$ in January 2020.
SELECT 
	*
FROM 
	payment
WHERE 
	customer_id IN (12, 25, 67, 93, 124, 234)
	AND
	amount IN (4.99, 7.99, 9.99)
	AND 
	DATE(payment_date) BETWEEN '2020-01-01' AND '2020-01-31'

-- How many customers are there with a first name that is 3 letters long and either an 'X'
-- or 'Y' as the last letter in the last name? 
SELECT 
	*
FROM 
	customer 
WHERE 
	LENGTH(first_name) = 3
	AND 
	(last_name LIKE '%X' OR last_name LIKE '%Y')
	
-- What is the maximum, minimum, average(rounded) and sum of the replacement 
-- cost of the films?
SELECT 
	MIN(replacement_cost) AS min_rep_cost,
	MAX(replacement_cost) AS max_rep_cost,
	ROUND(AVG(replacement_cost), 2) AS avg_rep_cost,
	SUM(replacement_cost) AS total_rep_cost
FROM 
	film

-- Which employee is responsible for more payments? 
-- Which is responsible for a higher overall payment? 
SELECT
	staff_id,
	COUNT(*) AS payment_count,
	SUM(amount) AS total_amount
FROM 
	payment
WHERE 
	amount != 0
GROUP BY 
	staff_id
ORDER BY 
	total_amount DESC

-- Which employee had the highest sales amount in a single day? 
SELECT 
	staff_id,
	DATE(payment_date),
	SUM(amount) AS total_amount
FROM 
	payment
GROUP BY 
	staff_id, DATE(payment_date)
ORDER BY 
	total_amount DESC

-- Which employee had the most sales in a single day (not counting zero payments)?
SELECT 
	staff_id,
	DATE(payment_date),
	COUNT(amount) AS payment_count
FROM 
	payment
WHERE 
	amount != 0
GROUP BY 
	staff_id, DATE(payment_date)
ORDER BY 
	payment_count DESC

-- In 2020, April 28, 29 and 30 were days with very high revenue. Find out what is 
-- the average payment amount grouped by cusomer and day - consider only the days/customers
-- with more than 1 payment (per customer and day).
-- Order by the average amount in descending order. 
SELECT
	customer_id,
	DATE(payment_date), 
	ROUND(AVG(amount), 2),
	COUNT(*)
FROM 
	payment
WHERE 
	DATE(payment_date) IN ('2020-04-28', '2020-04-29', '2020-04-30')
GROUP BY 
	customer_id, DATE(payment_date)
HAVING 
	COUNT(*) > 1
ORDER BY 
	AVG(amount) DESC
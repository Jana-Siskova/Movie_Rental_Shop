-- The email address always ends with '.org'
-- How can you extract just '.' from email address? 
SELECT 
	LEFT(RIGHT(email, 4), 1)
FROM 
	customer

-- Create anonymized version of the email addresses.
-- It should be the first character followed by '***' and then the last part starting with '@'.
-- Note the email always ends with '@sakilacustomer.org'
SELECT 
	email,
	LEFT(email, 1) 
	|| '***' 
	|| RIGHT(email, 19)
FROM 
	customer

-- In this challenge you have only the email address and the last name of the customers.
-- You need to extract the first name from the email address and concatenate it with
-- the last name. It should be in the form: 'Last name, First name'
SELECT 
	email, 
	last_name,
	last_name 
	|| ', ' 
	|| LEFT(email, POSITION('.' in email) - 1)
FROM 
	customer 
	
-- Create anonymized version of email address in the following way: 
-- M***.S***@sakilacustomer.org
SELECT 
	email,
	LEFT(email, 1) 
	|| '***'
	|| SUBSTRING(email FROM POSITION('.' in email) for 2)
	|| '***'
	|| SUBSTRING(email FROM POSITION('@' in email))
FROM 
	customer

-- What is the month with the highest total payment amount? 

SELECT 
	EXTRACT(MONTH from payment_date) AS date_month,
	SUM(amount) AS total_amount
FROM 
	payment
GROUP BY 
	date_month
ORDER BY 
	total_amount DESC

-- Sum payments and group in the following formats:
-- 'Fri, 24/01/2020'
-- 'May, 2020'
-- 'Thu, 02:44'
SELECT
	SUM(amount),
	--TO_CHAR(payment_date, 'Dy, DD/MM/YY') as first_var,
	--TO_CHAR(payment_date, 'Mon, YYYY') as second_var
	TO_CHAR(payment_date, 'Dy, HH24:MI') as third_var
FROM 
	payment
GROUP BY
	third_var

-- Create a list of all rental durations of customer with id 35.
SELECT 
	customer_id,
	return_date - rental_date
FROM 
	rental
WHERE
	customer_id = 35

-- Which customer has the longest average rental duration?
SELECT
	customer_id,
	AVG(return_date - rental_date) AS rental_duration
FROM 
	rental
GROUP BY
	customer_id
ORDER BY
	rental_duration DESC
LIMIT 1

-- Create a list of films including the relation of rental rate and replacement cost
-- where the rental rate is less than 4% of the replacement cost.
-- Create a list of that film ids together with percentage rounded to two decimal places.
SELECT
	film_id,
	ROUND((rental_rate/replacement_cost) * 100, 2) AS rental_replacement_ratio
FROM 
	film
WHERE 
	ROUND((rental_rate/replacement_cost) * 100, 2) < 4
ORDER BY 
	rental_replacement_ratio

-- Create a tier list in the following way:
-- 1. Rating is 'PG' or 'PG-13' or length is more than 21Omin: 'Great rating or longer (tier 1)'
-- 2. Description contains 'Drama' and length is more than 90min: 'Long drama (tier 2)'
-- 3. Description contains 'Drama' and length is no more than 90min: 'Short drama (tier 3)'
-- 4. Rental rate less than 1$: 'Very cheap (tier 4)'
-- If one movie can be in multiple categories it gets the higher tier assigned. 
-- Filter films that belong to one of there tiers
SELECT 
	title, 
	CASE
		WHEN rating IN ('PG', 'PG-13') OR length > 210 THEN 'Great rating or longer (tier 1)' 
		WHEN description LIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2)'
		WHEN description LIKE '%Drama%' AND length < 90 THEN 'Short drama (tier 3)'
		WHEN rental_rate < 1 THEN 'Very cheap (tier 4)'
	END AS tiers
FROM 
	film
WHERE 
	CASE
		WHEN rating IN ('PG', 'PG-13') OR length > 210 THEN 'Great rating or longer (tier 1)' 
		WHEN description LIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2)'
		WHEN description LIKE '%Drama%' AND length < 90 THEN 'Short drama (tier 3)'
		WHEN rental_rate < 1 THEN 'Very cheap (tier 4)'
	END IS NOT NULL

-- How many movies has ratings PG, PG-13, NC-17 and G? 
SELECT 
	rating,
	COUNT(*)
FROM 
	film
GROUP BY 
	rating

-- Replace null values in return_date column with 'not returned yet'
SELECT 
	rental_date,
	COALESCE(CAST(return_date AS VARCHAR), 'not returned yet')
FROM 
	rental
ORDER BY 
	rental_date DESC

-- Provide list of all customers (name, phone number, district) from Texas.
SELECT 
	first_name,
	last_name,
	phone,
	district
FROM 
	customer c
LEFT JOIN address a 
	ON c.address_id = a.address_id
WHERE 
	district = 'Texas'

-- Are there any (old) addresses that are not related to any customer? 
SELECT 
	*
FROM 
	address a 
LEFT JOIN customer c
	ON a.address_id = c.address_id
WHERE 
	customer_id IS NULL

-- Which customers are from Brazil? 
SELECT 
	first_name,
	last_name,
	email,
	country
FROM 
	customer c
INNER JOIN address a 
	ON c.address_id = a.address_id
INNER JOIN city city
	ON a.city_id = city.city_id
INNER JOIN country cy 
	ON city.country_id = cy.country_id
WHERE 
	country = 'Brazil'

-- Which title has George Linton rented most often? 
SELECT 
	title,
	COUNT(*) AS title_count
FROM 
	rental r 
INNER JOIN customer c
	ON r.customer_id = c.customer_id
INNER JOIN inventory i 
	ON r.inventory_id = i.inventory_id
INNER JOIN film f
	ON i.film_id = f.film_id
WHERE 
	first_name = 'GEORGE'
	AND 
	last_name = 'LINTON'
GROUP BY 
	title
ORDER BY 
	title_count DESC

	
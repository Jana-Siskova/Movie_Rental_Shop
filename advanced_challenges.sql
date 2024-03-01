-- Select all of the films where the length is longer than the average of films.
SELECT 
	*
FROM 
	film
WHERE
	length > (
		SELECT
			AVG(length)
		FROM 
			film)

-- Return all the films that are available in inventory in store 2 more than 3 times.
SELECT
	*
FROM 
	film
WHERE 
	film_id IN (
		SELECT 
			film_id
		FROM 
			inventory
		WHERE 
			store_id = 2
		GROUP BY 
			film_id
		HAVING 
			COUNT(*) > 3
	)

-- Return all customers first and last names that have made payment on '2020-01-25' 
SELECT 
	first_name,
	last_name
FROM 
	customer
WHERE 
	customer_id IN (
		SELECT 
			customer_id
		FROM 
			payment
		WHERE 
			DATE(payment_date) = '2020-01-25'
	)

-- Return all customers first names and email addresses that have spent more than 30$
SELECT
	first_name,
	email
FROM 
	customer
WHERE 
	customer_id IN (
		SELECT 
			customer_id
		FROM 
			payment
		GROUP BY 
			customer_id
		HAVING
			SUM(amount) > 30
	)

-- Return all the customers first and last name that are from California and have spent
-- more than 100 in total.
SELECT
	first_name,
	last_name
	email
FROM 
	customer c 
INNER JOIN 
	address a 
	ON c.address_id = a.address_id
WHERE 
	customer_id IN (
		SELECT 
			customer_id
		FROM 
			payment
		GROUP BY 
			customer_id
		HAVING
			SUM(amount) > 100
	)
	AND 
	district = 'California'

-- What is the average total amount spent per day? 
SELECT
	ROUND(AVG(amount_per_day), 2) AS avg_per_day
FROM 
	(
		SELECT 
			SUM(amount) AS amount_per_day
		FROM 
			payment
		GROUP BY
			DATE(payment_date)
	)

-- Show all the payments together with how much the payment amount is below the maximum
-- payment amount.
SELECT
	*,
	(
	SELECT 
		MAX(amount)
	FROM 
		payment
		) - amount AS difference
FROM 
	payment

-- Show only those movies titles, their associated film_id and replacement_cost with 
-- the lowest replacement_cost in each rating category - also show the rating.
SELECT 
	title,
	film_id,
	replacement_cost,
	rating
FROM 
	film f1
WHERE 
	replacement_cost = (
		SELECT 
			MIN(replacement_cost)
		FROM 
			film f2
		WHERE 
			f1.rating = f2.rating
		)

-- Show only those movie titles, their film_id and the length that have the highest length
-- in each rating category - also show the rating.
SELECT 
	title, 
	film_id,
	length,
	rating
FROM 
	film f1
WHERE 
	length = (
		SELECT 
			MAX(length)
		FROM 
			film f2
		WHERE 
			f1.rating = f2.rating
	)

-- Show all the payments plus the total amount of every customer as well as the number 
-- of payments of each customer. 
SELECT
	*,
	(
		SELECT
			SUM(amount)
		FROM 
			payment p2
		WHERE 
			p1.customer_id = p2.customer_id
			) AS total_amount,
	(
		SELECT
			COUNT(amount)
		FROM 
			payment p2
		WHERE 
			p1.customer_id = p2.customer_id
			) AS payment_count
FROM 
	payment p1
	
-- Show only those films with the highest replacement costs in their rating category
-- plus show the average replacement cost in their rating category.
SELECT 
	title,
	film_id,
	replacement_cost,
	(
	SELECT
		AVG(replacement_cost)
	FROM 
		film f1
	WHERE 
		f1.rating = f2.rating
		),
	rating
FROM 
	film f2
WHERE 
	replacement_cost = (
	SELECT
		MAX(replacement_cost)
	FROM 
		film f3
	WHERE 
		f2.rating = f3.rating
	)

-- Show only those payments with the highest payment for each customer including
-- the payment_id of that payment.
SELECT
	first_name,
	last_name,
	payment_id,
	amount
FROM 
	payment p1
INNER JOIN customer c
	ON p1.customer_id = c.customer_id
WHERE 
	amount = (
	SELECT
		MAX(amount)
	FROM 
		payment p2
	WHERE 
		p1.customer_id = p2.customer_id)


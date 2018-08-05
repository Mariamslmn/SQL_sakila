USE sakila;

-- 1-list of all the actors who have Display the first and last names of all actors from the table actor
SELECT first_name, last_name
FROM actor
WHERE first_name IS NOT NULL AND first_name IS NOT NULL;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name,' ' ,last_name) AS 'Actor Name'
FROM actor
WHERE first_name IS NOT NULL AND first_name IS NOT NULL;

-- 2a.You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information? 
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name , first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country, country_id
FROM country
WHERE country IN ('AFGHANISTAN', 'BANGLADESH', 'CHINA');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(30) NOT NULL AFTER first_name;
SELECT * FROM actor;

-- 3b.You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor MODIFY middle_name BLOB;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor DROP middle_name;
SELECT * FROM actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS 'count_by_lastname'
FROM actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS 'count_by_lastname'
FROM actor
group by last_name
HAVING COUNT(*) >= 2;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
SELECT * FROM actor  where last_name = 'WILLIAMS';

-- 4d. In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error

UPDATE actor 
SET first_name = CASE
WHEN first_name='HARPO' THEN  'GROUCHO'
ELSE'MUCHO GROUCHO'  END
WHERE last_name='WILLIAMS' AND first_name <> 'GROUCHO';


select first_name, last_name 
from actor
WHERE last_name='WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

-- Drops the "address" table if it exists currently --
DROP TABLE IF EXISTS address;

-- Creates the "address" table --
CREATE TABLE address(
  -- Creates a numeric column called "id" which will automatically increment its default value as we create new rows --
  address_id INTEGER(11) AUTO_INCREMENT NOT NULL,
  -- Makes a string column called "address" which cannot contain null --
  address VARCHAR(250)  NOT NULL,
  -- Makes a string column called "address2"--
  address2 VARCHAR(250),
  -- Makes a string column called "district" --
  district VARCHAR(50),
  -- a foreign key that references "city" table --
  city_id smallint(5) unsigned NOT NULL,
  -- Makes a numeric column called "postal_code" --
  postal_code INTEGER(20),
  -- Makes a numeric column called "phone" --
  phone INTEGER(20),
  -- Makes a BLOB column called "location" --
  location BLOB,
  -- Makes a timestamp column called "last_update" --
  last_update timestamp ,
  
  -- Sets id as this table's primary key which means all data contained within it will be unique --
  PRIMARY KEY (address_id),
  FOREIGN KEY (city_id) REFERENCES city(city_id)
);

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT first_name, last_name, address
FROM staff
JOIN address ON staff.staff_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
SELECT first_name, last_name, SUM(amount) As 'total_amount'
FROM payment
JOIN staff ON payment.staff_id = staff.staff_id 
where payment_date LIKE '%2005-08%'
group by first_name, last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT title, COUNT(*) AS 'actors_listed'
FROM film_actor
INNER JOIN film ON film_actor.film_id = film.film_id
group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system? --
SELECT title, (SELECT COUNT(*) FROM inventory WHERE film.film_id = inventory.film_id ) AS 'Number of Copies'
FROM film
WHERE title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount)
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY first_name, last_name
ORDER BY last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
    FROM film
    WHERE title LIKE "Q%" OR title LIKE "K%"
    AND language_id IN
    (
     SELECT language_id
     FROM language
     WHERE name = 'English'
     );

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip. --
SELECT first_name, last_name
    FROM actor
    WHERE actor_id IN
    (
     SELECT actor_id
	 FROM film_actor
	 WHERE film_id IN
	(
     SELECT film_id
	 FROM film
     WHERE title = 'Alone Trip'
	 )
	 );

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email, country
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON city.country_id = country.country_id
where country = "CANADA";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
JOIN film_category ON film.film_id= film_category.film_id
JOIN category ON film_category.category_id = category.category_id 
where name = "family";

-- 7e. Display the most frequently rented movies in descending order. --
SELECT title, count(rental_id)
FROM film
JOIN inventory ON film.film_id= inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id 
group by title
order by count(rental_id) desc;


-- 7f. Write a query to display how much business, in dollars, each store brought in.--
SELECT store.store_id, count(amount) AS 'business_in_dollars'
FROM store
JOIN inventory ON inventory.store_id = store.store_id 
JOIN rental ON inventory.inventory_id = rental.inventory_id 
JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY store.store_id ;

-- 7g. Write a query to display for each store its store ID, city, and country. --
SELECT store.store_id, city, country
FROM store
JOIN address ON address.address_id = store.address_id 
JOIN city ON address.city_id = city.city_id 
JOIN country ON city.country_id = country.country_id
;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.) --
SELECT category.name AS genres, SUM(amount) AS 'gross_revenue'
FROM category
JOIN film_category ON film_category.category_id = category.category_id 
JOIN inventory ON inventory.film_id = film_category.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id 
JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY genres
ORDER BY gross_revenue desc LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.--
CREATE VIEW top_five_genres_by_gross_revenue 
AS SELECT category.name AS genres, SUM(amount) AS 'gross_revenue'
FROM category
JOIN film_category ON film_category.category_id = category.category_id 
JOIN inventory ON inventory.film_id = film_category.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id 
JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY genres
ORDER BY gross_revenue desc LIMIT 5;

-- 8b. How would you display the view that you created in 8a? --
SELECT * FROM top_five_genres_by_gross_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it. --
DROP VIEW IF EXISTS top_five_genres_by_gross_revenue;









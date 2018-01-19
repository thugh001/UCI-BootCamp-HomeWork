#1a - Query first & last name from actors table 
USE sakila;
SELECT first_name, last_name
FROM actor

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 
USE sakila;
SELECT CONCAT(first_name, ' ' , last_name) AS 'Actor Name' FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
USE sakila; 
SELECT first_name, last_name, actor_id
FROM actor
WHERE first_name
LIKE 'joe'

#2b. Find all actors whose last name contain the letters `GEN`:
USE sakila; 
SELECT last_name
FROM actor 
WHERE last_name 
LIKE ('%gen%')

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
USE sakila;
SELECT last_name, first_name
FROM actor 
WHERE last_name
LIKE ('%li%')
ORDER BY last_name, first_name
 
#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
USE sakila; 
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh','China');
 
#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
USE sakila;
ALTER TABLE actor
ADD column middle_name VARCHAR(45) 
AFTER first_name; 
 
#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
USE sakila;
ALTER TABLE actor
MODIFY middle_name BLOB

#3c. Now delete the middle_name column.
USE sakila;
ALTER TABLE actor
DROP middle_name

#4a. List the last names of actors, as well as how many actors have that last name.
USE sakila;
SELECT last_name, COUNT(last_name) as 'last_name'
FROM actor
GROUP BY last_name

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
USE sakila;
SELECT last_name, COUNT(last_name) as 'last_name'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >=2 

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'Harpo'
WHERE first_name = 'Groucho' AND last_name = 'Williams'

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id = 172

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
##Do not run##
CREATE TABLE address(
address_id SMALLINT(5),
address varchar(50),
address2 varchar(50),
district varchar(20),
city_id SMALLINT(5),
postal_code varchar(10),
phone varchar(20),
location geometry,
last_update timestamp
PRIMARY KEY (address_id)
);

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address
ON staff.address_id = address.address_id

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(amount) AS 'Total Amount'
FROM staff	
INNER JOIN payment
ON staff.staff_id = payment.staff_id
WHERE payment_date BETWEEN '2005-08-01' AND DATE '2005-08-31'
GROUP BY staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.film_id, film.title, film_actor.actor_id, COUNT(actor_id) AS 'Num of Actors'
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY title

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*)
FROM inventory
WHERE film_id IN
(SELECT film_Id
FROM film
WHERE title = 'Hunchback Impossible');

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, SUM(amount) AS 'Total Paid'
FROM payment
INNER JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY last_name ASC;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE title LIKE 'k%' OR title LIKE 'q%'AND language_id IN
(
SELECT language_id
FROM language
WHERE name = 'English' 
);
 
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id =
  (
   SELECT film_id
   FROM film
   WHERE title = 'Alone Trip'
  )
);

#7c. You want to run an email marketing campaign in Canada, for which your customer will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country.country = 'Canada'

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN
(
  SELECT film_id
  FROM film_category
  WHERE category_id =
  (
   SELECT category_id
   FROM category
   WHERE name = 'family'
  )
);

#7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(title) as 'Frequently Rented Movies'
FROM film 
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY 'Frequently Rented Movies' DESC;

##COULDN'T GET ALTERNATIVE SOLUTION FOR #7 TO WORK##
#SELECT title, COUNT(title) AS 'Frequently Rented Movies'
#FROM film
#WHERE film_id IN
(
#SELECT film_id
#FROM inventory
#WHERE inventory_id IN
( 
#SELECT inventory_ID
#FROM rental
)
);

#7f. Write a query to display how much business, in dollars, each store brought in.
select city, country, sum(p.amount) as 'total_sales'
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join store s on i.store_id = s.store_id
join address a on s.address_id = a.address_id
join city c on a.city_id = c.city_id
join country y on c.country_id = y.country_id
join staff f on s.manager_staff_id = f.staff_id
group by s.store_id
order by y.country, c.city;

#7g. Write a query to display for each store its store ID, city, and country.
select store_id, city, country
from store s, address a , city c, country y
where s.address_id = a.address_id
and a.city_id = c.city_id
and c.country_id = y.country_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select name, sum(p.amount) as 'revenue'
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by name
order by revenue
limit 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view v_top_5_genre as 
select name, sum(p.amount) as 'revenue'
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by name
order by revenue
limit 5;

#8b. How would you display the view that you created in 8a?
select * from v_top_5_genre;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view v_top_5_genre;

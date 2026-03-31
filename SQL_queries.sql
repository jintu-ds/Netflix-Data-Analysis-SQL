-- netflix project.

create table netflix(
show_id	varchar(6),
type  varchar(10),
title	varchar(150),
director	varchar(208),
casts	varchar(1000),
country	varchar(150),
date_added	varchar(50),
release_year	int,
rating	varchar(10),
duration	varchar(15),
listed_in	varchar(100),
description varchar(1000)
);

select * from netflix;

select count(*) from netflix;



-- count number of movies vs tv shoes.

SELECT TYPE,
       count(*) AS Total_content
FROM netflix
GROUP BY TYPE;


-- find the most common rating for the movies and tv shows.

SELECT TYPE,
       rating
FROM
  (SELECT TYPE,
          rating,
          count(*),
          rank() over(PARTITION BY TYPE
                      ORDER BY count(*) DESC)AS Ranking
   FROM netflix
   GROUP BY 1,
            2) AS NEW_TABLE
WHERE Ranking = 1;


-- list all movies released in a specific year 2020.


SELECT title
FROM netflix
WHERE TYPE = 'Movie'
  AND release_year=2020;

  

-- find the top 5 countries with the most content on netflix.

SELECT unnest(string_to_array(country, ',')) AS Total_country,
       count(show_id) AS Total_content
FROM netflix
GROUP BY country
ORDER BY Total_content DESC
LIMIT 5;


-- identify the longest movie.

SELECT title, duration
FROM netflix
WHERE type = 'Movie'and
duration is not null
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;


-- find content added in last 5 years .

SELECT title,
       to_date(date_added, 'month DD,YYYY')
FROM netflix
WHERE to_date(date_added, 'month DD,YYYY') >= CURRENT_DATE - interval '5 years';



-- find all the movies/TV shows by director 'Rohit Shetty'.

SELECT title,
       director
FROM netflix
WHERE director like '%Rohit Shetty%';


-- list all the TV shows with more than 5 seasons.

 SELECT title,
       SPLIT_PART(duration, ' ', 1) AS seasons
FROM netflix
WHERE TYPE = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::numeric > 5;

  
-- count the number of content in each genre.

SELECT count(show_id) AS Total_content,
       unnest(STRING_TO_ARRAY(listed_in, ',')) AS Total_genre
FROM netflix
GROUP BY Total_genre;


-- find the content released by India on Netflix each year. Return the Top 5 result.

SELECT count(show_id) AS Total_content,
       EXTRACT(YEAR
               FROM TO_DATE(date_added, 'Month DD,YYYY'))AS released_year
FROM netflix
WHERE country='India'
GROUP BY released_year
ORDER BY Total_content DESC
LIMIT 5;


-- List all the movies that are documentaries.

SELECT title,
       TYPE,
       listed_in
FROM netflix
WHERE TYPE= 'Movie'
  AND listed_in like '%Documentaries%';

  
-- find all content without a director.

SELECT title,
       TYPE
FROM netflix
WHERE director IS NULL;


-- find how many movies actor 'Salman Khan' appeared in last 10 years.

SELECT title,
       casts,
       to_date(date_added, 'month DD,YYYY')
FROM netflix
WHERE to_date(date_added, 'month DD,YYYY') >= CURRENT_DATE - interval '10 years'
  AND casts ilike '%salman khan%';


-- find the top 10 actor who appeared in the highest number of movies in India.

SELECT unnest(STRING_TO_ARRAY(casts, ',')) AS actor,
       count(show_id) AS number_of_films
FROM netflix
WHERE country ilike '%india%'
GROUP BY actor
ORDER BY number_of_films DESC
LIMIT 10;
  





















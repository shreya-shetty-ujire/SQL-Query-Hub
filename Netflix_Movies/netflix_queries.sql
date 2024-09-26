DROP TABLE IF EXISTS NETFLIX;

CREATE TABLE NETFLIX (
	SHOW_ID VARCHAR(6),
	TYPE VARCHAR(10),
	TITLE VARCHAR(150),
	DIRECTOR VARCHAR(208),
	CASTS VARCHAR(1000),
	COUNTRY VARCHAR(150),
	DATE_ADDED VARCHAR(50),
	RELEASE_YEAR INT,
	RATING VARCHAR(10),
	DURATION VARCHAR(15),
	LISTED_IN VARCHAR(100),
	DESCRIPTION VARCHAR(250)
)
-- TOTAL NUMBER OF ROWS --
SELECT
	COUNT(*) AS TOTALCOUNT
FROM
	NETFLIX;

-- UNIQUE TYPE OF SHOWS --
SELECT DISTINCT
	TYPE
FROM
	NETFLIX;

-- 1. Count the number of Movies vs TV Shows --
SELECT
	TYPE,
	COUNT(*) AS TOTAL_TYPE
FROM
	NETFLIX
GROUP BY
	TYPE;

-- 2. Find the most common rating for movies and TV shows
SELECT
	TYPE,
	RATING
FROM
	(
		SELECT
			TYPE,
			RATING,
			COUNT(*) AS RATING_COUNT,
			RANK() OVER (
				PARTITION BY
					TYPE
				ORDER BY
					COUNT(*) DESC
			) AS RANKING
		FROM
			NETFLIX
		GROUP BY
			TYPE,
			RATING
	) AS SUBTABLE1
WHERE
	RANKING = 1
	-- 3. List all movies released in a specific year (e.g., 2020)
SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND RELEASE_YEAR = 2020;

-- 4. Find the top 5 countries with the most content on Netflix
SELECT
	UNNEST(STRING_TO_ARRAY(COUNTRY, ',')) AS NEW_COUN,
	COUNT(SHOW_ID)
FROM
	NETFLIX
GROUP BY
	1
ORDER BY
	COUNT(SHOW_ID) DESC
LIMIT
	5;

-- 5. Identify the longest movie
SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND CAST(
		SUBSTRING(DURATION, 1, LENGTH(DURATION) -4) AS INTEGER
	) = (
		SELECT
			MAX(
				CAST(
					SUBSTRING(DURATION, 1, LENGTH(DURATION) -4) AS INTEGER
				)
			)
		FROM
			NETFLIX
		WHERE
			TYPE = 'Movie'
	)
	-- 6. Find content added in the last 5 years
SELECT
	*
FROM
	NETFLIX
WHERE
	TO_DATE(DATE_ADDED, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT
	*
FROM
	NETFLIX
WHERE
	DIRECTOR ILIKE '%Rajiv Chilaka%' -- ilike is used for case-sensitive comparison
	-- 8. List all TV shows with more than 5 seasons
SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'TV Show'
	AND CAST(REGEXP_SUBSTR (DURATION, '^[0-9]+') AS INTEGER) >= 5;

-- or we can use split_part(duration,' ',1):: numeric

-- 9. Count the number of content items in each genre

SELECT
	UNNEST(STRING_TO_ARRAY(LISTED_IN, ',')) AS GENRE,
	COUNT(*)
FROM
	NETFLIX
GROUP BY
	GENRE
	
	-- 10.Find each year and the average numbers of content release in India on netflix. 
	-- return top 5 year with highest avg content release!
	
SELECT
	EXTRACT(YEAR FROM TO_DATE(DATE_ADDED, 'Month DD, YYYY')) AS YEAR,
	COUNT(*) AS CONTENT_COUNT,
	ROUND(
		COUNT(*)::NUMERIC / (SELECT COUNT(*)::NUMERIC FROM NETFLIX WHERE COUNTRY = 'India') * 100,2
	) AS AVERAGE_CONTENT
FROM
	NETFLIX WHERE COUNTRY = 'India'
GROUP BY 1
ORDER BY CONTENT_COUNT DESC
LIMIT 5


-- 11. List all movies that are documentaries

select * from netflix where listed_in ilike '%Documentaries%'


-- 12. Find all content without a director

select * from netflix where director is null


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix where casts ilike '%Salman Khan%' and release_year> extract(year from current_date)-10



-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

	    select 
		unnest(string_to_array(casts,',')) as actors,
		count(*) as total_count
		from netflix 
		where country ilike '%india%' 
		group by 1 
		order by 2 desc
	    limit 10


-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

select
	case when description ilike '%kill%' or
	     description ilike '%violence%' then 'Bad'
	else 'Good'
	end category, count(*)
	from netflix
    group by 1






















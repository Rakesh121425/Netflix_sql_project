======netflix project=======;

CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

select * from netflix;


select DISTINCT DIRECTOR from netflix;

------BUSINESS PROBLEMS IN NETFLIX DATASET--------

---1. Count the Number of Movies vs TV Shows

SELECT TYPE,COUNT(*) FROM NETFLIX
GROUP BY TYPE;

----2. Find the Most Common Rating for Movies and TV Shows

    SELECT 
        type,
        rating,
		COUNT(*),
		RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
		FROM NETFLIX
		GROUP BY TYPE,RATING;
   

-----3. List All Movies Released in a Specific Year (e.g., 2020)---

SELECT * 
FROM netflix
WHERE 
TYPE='Movie'
AND
release_year = 2020;


-----4. Find the Top 5 Countries with the Most Content on Netflix---

select distinct country,count (show_id) as high_content from netflix
group by country
order by count (show_id) desc
limit 5;


-----5. Identify the Longest Movie----

select title,max(duration) from netflix
where type='Movie'
group by title
order by max(duration) desc;


----6. Find Content Added in the Last 5 Years----

select * FROM netflix 
where To_date(DATE_ADDED ,'Month DD YYYY')>=CURRENT_DATE-INTERVAL '5 YEARS';


----7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'---

select type,title from netflix
where director ilike '%Rajiv Chilaka%';


----8.List All TV Shows with More Than 5 Seasons-----


select type,title from netflix
where type='TV Show' 
and CAST(SPLIT_PART(DURATION, ' ', 1) AS integer)>5;


-----9.Count the Number of Content Items in Each Genre-----

select (unnest(string_to_array(listed_in,','))) as genre,
count(show_id)from netflix
group by genre;

-----10.Find each year and the average numbers of content release in India on netflix.----

select release_year,count(*) from netflix,
 unnest(string_to_array(COUNTRY,',')) as c
where trim(c)='India'
group by release_year
ORDER BY release_year;

----11. List All Movies that are Documentaries-----

select title from netflix
where listed_in like '%Documentaries';

-----12. Find All Content Without a Director------

select type from netflix
where director is null;

----13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years----

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-----14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India----

select distinct trim (unnest(string_to_array(casts,','))) as actor,count(*) as countt from netflix
where type='Movie' and country='India'
group by actor
order by countt desc
limit 10;


----15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords---
select type,count(*) from netflix
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;


-- ------------------------------------ --
-- 70s                                  --
-- 39,181 matches.                      --
-- ------------------------------------ --


SELECT COUNT(*)
FROM tm
WHERE tourney_date LIKE "197%";


-- Number of total matches won in the 70s, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Won Matches 1970-1979"
FROM tm
WHERE tourney_date LIKE "197%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total finals won in the 70s.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Finals Won 1970-1979"
FROM tm
WHERE round = "F" AND tourney_date LIKE "197%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of matches won by country in the 70s.
SELECT
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_ioc AS "Country", 
    FORMAT(COUNT(*), 0) AS "Number of Won Matches 1970-1979" ,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tm WHERE tourney_date LIKE "197%"), 0) AS `Percentage`
FROM tm
WHERE tourney_date LIKE "197%"
GROUP BY winner_ioc
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Grand Slam Finals won in the 70s, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Grand Slam Finals Won 1970-1979"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "197%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Australian Open Finals won in the 70s, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Australian Open Finals Won 1970-1979"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "197%" AND tourney_name LIKE "Aust%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total French Open Finals won in the 70s, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of French Open Finals Won 1970-1979"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "197%" AND tourney_name LIKE "Rola%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Us Open Finals won in the 70s, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of U.S. Open Finals Won 1970-1979"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "197%" AND tourney_name LIKE "Us%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Wimbledon Finals won in the 70s, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Wimbledon Finals Won 1970-1979"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "197%" AND tourney_name LIKE "Wimb%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;






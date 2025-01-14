-- ------------------------------------ --
-- 20s                                  --
-- 12,184 matches.                      --
-- ------------------------------------ --


SELECT COUNT(*)
FROM tm
WHERE tourney_date LIKE "202%";


-- Number of total matches won in the 20s
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Won Matches 2020-2024"
FROM tm
WHERE tourney_date LIKE "202%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total finals won in the 20s.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Finals Won 2020-2024"
FROM tm
WHERE round = "F" AND tourney_date LIKE "202%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Grand Slam Finals won in the 00s.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Grand Slam Finals Won 2020-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "202%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Australian Open Finals won in the 20s.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Australian Open Finals Won 2020-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "202%" AND tourney_name LIKE "Aust%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total French Open Finals won in the 20s.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of French Open Finals Won 2020-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "202%" AND tourney_name LIKE "Rola%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Us Open Finals won in the 20s.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of US Open Finals Won 2020-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "202%" AND tourney_name LIKE "Us%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Wimbledon Finals won in the 20s.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Wimbledon Finals Won 2020-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_date LIKE "202%" AND tourney_name LIKE "Wimb%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;



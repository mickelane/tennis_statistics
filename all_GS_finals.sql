-- -------------------------------------------  --
-- Whole time period, Grand Slams Finals only   --
-- 227 finals.                                  --
-- -------------------------------------------  --


SELECT COUNT(*)
FROM tm
WHERE tourney_level = "G" AND round = "F";


-- Number of total Grand Slam Finals won, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Grand Slam Finals Won 1968-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total GS finals lost, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    loser_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Grand Slam Finals Lost 1968-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G"
GROUP BY loser_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Australian Open Finals won.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Australian Open Finals Won 1968-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_name LIKE "Austr%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total French Open Finals won.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of French Open Finals Won 1968-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_name LIKE "Roland%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total US Open Finals won.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of US Open Finals Won 1968-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_name LIKE "Us%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total Wimbledon Finals won.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Wimbledon Finals Won 1968-2024"
FROM tm
WHERE round = "F" AND tourney_level = "G" AND tourney_name LIKE "Wimble%"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of GS finals won by country.
SELECT
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_ioc AS "Country", 
    FORMAT(COUNT(*), 0) AS "Number of Won GS Finals 1968-2024" ,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tm WHERE round = "F" AND tourney_level = "G"), 0) AS `Percentage`
FROM tm
WHERE round = "F" AND tourney_level = "G"
GROUP BY winner_ioc
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Longest GS finals 
SELECT
    minutes AS "Time in Minutes",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner",
    loser_name AS "Loser",
    score AS "Score"
FROM tm
WHERE minutes < 900 AND round="F" AND tourney_level = "G"
ORDER BY 1 DESC
LIMIT 20;


-- Shortest GS finals
SELECT
    minutes AS "Time in Minutes",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner",
    loser_name AS "Loser",
    score AS "Score"
FROM tm
WHERE minutes IS NOT NULL AND minutes > 0 AND score NOT LIKE "%RET%" AND round = "F" AND tourney_level = "G"
ORDER BY 1 
LIMIT 20;


-- Aces in one GS final
SELECT 
    winner_name AS "Aces by", 
    w_ace AS "Aces in One Final",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F" AND tourney_level = "G"
UNION ALL
SELECT
    loser_name AS "Aces by", 
    l_ace AS "Aces in One Match",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F" AND tourney_level = "G"
ORDER BY 2 DESC
LIMIT 20;


-- Double faults in one GS final
SELECT 
    winner_name AS "Double Faults By", 
    w_df AS "Double Faults in One Final",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F" AND tourney_level = "G"
UNION ALL
SELECT
    loser_name AS "Double Faults By", 
    l_df AS "Double Faults in One Match",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F" AND tourney_level = "G"
ORDER BY 2 DESC
LIMIT 20;




-- ------------------------------------ --
-- Whole time period, finals only       --
-- 4,557 matches.                       --
-- ------------------------------------ --


-- Number of total finals won, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Finals Won 1968-2024"
FROM tm
WHERE round = "F"
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of total finals lost, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    loser_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Finals Lost 1968-2024"
FROM tm
WHERE round = "F"
GROUP BY loser_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Number of finals won by country.
SELECT
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_ioc AS "Country", 
    FORMAT(COUNT(*), 0) AS "Number of Won Finals 1968-2024" ,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tm WHERE round = "F"), 0) AS `Percentage`
FROM tm
WHERE round = "F"
GROUP BY winner_ioc
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Average time of finals. 
SELECT 
    -- '' AS "Average Match Time in Minutes",
    ROUND(AVG(CASE WHEN best_of = 5 AND round = "F" THEN minutes END), 0) AS "Best of 5 Sets",
    ROUND(AVG(CASE WHEN best_of = 5 AND round = "F" AND (winner_rank < loser_rank OR loser_rank IS NULL) THEN minutes END), 0) AS "Best of 5 Sets, Winner Better Ranking",
    ROUND(AVG(CASE WHEN best_of = 5 AND round = "F" AND (winner_rank > loser_rank OR winner_rank IS NULL) THEN minutes END), 0) AS "Best of 5 Sets, Winner Worse Ranking",
    ROUND(AVG(CASE WHEN best_of = 3 AND round = "F" THEN minutes END), 0) AS "Best of 3 Sets",
    ROUND(AVG(CASE WHEN best_of = 3 AND round = "F" AND (winner_rank < loser_rank OR loser_rank IS NULL) THEN minutes END), 0) AS "Best of 3 Sets, Winner Better Ranking",
    ROUND(AVG(CASE WHEN best_of = 3 AND round = "F" AND (winner_rank > loser_rank OR winner_rank IS NULL) THEN minutes END), 0) AS "Best of 3 Sets, Winner Worse Ranking"
FROM tm;


-- Longest finals 
SELECT
    minutes AS "Time in Minutes",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner",
    loser_name AS "Loser",
    score AS "Score"
FROM tm
WHERE minutes < 900 AND round="F"
ORDER BY 1 DESC
LIMIT 20;


-- Shortest finals
SELECT
    minutes AS "Time in Minutes",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner",
    loser_name AS "Loser",
    score AS "Score"
FROM tm
WHERE minutes IS NOT NULL AND minutes > 0 AND score NOT LIKE "%RET%" AND round = "F"
ORDER BY 1 
LIMIT 20;


-- Age of players in finals.
WITH YoungestWinner AS (
    SELECT 
        winner_name AS youngest_winner_name,
        winner_age AS youngest_winner_age
    FROM tm
    WHERE round = "F" 
    AND winner_age = (SELECT MIN(winner_age) FROM tm WHERE round = "F")
    LIMIT 1  -- Ensure only one result
),
OldestWinner AS (
    SELECT
        winner_name AS oldest_winner_name,
        winner_age AS oldest_winner_age
    FROM tm
    WHERE round = "F"
    AND winner_age = (SELECT MAX(winner_age) FROM tm WHERE round = "F")
    LIMIT 1
),
YoungestLoser AS (
    SELECT
        loser_name AS youngest_loser_name,
        loser_age AS youngest_loser_age
    FROM tm
    WHERE round = "F"
    AND loser_age = (SELECT MIN(loser_age) FROM tm WHERE round = "F")
    LIMIT 1  -- Ensure only one result
),
OldestLoser AS (
    SELECT 
        loser_name AS oldest_loser_name,
        loser_age AS oldest_loser_age
    FROM tm
    WHERE round = "F"
    AND loser_age = (SELECT MAX(loser_age) FROM tm WHERE round = "F")
    LIMIT 1
)
SELECT 
    yw.youngest_winner_name AS "Youngest Winner", 
    yw.youngest_winner_age AS "Youngest Winner Age",
    ow.oldest_winner_name AS "Oldest Winner", 
    ow.oldest_winner_age AS "Oldest Winner Age",
    ROUND(AVG(t.winner_age), 1) AS "Average Winner Age",
    yl.youngest_loser_name AS "Youngest Loser",
    yl.youngest_loser_age AS "Youngest Loser Age",
    ol.oldest_loser_name AS "Oldest Loser",
    ol.oldest_loser_age AS "Oldest Loser Age",
    ROUND(AVG(t.loser_age), 1) AS "Average Loser Age"
FROM tm t
CROSS JOIN YoungestWinner yw
CROSS JOIN OldestWinner ow
CROSS JOIN YoungestLoser yl
CROSS JOIN OldestLoser ol
WHERE t.round = "F"  -- Only consider finals
GROUP BY 
    yw.youngest_winner_name, yw.youngest_winner_age, 
    ow.oldest_winner_name, ow.oldest_winner_age, 
    yl.youngest_loser_name, yl.youngest_loser_age,
    ol.oldest_loser_name, ol.oldest_loser_age;
    
  
-- Tallest, shortest and average height of players in finals
WITH TallestPlayer AS (
    SELECT 
        player_name AS tallest_player_name,
        ht AS tallest_player_height
    FROM (
        SELECT winner_name AS player_name, winner_ht AS ht FROM tm WHERE round = "F"
        UNION ALL
        SELECT loser_name AS player_name, loser_ht AS ht FROM tm WHERE round = "F"
    ) all_players
    WHERE ht = (SELECT MAX(ht) FROM (
        SELECT winner_ht AS ht FROM tm WHERE round = "F"
        UNION ALL
        SELECT loser_ht AS ht FROM tm WHERE round = "F"
    ) heights)
    LIMIT 1
),
ShortestPlayer AS (
    SELECT 
        player_name AS shortest_player_name,
        ht AS shortest_player_height
    FROM (
        SELECT winner_name AS player_name, winner_ht AS ht FROM tm WHERE round = "F"
        UNION ALL
        SELECT loser_name AS player_name, loser_ht AS ht FROM tm WHERE round = "F"
    ) all_players
    WHERE ht = (SELECT MIN(ht) FROM (
        SELECT winner_ht AS ht FROM tm WHERE round = "F"
        UNION ALL
        SELECT loser_ht AS ht FROM tm WHERE round = "F"
    ) heights)
    LIMIT 1
),
AverageHeight AS (
    SELECT 
        ROUND(AVG(ht), 0) AS avg_player_height
    FROM (
        SELECT winner_ht AS ht FROM tm WHERE round = "F"
        UNION ALL
        SELECT loser_ht AS ht FROM tm WHERE round = "F"
    ) all_heights
)
SELECT 
    tp.tallest_player_name AS "Tallest Finalist",
    tp.tallest_player_height AS "Tallest Finalist Height",
    sp.shortest_player_name AS "Shortest Finalist",
    sp.shortest_player_height AS "Shortest Finalist Height",
    ah.avg_player_height AS "Average Finalist Height"
FROM TallestPlayer tp
CROSS JOIN ShortestPlayer sp
CROSS JOIN AverageHeight ah;


-- Aces in one final
SELECT 
    winner_name AS "Aces by", 
    w_ace AS "Aces in One Final",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F"
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
WHERE round = "F"
ORDER BY 2 DESC
LIMIT 20;


-- Sum of all aces in finals
SELECT 
    player_name AS "Aces by", 
    FORMAT(SUM(aces), 0) AS "Total Aces Made in Finals"
FROM (
    SELECT winner_name AS player_name, w_ace AS aces
    FROM tm
    WHERE round = "F"
    UNION ALL
    SELECT loser_name AS player_name, l_ace AS aces
    FROM tm
    WHERE round = "F"
) AS combined_aces
GROUP BY player_name
ORDER BY SUM(aces) DESC
LIMIT 20;


-- Double faults in one final
SELECT 
    winner_name AS "Double Faults By", 
    w_df AS "Double Faults in One Final",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F"
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
WHERE round = "F"
ORDER BY 2 DESC
LIMIT 20;


-- Sum of all double faults made in finals
SELECT 
    player_name AS "Double Faults by", 
    FORMAT(SUM(dfs), 0) AS "Total Double Faults Made in Finals"
FROM (
    SELECT winner_name AS player_name, w_df AS dfs
    FROM tm
    WHERE round = "F"
    UNION ALL
    SELECT loser_name AS player_name, l_df AS dfs
    FROM tm
    WHERE round = "F"
) AS combined_dfs
GROUP BY player_name
ORDER BY SUM(dfs) DESC
LIMIT 20;


-- Break points faced in one final
SELECT 
    winner_name AS "BPs Faced By", 
    w_bpFaced AS "BPs Faced",
    w_bpSaved AS "BPs Saved",
    ROUND(w_bpSaved / w_bpFaced * 100, 0) AS "% Saved",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F"
UNION ALL
SELECT
    loser_name AS "BPs Faced By", 
    l_bpFaced AS "BPs Faced",
    l_bpSaved AS "BPs Saved",
    ROUND(l_bpSaved / l_bpFaced * 100, 0) AS "Percentage Saved",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F"
ORDER BY 2 DESC
LIMIT 20;


-- Sum of break points faced in finals
SELECT 
    player_name AS "Break Points Faced By", 
    FORMAT(SUM(bpf), 0) AS "Total Break Points Faced in Finals",
    FORMAT(sum(bps), 0) AS "Total Break Points Saved in Finals",
    ROUND(sum(bps) / SUM(bpf) * 100, 0) AS "Percentage Saved in Finals"
FROM (
    SELECT winner_name AS player_name, w_bpFaced AS bpf, w_bpSaved AS bps
    FROM tm
    WHERE round = "F"
    UNION ALL
    SELECT loser_name AS player_name, l_bpFaced AS bpf, l_bpSaved AS bps
    FROM tm
    WHERE round = "F"
) AS combined
GROUP BY player_name
ORDER BY SUM(bpf) DESC
LIMIT 20;


-- Break points saved in one final.
SELECT 
    winner_name AS "BPs Saved By", 
    w_bpSaved AS "BPs Saved",
    w_bpFaced AS "BPs Faced",
    ROUND(w_bpSaved / w_bpFaced * 100, 0) AS "% Saved",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F"
UNION ALL
SELECT
    loser_name AS "BPs Saved By", 
    l_bpSaved AS "BPs Saved",
    l_bpFaced AS "BPs Faced",
    ROUND(l_bpSaved / l_bpFaced * 100, 0) AS "Percentage Saved",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
WHERE round = "F"
ORDER BY 2 DESC
LIMIT 20;


-- Sum of break points saved in finals.
SELECT 
    player_name AS "Break Points Saved By", 
    FORMAT(sum(bps), 0) AS "Total Break Points Saved in Finals",
    FORMAT(SUM(bpf), 0) AS "Total Break Points Faced in Finals",
    ROUND(sum(bps) / SUM(bpf) * 100, 0) AS "Percentage Saved in Finals"
FROM (
    SELECT winner_name AS player_name, w_bpFaced AS bpf, w_bpSaved AS bps
    FROM tm
    WHERE round = "F"
    UNION ALL
    SELECT loser_name AS player_name, l_bpFaced AS bpf, l_bpSaved AS bps
    FROM tm
    WHERE round = "F"
) AS combined
GROUP BY player_name
ORDER BY SUM(bps) DESC
LIMIT 20;
SELECT *
FROM tm;








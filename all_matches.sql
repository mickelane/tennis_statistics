-- ------------------------------------ --
-- Whole time period, all matches       --
-- ------------------------------------ --


-- Number of total atp matches won, top 20.
SELECT 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_name AS "Player", 
    FORMAT(COUNT(*), 0) AS "Number of Won Matches 1968-2024"
FROM tm
GROUP BY winner_name
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Total number of players in the database
SELECT 
    COUNT(DISTINCT player_id) AS "Total number of players"
FROM (
    SELECT winner_id AS player_id FROM tm
    UNION
    SELECT loser_id AS player_id FROM tm
) AS all_players;


-- Number of matches won by country.
SELECT
    RANK() OVER (ORDER BY COUNT(*) DESC) AS `Rank`,
    winner_ioc AS "Country", 
    FORMAT(COUNT(*), 0) AS "Number of Won Matches 1968-2024" ,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tm), 2) AS `Percentage`
FROM tm
GROUP BY winner_ioc
ORDER BY COUNT(*) DESC
LIMIT 20;


-- Average time of matches. 
SELECT 
    '' AS "Average Match Time in Minutes",
    ROUND(AVG(CASE WHEN best_of = 5 THEN minutes END), 0) AS "Best of 5 Sets",
    ROUND(AVG(CASE WHEN best_of = 5 AND winner_rank < loser_rank OR loser_rank IS NULL THEN minutes END), 0) AS "Best of 5 Sets, Winner Better Ranking",
    ROUND(AVG(CASE WHEN best_of = 5 AND winner_rank > loser_rank OR winner_rank IS NULL THEN minutes END), 0) AS "Best of 5 Sets, Winner Worse Ranking",
    ROUND(AVG(CASE WHEN best_of = 3 THEN minutes END), 0) AS "Best of 3 Sets",
    ROUND(AVG(CASE WHEN best_of = 3 AND winner_rank < loser_rank OR loser_rank IS NULL THEN minutes END), 0) AS "Best of 3 Sets, Winner Better Ranking",
    ROUND(AVG(CASE WHEN best_of = 3 AND winner_rank > loser_rank OR winner_rank IS NULL THEN minutes END), 0) AS "Best of 3 Sets, Winner Worse Ranking"
FROM tm;


-- Longest matches 
SELECT
    minutes AS "Time in Minutes",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner",
    loser_name AS "Loser",
    score AS "Score"
FROM tm
WHERE minutes < 900
ORDER BY 1 DESC
LIMIT 20;


-- Shortest matches
SELECT
    minutes AS "Time in Minutes",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner",
    loser_name AS "Loser",
    score AS "Score"
FROM tm
WHERE minutes IS NOT NULL AND minutes > 0 AND score NOT LIKE "%RET%"
ORDER BY 1 
LIMIT 20;


-- Age of players.
WITH YoungestWinner AS (
    SELECT 
        winner_name AS youngest_winner_name,
        winner_age AS youngest_winner_age
    FROM tm
    WHERE winner_age = (SELECT MIN(winner_age) FROM tm)
    LIMIT 1
),
OldestWinner AS (
    SELECT
        winner_name AS oldest_winner_name,
        winner_age AS oldest_winner_age
    FROM tm
    WHERE winner_age = (SELECT MAX(winner_age) FROM tm)
    LIMIT 1
),
YoungestLoser AS (
    SELECT
        loser_name AS youngest_loser_name,
        loser_age AS youngest_loser_age
    FROM tm
    WHERE loser_age = (SELECT MIN(loser_age) FROM tm)
    LIMIT 1
),
OldestLoser AS (
    SELECT 
        loser_name AS oldest_loser_name,
        loser_age AS oldest_loser_age
    FROM tm
    WHERE loser_age = (SELECT MAX(loser_age) FROM tm)
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
GROUP BY 
    yw.youngest_winner_name, yw.youngest_winner_age, 
    ow.oldest_winner_name, ow.oldest_winner_age, 
    yl.youngest_loser_name, yl.youngest_loser_age,
    ol.oldest_loser_name, ol.oldest_loser_age;


-- Height
WITH TallestWinner AS (
    SELECT 
        winner_name AS tallest_winner_name,
        winner_ht AS tallest_winner_ht
    FROM tm
    WHERE winner_ht = (SELECT MAX(winner_ht) FROM tm)
    LIMIT 1
),
ShortestWinner AS (
    SELECT
        winner_name AS shortest_winner_name,
        winner_ht AS shortest_winner_ht
    FROM tm
    WHERE winner_ht = (SELECT MIN(winner_ht) FROM tm)
    LIMIT 1
),
TallestLoser AS (
    SELECT
        loser_name AS tallest_loser_name,
        loser_ht AS tallest_loser_ht
    FROM tm
    WHERE loser_ht = (SELECT MAX(loser_ht) FROM tm)
    LIMIT 1
),
ShortestLoser AS (
    SELECT 
        loser_name AS shortest_loser_name,
        loser_ht AS shortest_loser_ht
    FROM tm 
    WHERE loser_ht = (SELECT MIN(loser_ht) FROM tm)
    LIMIT 1
)
SELECT   
    tw.tallest_winner_name AS "Tallest Winner",
    tw.tallest_winner_ht AS "Tallest Winner Height",
    sw.shortest_winner_name AS "Shortest Winner",        
    sw.shortest_winner_ht AS "Shortest Winner Height",
    ROUND(AVG(winner_ht), 1) AS "Average Winner Height",
    tl.tallest_loser_name AS "Tallest Loser",
    tl.tallest_loser_ht AS "Tallest Loser Height",
    sl.shortest_loser_name AS "Shortest Loser",
    sl.shortest_loser_ht AS "Shortest Loser Height",
    ROUND(AVG(loser_ht), 1) AS "Average Loser Height"
FROM tm t
CROSS JOIN TallestWinner tw
CROSS JOIN ShortestWinner sw
CROSS JOIN TallestLoser tl
CROSS JOIN ShortestLoser sl
GROUP BY
    tw.tallest_winner_name, tw.tallest_winner_ht,
    sw.shortest_winner_name, sw.shortest_winner_ht,
    tl.tallest_loser_name, tl.tallest_loser_ht,
    sl.shortest_loser_name, sl.shortest_loser_ht;


-- Tallest, shortest and average height of players
WITH TallestPlayer AS (
    SELECT 
        name AS tallest_player_name,
        ht AS tallest_player_height
    FROM (
        SELECT winner_name AS name, winner_ht AS ht FROM tm
        UNION ALL
        SELECT loser_name AS name, loser_ht AS ht FROM tm
    ) all_players
    WHERE ht = (SELECT MAX(ht) FROM (
        SELECT winner_ht AS ht FROM tm
        UNION ALL
        SELECT loser_ht AS ht FROM tm
    ) heights)
    LIMIT 1
),
ShortestPlayer AS (
    SELECT 
        name AS shortest_player_name,
        ht AS shortest_player_height
    FROM (
        SELECT winner_name AS name, winner_ht AS ht FROM tm
        UNION ALL
        SELECT loser_name AS name, loser_ht AS ht FROM tm
    ) all_players
    WHERE ht = (SELECT MIN(ht) FROM (
        SELECT winner_ht AS ht FROM tm
        UNION ALL
        SELECT loser_ht AS ht FROM tm
    ) heights)
    LIMIT 1
),
AverageHeight AS (
    SELECT 
        ROUND(AVG(ht), 0) AS avg_player_height
    FROM (
        SELECT winner_ht AS ht FROM tm
        UNION ALL
        SELECT loser_ht AS ht FROM tm
    ) all_heights
)
SELECT 
    tp.tallest_player_name AS "Tallest Player",
    tp.tallest_player_height AS "Tallest Player Height",
    sp.shortest_player_name AS "Shortest Player",
    sp.shortest_player_height AS "Shortest Player Height",
    ah.avg_player_height AS "Average Player Height"
FROM TallestPlayer tp
CROSS JOIN ShortestPlayer sp
CROSS JOIN AverageHeight ah;


-- Aces in one match
SELECT 
    winner_name AS "Aces by", 
    w_ace AS "Aces in One Match",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
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
ORDER BY 2 DESC
LIMIT 20;


-- Sum of all aces
SELECT 
    player_name AS "Aces by", 
    FORMAT(SUM(aces), 0) AS "Total Aces Made"
FROM (
    SELECT winner_name AS player_name, w_ace AS aces
    FROM tm
    UNION ALL
    SELECT loser_name AS player_name, l_ace AS aces
    FROM tm
) AS combined_aces
GROUP BY player_name
ORDER BY SUM(aces) DESC
LIMIT 20;


-- Double faults in one match
SELECT 
    winner_name AS "Double Faults By", 
    w_df AS "Double Faults in One Match",
    tourney_name AS "Tourney",
    tourney_date AS "Date",
    winner_name AS "Winner Name", 
    loser_name AS "Loser Name",
    score AS "Score"
FROM tm
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
ORDER BY 2 DESC
LIMIT 20;


-- Sum of all double faults
SELECT 
    player_name AS "Double Faults by", 
    FORMAT(SUM(dfs), 0) AS "Total Double Faults Made"
FROM (
    SELECT winner_name AS player_name, w_df AS dfs
    FROM tm
    UNION ALL
    SELECT loser_name AS player_name, l_df AS dfs
    FROM tm
) AS combined_dfs
GROUP BY player_name
ORDER BY SUM(dfs) DESC
LIMIT 20;


-- Break points faced in one match
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
ORDER BY 2 DESC
LIMIT 20;


-- Sum of break points faced
SELECT 
    player_name AS "Break Points Faced By", 
    FORMAT(SUM(bpf), 0) AS "Total Break Points Faced",
    FORMAT(sum(bps), 0) AS "Total Break Points Saved",
    ROUND(sum(bps) / SUM(bpf) * 100, 0) AS "Percentage Saved"
FROM (
    SELECT winner_name AS player_name, w_bpFaced AS bpf, w_bpSaved AS bps
    FROM tm
    UNION ALL
    SELECT loser_name AS player_name, l_bpFaced AS bpf, l_bpSaved AS bps
    FROM tm
) AS combined
GROUP BY player_name
ORDER BY SUM(bpf) DESC
LIMIT 20;


-- Break points saved in one match
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
ORDER BY 2 DESC
LIMIT 20;


-- Sum of break points saved
SELECT 
    player_name AS "Break Points Saved By", 
    FORMAT(sum(bps), 0) AS "Total Break Points Saved",
    FORMAT(SUM(bpf), 0) AS "Total Break Points Faced",
    ROUND(sum(bps) / SUM(bpf) * 100, 0) AS "Percentage Saved"
FROM (
    SELECT winner_name AS player_name, w_bpFaced AS bpf, w_bpSaved AS bps
    FROM tm
    UNION ALL
    SELECT loser_name AS player_name, l_bpFaced AS bpf, l_bpSaved AS bps
    FROM tm
) AS combined
GROUP BY player_name
ORDER BY SUM(bps) DESC
LIMIT 20;
SELECT *
FROM tm;




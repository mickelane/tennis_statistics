
-- Replace blanks with NULL
UPDATE tm  
SET 
    draw_size = NULLIF(draw_size, ''),
    tourney_date = NULLIF(tourney_date, ''),
    match_num = NULLIF(match_num, ''),
    winner_id = NULLIF(winner_id, ''),
    winner_seed = NULLIF(winner_seed, ''),
    winner_ht = NULLIF(winner_ht, ''),
    winner_age = NULLIF(winner_age, ''),
    loser_id = NULLIF(loser_id, ''),
    loser_seed = NULLIF(loser_seed, ''),
    loser_ht = NULLIF(loser_ht, ''),
    loser_age = NULLIF(loser_age, ''),
    best_of = NULLIF(best_of, ''),
    minutes = NULLIF(minutes, ''),
    w_ace = NULLIF(w_ace, ''),
    w_df = NULLIF(w_df, ''),
    w_svpt = NULLIF(w_svpt, ''),
    w_1stIn = NULLIF(w_1stIn, ''),
    w_1stWon = NULLIF(w_1stWon, ''),
    w_2ndWon = NULLIF(w_2ndWon, ''),
    w_SvGms = NULLIF(w_SvGms, ''),
    w_bpSaved = NULLIF(w_bpSaved, ''),
    w_bpFaced = NULLIF(w_bpFaced, ''),
    l_ace = NULLIF(l_ace, ''),
    l_df = NULLIF(l_df, ''),
    l_svpt = NULLIF(l_svpt, ''),
    l_1stIn = NULLIF(l_1stIn, ''),
    l_1stWon = NULLIF(l_1stWon, ''),
    l_2ndWon = NULLIF(l_2ndWon, ''),
    l_SvGms = NULLIF(l_SvGms, ''),
    l_bpSaved = NULLIF(l_bpSaved, ''),
    l_bpFaced = NULLIF(l_bpFaced, ''),
    winner_rank = NULLIF(winner_rank, ''),
    winner_rank_points = NULLIF(winner_rank_points, ''),
    loser_rank = NULLIF(loser_rank, ''),
    loser_rank_points = NULLIF(loser_rank_points, '');


-- Change type
ALTER TABLE tm
MODIFY COLUMN draw_size INT,
MODIFY COLUMN winner_seed INT,
MODIFY COLUMN winner_ht INT,
MODIFY COLUMN winner_age FLOAT,
MODIFY COLUMN loser_seed INT,
MODIFY COLUMN loser_ht INT,
MODIFY COLUMN loser_age FLOAT,
MODIFY COLUMN best_of INT,
MODIFY COLUMN minutes INT,
MODIFY COLUMN w_ace INT,
MODIFY COLUMN w_df INT,
MODIFY COLUMN w_svpt INT,
MODIFY COLUMN w_1stIn INT,
MODIFY COLUMN w_1stWon INT,
MODIFY COLUMN w_2ndWon INT,
MODIFY COLUMN w_SvGms INT,
MODIFY COLUMN w_bpSaved INT,
MODIFY COLUMN w_bpFaced INT,
MODIFY COLUMN l_ace INT,
MODIFY COLUMN l_df INT,
MODIFY COLUMN l_svpt INT,
MODIFY COLUMN l_1stIn INT,
MODIFY COLUMN l_1stWon INT,
MODIFY COLUMN l_2ndWon INT,
MODIFY COLUMN l_SvGms INT,
MODIFY COLUMN l_bpSaved INT,
MODIFY COLUMN l_bpFaced INT,
MODIFY COLUMN winner_rank INT,
MODIFY COLUMN winner_rank_points INT,
MODIFY COLUMN loser_rank INT,
MODIFY COLUMN loser_rank_points INT
;

-- Change date format.
UPDATE tm
SET tourney_date = STR_TO_DATE(tourney_date, '%Y%m%d');


SELECT COUNT(*)
FROM tm
WHERE tourney_date;


-- Delete Davis Cup from 2016 onwards
DELETE FROM tm
WHERE tourney_level = "D" AND tourney_date > '2016-01-01';


-- Delete Olympics
DELETE FROM tm
WHERE tourney_level = "O" AND tourney_date > '2016-01-01';


-- Delete rows that have tourney_id and tourney_name NULL
DELETE FROM tm
WHERE tourney_id IS NULL
  AND tourney_name IS NULL;
  
  
-- Check for duplicates
WITH duplicate_rows AS (
    SELECT tourney_id, tourney_name, surface, draw_size, tourney_level, 
                            tourney_date, match_num, winner_id, winner_seed, winner_entry, 
                            winner_name, winner_hand, winner_ht, winner_ioc, winner_age,
                            loser_id, loser_seed, loser_entry, loser_name, loser_hand, 
                            loser_ht, loser_ioc, loser_age, score, best_of, round, minutes, 
                            w_ace, w_df, w_svpt, w_1stIn, w_1stWon, w_2ndWon, w_SvGms,
                            w_bpSaved, w_bpFaced, l_ace, l_df, l_svpt, l_1stIn, l_1stWon,
                            l_2ndWon, l_SvGms, l_bpSaved, l_bpFaced, winner_rank,
                            winner_rank_points, loser_rank, loser_rank_points, COUNT(*) as count
    FROM tennis_matches
    GROUP BY tourney_id, tourney_name, surface, draw_size, tourney_level, 
                            tourney_date, match_num, winner_id, winner_seed, winner_entry, 
                            winner_name, winner_hand, winner_ht, winner_ioc, winner_age,
                            loser_id, loser_seed, loser_entry, loser_name, loser_hand, 
                            loser_ht, loser_ioc, loser_age, score, best_of, round, minutes, 
                            w_ace, w_df, w_svpt, w_1stIn, w_1stWon, w_2ndWon, w_SvGms,
                            w_bpSaved, w_bpFaced, l_ace, l_df, l_svpt, l_1stIn, l_1stWon,
                            l_2ndWon, l_SvGms, l_bpSaved, l_bpFaced, winner_rank,
                            winner_rank_points, loser_rank, loser_rank_points
    HAVING COUNT(*) > 1
)
SELECT *
FROM tennis_matches
WHERE (tourney_id, tourney_name, surface, draw_size, tourney_level, 
                            tourney_date, match_num, winner_id, winner_seed, winner_entry, 
                            winner_name, winner_hand, winner_ht, winner_ioc, winner_age,
                            loser_id, loser_seed, loser_entry, loser_name, loser_hand, 
                            loser_ht, loser_ioc, loser_age, score, best_of, round, minutes, 
                            w_ace, w_df, w_svpt, w_1stIn, w_1stWon, w_2ndWon, w_SvGms,
                            w_bpSaved, w_bpFaced, l_ace, l_df, l_svpt, l_1stIn, l_1stWon,
                            l_2ndWon, l_SvGms, l_bpSaved, l_bpFaced, winner_rank,
                            winner_rank_points, loser_rank, loser_rank_points) IN (
    SELECT tourney_id, tourney_name, surface, draw_size, tourney_level, 
                            tourney_date, match_num, winner_id, winner_seed, winner_entry, 
                            winner_name, winner_hand, winner_ht, winner_ioc, winner_age,
                            loser_id, loser_seed, loser_entry, loser_name, loser_hand, 
                            loser_ht, loser_ioc, loser_age, score, best_of, round, minutes, 
                            w_ace, w_df, w_svpt, w_1stIn, w_1stWon, w_2ndWon, w_SvGms,
                            w_bpSaved, w_bpFaced, l_ace, l_df, l_svpt, l_1stIn, l_1stWon,
                            l_2ndWon, l_SvGms, l_bpSaved, l_bpFaced, winner_rank,
                            winner_rank_points, loser_rank, loser_rank_points
    FROM duplicate_rows
);


-- Check for number of players with different hands registrated
SELECT COUNT(DISTINCT player_id) AS "Players with multiple handedness"
FROM (
    SELECT player_id FROM (
        SELECT winner_id AS player_id, winner_hand AS hand FROM tm
        UNION ALL
        SELECT loser_id AS player_id, loser_hand AS hand FROM tm
    ) AS all_handedness
    GROUP BY player_id
    HAVING COUNT(DISTINCT hand) > 1
) AS players_with_multiple_handedness;
  
  
-- Query for Tourney Dates of Players with Multiple Handedness  
SELECT DISTINCT player_id, tourney_date, player_name, hand
FROM (
    SELECT winner_id AS player_id, winner_hand AS hand, tourney_date, winner_name AS player_name FROM tm
    UNION ALL
    SELECT loser_id AS player_id, loser_hand AS hand, tourney_date, loser_name AS player_name FROM tm
) AS all_handedness
WHERE player_id IN (
    SELECT player_id
    FROM (
        SELECT player_id
        FROM (
            SELECT winner_id AS player_id, winner_hand AS hand FROM tm
            UNION ALL
            SELECT loser_id AS player_id, loser_hand AS hand FROM tm
        ) AS all_handedness
        GROUP BY player_id
        HAVING COUNT(DISTINCT hand) > 1
    ) AS players_with_multiple_handedness
)
ORDER BY player_name;


-- Check loser heights
SELECT loser_name, loser_ht
FROM tm
WHERE loser_ht IS NOT NULL
ORDER BY loser_ht;


SELECT *
FROM tm
WHERE winner_ht < 5;


UPDATE tm  
SET winner_ht = NULL
WHERE  winner_ht < 5 AND winner_name LIKE "Jorge Brian Panta Herr%";





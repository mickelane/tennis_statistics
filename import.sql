/*
ATP Tennis matches 1990 - 2024
*/


-- Create the table to match the csv-file
CREATE TABLE tennis_matches(
    tourney_id VARCHAR(200),
    tourney_name VARCHAR(200),
    surface VARCHAR(200),
    draw_size VARCHAR(200),
    tourney_level VARCHAR(200),
    tourney_date VARCHAR(100),
    match_num VARCHAR(200),
    winner_id VARCHAR(200),
    winner_seed VARCHAR(200),
    winner_entry VARCHAR(200),
    winner_name VARCHAR(200),
    winner_hand VARCHAR(200),
    winner_ht VARCHAR(200),
    winner_ioc VARCHAR(200),
    winner_age VARCHAR(200),
    loser_id VARCHAR(200),
    loser_seed VARCHAR(200),
    loser_entry VARCHAR(200),
    loser_name VARCHAR(200),
    loser_hand VARCHAR(200),
    loser_ht VARCHAR(200),
    loser_ioc VARCHAR(200),
    loser_age VARCHAR(200),
    score VARCHAR(200),
    best_of VARCHAR(200),
    round VARCHAR(200),
    minutes VARCHAR(200),
    w_ace VARCHAR(200),
    w_df VARCHAR(200),
    w_svpt VARCHAR(200),
    w_1stIn VARCHAR(200),
    w_1stWon VARCHAR(200),
    w_2ndWon VARCHAR(200),
    w_SvGms VARCHAR(200),
    w_bpSaved VARCHAR(200),
    w_bpFaced VARCHAR(200),
    l_ace VARCHAR(200),
    l_df VARCHAR(200),
    l_svpt VARCHAR(200),
    l_1stIn VARCHAR(200),
    l_1stWon VARCHAR(200),
    l_2ndWon VARCHAR(200),
    l_SvGms VARCHAR(200),
    l_bpSaved VARCHAR(200),
    l_bpFaced VARCHAR(200),
    winner_rank VARCHAR(200),
    winner_rank_points VARCHAR(200),
    loser_rank VARCHAR(200),
    loser_rank_points VARCHAR(200)
);


/* Import data with python script
import pymysql
import csv
import os

def populate_database():
    # Database connection setup
    connection = pymysql.connect(host='localhost', user='root', password='***', database='atp')
    cursor = connection.cursor()

    # Path to the folder containing the 25 files
    folder_path = '/Data/SQL/ATP/CSV/'

    # Loop through each CSV file in the folder
    for filename in os.listdir(folder_path):
        if filename.endswith('.csv'):
            file_path = os.path.join(folder_path, filename)
            print(f"Processing file: {file_path}")
            with open(file_path, 'r') as file:
                reader = csv.reader(file)
                next(reader)  # Skip the header row

                for row in reader:
                    cursor.execute(
                        """
                        INSERT INTO tennis_matches (
                            tourney_id, tourney_name, surface, draw_size, tourney_level, 
                            tourney_date, match_num, winner_id, winner_seed, winner_entry, 
                            winner_name, winner_hand, winner_ht, winner_ioc, winner_age,
                            loser_id, loser_seed, loser_entry, loser_name, loser_hand, 
                            loser_ht, loser_ioc, loser_age, score, best_of, round, minutes, 
                            w_ace, w_df, w_svpt, w_1stIn, w_1stWon, w_2ndWon, w_SvGms,
                            w_bpSaved, w_bpFaced, l_ace, l_df, l_svpt, l_1stIn, l_1stWon,
                            l_2ndWon, l_SvGms, l_bpSaved, l_bpFaced, winner_rank,
                            winner_rank_points, loser_rank, loser_rank_points
                        ) 
                        VALUES (
                            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                            %s, %s, %s, %s
                        )
                        """, row
                    )

    # Commit changes to the database and close the connection
    connection.commit()
    cursor.close()
    connection.close()
    print("Database population complete!")
 */


-- Copy data from original table to staging table
CREATE TABLE tm AS SELECT * FROM tennis_matches;


use ipl;

select count(*) from matches;
select count(*) from deliveries;

-- Q1 - Top 5 players with most player of the match awards
SELECT player_of_match, COUNT(player_of_match) AS count 
FROM matches
GROUP BY player_of_match
ORDER BY count DESC LIMIT 5;

-- Q2 - Matches won by each team in each season
SELECT season, winner as team , count(*) as matches_won
FROM matches 
GROUP BY season, winner;

-- Q3 - AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET (total avg strike rate of all player's avg strike rate)
SELECT AVG(strike_rate) as avg_strike_rate_ipl
FROM (
SELECT batsman, (SUM(total_runs)/COUNT(ball) * 100) AS strike_rate
FROM deliveries
GROUP BY batsman) AS batsmen_stats;


-- Q4 - NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTING SECOND
SELECT batting_first, COUNT(*) AS matches_Won
FROM(
SELECT
	CASE WHEN win_by_runs > 0 then team1
    ELSE team2
    END AS batting_first
    FROM matches
    WHERE winner != "Tie")
    AS batting_first_teams
    GROUP BY batting_first;

SELECT batting_second, COUNT(*) AS matches_Won
FROM(
SELECT
	CASE WHEN win_by_wickets > 0 then team2
    ELSE team1
    END AS batting_second
    FROM matches
    WHERE winner != "Tie")
    AS batting_second_teams
    GROUP BY batting_second;

-- Q5 - WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?

SELECT batsman, (SUM(batsman_runs)/COUNT(*) * 100) AS strike_rate
FROM deliveries
GROUP BY batsman
HAVING SUM(batsman_runs) >= 200
ORDER BY strike_rate DESC;

-- Q6 - HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?
SELECT batsman, count(*) AS no_of_times_dismissed
FROM deliveries 
WHERE bowler like '%Malinga%' AND player_dismissed IS NOT NULL 
GROUP BY batsman;

SELECT player_dismissed, count(*) AS no_of_times_dismissed
FROM deliveries 
WHERE bowler like '%Malinga%' AND player_dismissed IS NOT NULL
GROUP BY player_dismissed;

-- Q7 - WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXES COMBINED) HIT BY EACH BATSMAN?
SELECT batsman, 
	   AVG(CASE WHEN batsman_runs = 4 OR batsman_runs = 6 THEN 1 
				ELSE 0
                END)*100 as avg_boundaries
FROM deliveries
GROUP BY batsman;


-- Q8 - WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?
SELECT M.team1, M.season, AVG(CASE WHEN D.batsman_runs = 4 OR D.batsman_runs = 6 THEN 1 ELSE 0 END)*100 AS avg_boundary_team
FROM matches M
INNER JOIN deliveries D
ON M.id = D.match_id
GROUP BY M.team1, M.season;


-- Q9 - WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?
SELECT season, batting_team, max(total_runs) as highest_partnership
FROM(
SELECT season, batting_team, partnership, SUM(total_runs) as total_runs
FROM(
SELECT season, match_id, batting_team, over_no, 
	   SUM(batsman_runs) AS partnership,
       SUM(batsman_runs) + SUM(extra_runs) AS total_runs
FROM deliveries, matches
WHERE deliveries.match_id = matches.id
GROUP BY season, match_id, batting_team, over_no) AS team_scores
GROUP BY season, batting_team, partnership) AS highest_partnership
GROUP BY season, batting_team;


-- Q10 - HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?
SELECT match_id, bowling_team, SUM(extra_runs) AS extras
FROM deliveries
GROUP BY match_id, bowling_team; 

-- Q11 - WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLE MATCH?
SELECT match_id, bowler, COUNT(player_dismissed) AS wicket_taken
FROM deliveries
GROUP BY match_id, bowler
ORDER BY wicket_taken DESC LIMIT 1;

-- Q12 - HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?
SELECT city, winner,
COUNT(CASE WHEN win_by_runs>0 THEN team1 ELSE team2 END) AS win_count
FROM matches
WHERE result!='Tie'
GROUP BY city, winner;

-- Q13 - HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?
SELECT season, toss_winner, COUNT(toss_winner) AS toss_wins
FROM matches
GROUP BY season, toss_winner;

-- Q14 - HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?
SELECT player_of_match, COUNT(player_of_match) AS total_wins
FROM matches
GROUP BY player_of_match
ORDER BY total_wins DESC;


-- Q15 - WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?
SELECT match_id, inning, over_no, AVG(total_runs) AS avg_runs_scored
FROM deliveries
GROUP BY match_id, inning, over_no;


-- Q16 - WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?
SELECT match_id, batting_team, SUM(total_runs) AS total_score
FROM deliveries
GROUP BY match_id, batting_team
ORDER BY total_score DESC LIMIT 1;

-- Q17 - WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?
SELECT match_id, batsman, SUM(batsman_runs) AS batsman_total_run
FROM deliveries
GROUP BY match_id, batsman
ORDER BY batsman_total_run DESC LIMIT 1;

























#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE games, teams"

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != "winner" ]]
  then
    # get winner tim_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")

    # if not found
    if [[ -z $TEAM_ID ]]
    then
        # insert team
      INSERT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$winner')")
      if [[ $INSERT_RESULT = 'INSERT 0 1' ]]
      then
        echo inserted into teams: $winner
      fi
    fi
    
    # get opponent tim_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    # if not found
    if [[ -z $TEAM_ID ]]
    then
        # insert team
      INSERT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$opponent')")
      if [[ $INSERT_RESULT = 'INSERT 0 1' ]]
      then
        echo inserted into teams: $opponent
      fi
    fi

  fi
done

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != 'winner' ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    # INSERT GAMES
    echo $($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals
  ) VALUES ('$year','$round','$WINNER_ID','$OPPONENT_ID','$winner_goals','$opponent_goals')")
  fi
done

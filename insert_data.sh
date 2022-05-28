#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
CLEAR_RESULT=$($PSQL "truncate games, teams;")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ ! $YEAR = 'year' ]]
  then
    #insert team info
      #check winner/opponent teams not repeated
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
      
      if [[ -z $WINNER_ID ]]
      then
        #insert winner team
        INSERT_WINNER_RES=$($PSQL "insert into teams(name) values('$WINNER');")
        WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
      fi

      if [[ -z $OPPONENT_ID ]]
      then
        #insert opponent team
        INSERT_OPPONENT_RES=$($PSQL "insert into teams(name) values('$OPPONENT');")
        OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
      fi
      
    #insert game info
      #
      INSERT_GAMES_RESULT=$($PSQL "insert into games(year,round,winner_id,winner_goals,opponent_goals,opponent_id)
      values($YEAR,'$ROUND',$WINNER_ID,$WINNER_GOALS,$OPPONENT_GOALS,$OPPONENT_ID);")
  fi
done
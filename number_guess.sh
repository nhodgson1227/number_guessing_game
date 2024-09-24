#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
NUMGUESS=0
GUESS=0

# Generate Random Number
SECRET_NUM=$RANDOM
let "SECRET_NUM %= 1000"

# Get User's name
echo -e "Enter your username:"
read MYNAME
# Check for user in database
USER_NAME=$($PSQL "SELECT user_name FROM players WHERE user_name = '$MYNAME'")
# If user does not exist
if [[ -z $USER_NAME ]]
then
  # create a new user
  INSERT_USER_RESULT=$($PSQL "INSERT INTO players(user_name) VALUES('$MYNAME')")
  echo -e "Welcome, $MYNAME! It looks like this is your first time here."
else
  # get games played
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM players WHERE user_name = '$USER_NAME'")
  # get best game
  BEST_GAME=$($PSQL "SELECT best_game FROM players WHERE user_name = '$USER_NAME'")
  echo -e "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

  #### ------------------ Guess the Number ------------------ ####

while [[ $GUESS -ne $SECRET_NUM ]]; do
  # Read a new guess
  echo "Guess the secret number between 1 and 1000:"
  read GUESS
  # Check if input was an integer
  echo $GUESS
  # Increment Guesses
  NUMGUESS=$((NUMGUESS+1))

    # If higher
  if [[ $GUESS -gt $SECRET_NUM ]]
  then
    echo -e "\nIt's lower than that, guess again:"
  fi

  # If lower
  if [[ $GUESS -lt $SECRET_NUM ]]
  then
    echo -e "\nIt's higher than that, guess again:"
  fi

done

 # When correct, loop will exit.
echo -e "\nYou guessed it in $NUMGUESS tries. The secret number was $SECRET_NUM. Nice job!"

# Increment Games Played on DB
GAME_INC=$($PSQL "UPDATE players SET games_played=games_played + 1 WHERE user_name = '$USER_NAME'")
# Check Best Game and Update if necessary
if [[ $BEST_GAME -gt $NUMGUESS ]]
then
  BEST_INC=$($PSQL "UPDATE players SET best_game = $NUMGUESS WHERE user_name = '$USER_NAME'")
fi
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
NUMGUESS=0
GUESS=0

# Generate Random Number
SECRET_NUM=$RANDOM
let "SECRET_NUM %= 1000"

# Get User's name
read -p "Enter your username: " MYNAME
# Check for user in database
USER_NAME=$($PSQL "SELECT user_name FROM players WHERE user_name = '$MYNAME'")
# If user does not exist
if [[ -z $USER_NAME ]]
then
  # create a new user
  INSERT_USER_RESULT=$($PSQL "INSERT INTO players(user_name) VALUES('$MYNAME')")
  echo -e "\nWelcome, $MYNAME! It looks like this is your first time here."
else
  # get games played
  # CODE
  # get best game
  # CODE
  echo -e "\nWelcome back, $USER_NAME! You have played <games_played> games, and your best game took <best_game> guesses."
fi

  #### ------------------ Guess the Number ------------------ ####

while [ $GUESS -ne $SECRET_NUM ]; do
  # Read a new guess
  read -p "Guess the secret number between 1 and 1000:" GUESS
  # Check if input was an integer
  echo $GUESS
  # Increment Guesses
  NUMGUESS=$((NUMGUESS+1))

    # If higher
  if [ $GUESS -gt $SECRET_NUM ]
  then
    echo -e "\nIt's lower than that, guess again:"
  fi

  # If lower
  if [ $GUESS -lt $SECRET_NUM ]
  then
    echo -e "\nIt's higher than that, guess again:"
  fi

done

 # When correct, loop will exit.
echo -e "\nYou guessed it in $NUMGUESS tries. The secret number was $SECRET_NUM. Nice job!"

# Increment Games Played on DB
# Check Best Game and Update if necessary
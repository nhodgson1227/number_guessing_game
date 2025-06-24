#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
MIN=1
MAX=1000
NUMGUESS=0
GUESS=0

# Generate Random Number
SECRET_NUM=$(( RANDOM % $MAX + $MIN ))

#DEBUG echo "$SECRET_NUM" 
# Get User's name
echo -e "Enter your username:"
read MYNAME

# Check for user in database
USER_NAME=$($PSQL "SELECT user_name FROM players WHERE user_name = '$MYNAME'")
# If user does not exist
if [[ -z $USER_NAME ]]
then
  # create a new user
  INSERT_USER_RESULT=$($PSQL "INSERT INTO players(user_name, games_played, best_game) VALUES('$MYNAME', 0, 0)")
  echo -e "InsertUser: $INSERT_USER_RESULT" >> number_guess.log
  USER_NAME=$MYNAME
  echo -e "Welcome, $USER_NAME! It looks like this is your first time here."
  BEST_GAME=1000
  GAMES_PLAYED=0
else
  # get games played
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM players WHERE user_name = '$USER_NAME'")
  # get best game
  BEST_GAME=$($PSQL "SELECT best_game FROM players WHERE user_name = '$USER_NAME'")
  echo -e "Games_Played: $GAMES_PLAYED, Best_Game: $BEST_GAME" >> number_guess.log
  echo -e "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

  #### ------------------ Guess the Number ------------------ ####
echo "Guess the secret number between $MIN and $MAX:"
while [[ $GUESS -ne $SECRET_NUM ]]; 
do
  # Read a new guess
  read GUESS
  # Check if input was an integer
  while [[ $((GUESS)) != $GUESS ]]; 
  do
    echo "That is not an integer, guess again:"
    read GUESS
  done 

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

# Increment Games Played on DB
GAME_INC=$($PSQL "UPDATE players SET games_played=games_played + 1 WHERE user_name = '$USER_NAME'")

# Check Best Game and Update if necessary
if [[ $BEST_GAME -gt $NUMGUESS ]]
then
  BEST_INC=$($PSQL "UPDATE players SET best_game = $NUMGUESS WHERE user_name = '$USER_NAME'")
  BEST_GAME=$NUMGUESS
fi

echo -e "MYNAME: $MYNAME USERNAME: $USER_NAME NumGuess: $NUMGUESS BestGame: $BEST_GAME \n" >> number_guess.log

echo "You guessed it in $NUMGUESS tries. The secret number was $SECRET_NUM. Nice job!"
exit
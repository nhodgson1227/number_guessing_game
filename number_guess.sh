#!/bin/bash

PSQL="psql --USER_NAME=freecodecamp --dbname=<database_name> -t --no-align -c"
NUMGUESS=0

# Generate Random Number

# Get User's name
read -p "Enter your USER_NAME: " USER_NAME

# Check for user in database
  # If user exists
    # get games played
    # get best game
    echo -e "\nWelcome back, $USER_NAME! You have played <games_played> games, and your best game took <best_game> guesses."
  
  # If user doesn't exist
    # Create new user
    echo -e "\nWelcome, $USER_NAME! It looks like this is your first time here."

  #### Guess the Number ####
  read -p "Guess the secret number between 1 and 1000:" $GUESS
  # Check if input was an integer
  
  NUMGUESS=$NUMGUESS + 1
  # If higher
  echo -e "\nIt's lower than that, guess again:"
  # If lower
  echo -e "\nIt's higher than that, guess again:"
  # If correct
  echo -e "\nYou guessed it in $NUMGUESS tries. The secret number was <secret_number>. Nice job!"
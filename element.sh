#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#The first argument must be an atomic_number in the database.
GIVE_INFO () {
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$1")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
  echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

#Check for arguments.
if [[ -z $1 ]]
then
  #if no element, print prompt.
  echo "Please provide an element as an argument."
else
  #check what kind of argument was entered.
  #if argument is a number
  if [[ $1 =~ ^[1-9]+$ ]]
  then
    #get atomic_number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    #if not found
    if [[ -z $ATOMIC_NUMBER ]]
    then
      # print prompt
      echo "I could not find that element in the database."
    else
      #Fetch and print info
      GIVE_INFO $ATOMIC_NUMBER
    fi
  else
    #otherwise get atomic_number by symbol.
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    #if not found
    if [[ -z $ATOMIC_NUMBER ]]
    then
      # get atomic_number by name.
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
      # if still not found
      if [[ -z $ATOMIC_NUMBER ]]
      then
        # print prompt
        echo "I could not find that element in the database."
      else
        #Fetch and print info
        GIVE_INFO $ATOMIC_NUMBER
      fi
    else
      #Fetch and print info
      GIVE_INFO $ATOMIC_NUMBER
    fi
  fi
fi


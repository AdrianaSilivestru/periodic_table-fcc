#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#check if there is an arg
if [ "$#" -eq 0 ]
then
  echo "Please provide an element as an argument."
else
  ARG=$1
  #get info from db for arg (element)
  RESULT_INFO=$($PSQL "
  SELECT 
    e.atomic_number, 
    e.name, 
    e.symbol, 
    t.type, 
    p.atomic_mass, 
    p.melting_point_celsius, 
    p.boiling_point_celsius
  FROM elements e
  INNER JOIN properties p ON e.atomic_number = p.atomic_number
  INNER JOIN types t ON p.type_id = t.type_id
  WHERE 
    e.atomic_number::text='$ARG' 
    OR e.symbol ILIKE '$ARG' 
    OR e.name ILIKE '$ARG';
  ")
  #echo $RESULT_INFO
  #check if RESULT_INFO is empty
  if [[ -z $RESULT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    #extract the cols from RESULT_INFO in specific vars
    echo "$RESULT_INFO" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi


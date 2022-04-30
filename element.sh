#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

QUERY_RESULT=""
QUERY_STRING="SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM properties LEFT JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) "

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY_RESULT=$($PSQL "$QUERY_STRING WHERE atomic_number=$1;"); 
  elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]] 
  then
    QUERY_RESULT=$($PSQL "$QUERY_STRING WHERE symbol='$1';"); 
  else
    QUERY_RESULT=$($PSQL "$QUERY_STRING WHERE name='$1';"); 
  fi

  if [[ -z $QUERY_RESULT ]]
  then
    echo -e "I could not find that element in the database."
  else
    echo "$QUERY_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done  

  fi
fi
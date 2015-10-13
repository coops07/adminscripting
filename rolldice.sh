#!/bin/bash
# this script gets 2 numbers from the command line
# a count of dice and count of sides per dice
# it prints out the results of a roll of those dice

declare -i count #define variable type (int)
declare -i sides

count=2 # default of 2 dice
sides=6 # default of 6 sides to a dice

if [ $# -ne 2 ]; then
    echo "You didn't give me a count of dice and a number of sides/die"
    echo "Using the deaults of $count dice with $sides sides apiece matey"
else
    count="$1"
    if [[ "$count" -lt 1 || "$count" -gt 50 ]]; then
        echo "Invalid count of dice, keep it between 1 and 50, you scalleywag"
        exit 2
    fi
    sides="$2"
    if [[ "$sides" -lt 3 || "$sides" -gt 20 ]]; then
        echo "Invalid count of sides, keep it between 3 and 20, you scalleywag"
        exit 2
    fi
fi

sum=0
while [ $count -gt 0 ]; do
    roll=$(( $RANDOM % $sides +1 ))
    sum=$(( $sum + $roll ))
    echo "Rolled $roll"
    count=$((count - 1))
done
echo "You rolled a total of $sum"
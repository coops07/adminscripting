#!/bin/bash
#this script will demonstrate creating and using some variables

#create the colours array
colours=("red" "green" "blue")

#create the animals
declare -A animals
animals=(["red"]="cardinal" ["green"]="frog" ["blue"]="lobster")

#Display the arrays
echo "Elements 0 of the colors array has the value ${colours[0]}"
echo "Elements 1 of the colors array has the value ${colours[1]}"
echo "Elements 2 of the colors array has the value ${colours[2]}"
echo "The array contains ${colours[@]}"
echo "The red element of the animals array has the value ${animals[red]}"
echo "The green element of the animals array has the value ${animals[green]}"
echo "The blue element of the animals array has the value ${animals[blue]}"
echo "The animals array contains ${animals[@]}"

#Create a num variable to use as an index
read -p "Which element of the colours array would you like to use? " num

#Display some data elemnts from both arrays using the index num
echo "The first colour in the array is ${colours[$num]} and it can"
echo " be used to find the ${colours[$num]} animal which is the "
echo " ${animals[${colours[$num]}]}"

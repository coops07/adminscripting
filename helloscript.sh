#!/bin/bash

# helloscript.sh
# display the string Hello World

# this is a silly way of creating the output string
echo -n "helb wold" | sed -e "s/b/o/g" -e "s/l/ll/" -e "s/ol/orl/" | tr "h" "H" | tr "w" "W"

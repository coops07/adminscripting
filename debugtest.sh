#!/bin/bash
# this script demonstrates doing a function
# the function sets a debug variable to
#  the value passed into the function

myDebugValue=56

function setDebug {
    echo "Setting debug to $debug to $1"
    debug=$1
}

setDebug $myDebugValue
setDebug 0
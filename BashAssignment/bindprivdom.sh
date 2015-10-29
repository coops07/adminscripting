#!/bin/bash
#
# Administrative Scripting - COMP2101 - bash Assignment
#
# This script installs and configures bind to serve as a private domain

#check to see if the bind package is installed
#if bind is not found then install the package
#(dpkg-query -s bind9 && echo "" && echo "bind is installed") || (echo "" && echo "Installing bind..." && sudo apt-get install bind9 -y)
if [[ $(dpkg-query -S bind9) ]]; then
    echo
    echo "bind has already been installed"
    echo
else
    echo
    echo "installing bind..."
    echo
    echo
    sudo apt-get install bind9 -y
    echo
    echo "bind has now been installed" 
    echo
fi

#ask the user to enter a domain name
read -p "Please enter a domain name: " userdomname
#bad name detection?

#create a user defined domain or exit the script if the domain already exists
if [ ! -e /etc/bind/db.$userdomname ]; then
    echo
    echo "Creating domain zone for $userdomname..."
    sudo cp /etc/bind/db.empty /etc/bind/db.$userdomname
    #error detection?
    echo "Zone file created"
    echo
else
    echo
    echo "That domain already exists you newt! I shall cast you into a fiery chasm."
    echo
    exit 0
fi
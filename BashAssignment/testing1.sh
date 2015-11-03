#!/bin/bash
#
# Administrative Scripting - COMP2101 - bash Assignment
# By Brendan Cooper - November 2, 2015
#
# This script installs and configures bind to serve as a private domain

#variables
origindate=$(date)

#check to see if the bind package is installed
#if bind is not found then install the package
#(dpkg-query -s bind9 && echo "" && echo "bind is installed") || (echo "" && echo "Installing bind..." && sudo apt-get install bind9 -y)
if [[ $(dpkg-query -S bind9) ]]; then
    echo
    echo "Bind has already been installed"
    echo
else
    echo
    echo "Installing bind..."
    echo
    echo "Updating repo..."
    sudo apt-get update
    echo
    echo
    sudo apt-get install bind9 -y
    echo
    echo "Bind has now been installed" 
    echo
fi


#ask the user to enter a domain name and check for errors/no input
#noname=""
#while [ noname = "" ]; do
    read -p "Please enter a domain name: " userdomname 
 #   noname=($userdomname)
#done
#no name/error  detection?

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


#modify the newly created zone file
#
echo "Configuring zone file..."
#comments
sudo sed -i "1 c\;" /etc/bind/db.$userdomname
sudo sed -i "3 c\;Zone file - $userdomname" /etc/bind/db.$userdomname
sudo sed -i "4 c\;Created on $origindate" /etc/bind/db.$userdomname
#time to live 1 week
sudo sed -i "6 c\$TTL     172800" /etc/bind/db.$userdomname
#sudo sed -i "/TTL/c\$TTL     604800" /etc/bind/db.$userdomname

#set origin, admin email, and configure hostnames
db_wwwip="192.168.47.91"
db_mailip="192.168.59.5"
sudo sed -i "/SOA/c\@       IN      SOA      ns1.$userdomname. hostmaster@$userdomname. (" /etc/bind/db.$userdomname
sudo sed -i "/Serial/c\                        2015110200      ; Serial" /etc/bind/db.$userdomname
sudo sed -i "$ a\ns1     IN      A       127.0.0.1" /etc/bind/db.$userdomname
sudo sed -i "$ a\;" /etc/bind/db.$userdomname
sudo sed -i "$ a\www     IN      A       $db_wwwip" /etc/bind/db.$userdomname
sudo sed -i "$ a\mail    IN      A       $db_mailip" /etc/bind/db.$userdomname
echo
echo "Configuration complete"
echo
#verify configuration for syntax
echo "Verifying configuration..."
if [[ $(named-checkzone $userdomname db.$userdomname) ]]; then
    echo
    echo "Verification sucessful"
    echo
else
    echo "Verification failed"
    echo
    echo "Exiting program..."
    exit 0
fi


#create reverse zone files
echo
echo "Creating reverse zone files..."
echo
#create and configure www reverse zone
sudo cp /etc/bind/db.$userdomname /etc/bind/db.$db_wwwip
sudo sed -i '14,18d' /etc/bind/db.$db_wwwip
sudo sed -i "$ a\@	    IN	    NS	ns1.$userdomname." /etc/bind/db.$db_wwwip
sudo sed -i "$ a\2	    IN	    PTR	ns1.$userdomname." /etc/bind/db.$db_wwwip

#create and configure mail reverse zone
sudo cp /etc/bind/db.$userdomname /etc/bind/db.$db_mailip
sudo sed -i '14,18d' /etc/bind/db.$db_mailip
sudo sed -i "$ a\@	    IN	    NS	    ns1.$userdomname." /etc/bind/db.$db_mailip
sudo sed -i "$ a\2	    IN	    PTR	    ns1.$userdomname." /etc/bind/db.$db_mailip
echo "Zone files created"
echo
#verify configurations for syntax
echo "Verifying reverse zone files"
echo
if [[ $(named-checkzone $db_wwwip db.$db_wwwip && named-checkzone $db_mailip db.$db_mailip) ]]; then
    echo "Verification sucessful"
    echo
else
    echo "Verification failed"
    echo
    echo "Exiting program..."
    exit 0
fi


#add the new zones to named.conf.local
echo
echo "Finalizing configuration..."
sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local2
echo
# $userdomname zone
sudo sed -i "$ a\zone "'"$userdomname:"'" {" /etc/bind/named.conf.local2
#sudo echo "zone \"$userdomname\" {" >> /etc/bind/named.conf.local2
#sudo sed -i "$ a\type master;" /etc/bind/named.conf.local2
#sudo sed -i "$ a\file "/etc/bind/db.$userdomname";" /etc/bind/named.conf.local2
#sudo sed -i "$ a\};" /etc/bind/named.conf.local2

# www zone
sudo sed -i "$ a\zone "$db_wwwip.in-addr.arpa" {" /etc/bind/named.conf.local2
sudo sed -i "$ a\type master;" /etc/bind/named.conf.local2
sudo sed -i "$ a\file "/etc/bind/db.$db_wwwip";" /etc/bind/named.conf.local2
sudo sed -i "$ a\};" /etc/bind/named.conf.local2

# mail zone
sudo sed -i "$ a\zone "$db_mailip.in-addr.arpa" {" /etc/bind/named.conf.local2
sudo sed -i "$ a\type master;" /etc/bind/named.conf.local2
sudo sed -i "$ a\file "/etc/bind/db.$db_mailip";" /etc/bind/named.conf.local2
sudo sed -i "$ a\};" /etc/bind/named.conf.local2

echo "Configuration complete"
echo
#reload Bind
echo "Restarting service..."
echo
sudo rndc reload
echo
echo "Done"
echo
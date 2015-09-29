#!/bin/bash
# this script creates a trivial directory with a few files to use as test data for the mybackup.sh script

cd ~
mkdir mydata
cp /etc/hosts mydata
cp /etc/resolv.conf mydata
cp /etc/motd mydata
ln -s hosts mydata/hostslink

ls -l mydata

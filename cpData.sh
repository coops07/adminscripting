#!/bin/bash
#This script copies the directory mydata in my home directory
#to a backup directory name mydata-backup
#It preserves any special files

cd ~/mydata
mkdir ~/mydata-backup
tar cf - .| (cd ~/mydata-backup; tar xf -)

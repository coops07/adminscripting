#!/bin/bash
#
#if [ test -f file1 ]
#then
#	echo hi
#fi
mynum=9
while [ mynum==9 ] 
then
	test $((mynum -eq 9))
	echo yo it worked
done
echo nope

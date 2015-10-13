#!/bin/bash
# this script summarizes the number of processes
# by user and warns us if the user named
# 'nobody' has processes running

declare -A myProcs

for currentprocessuser in `ps -eo user|tail -n +2`; do
    myProcs[$currentprocessuser]=$(( ${myProcs[$currentprocessuser]} + 1 ))
done

for user in ${!myProcs[@]}; do
    echo "User $user has ${myProcs[$user]} processes running"
done
if [[ "${myProcs[nobody]}" -gt 0]]; then
    echo "User nobody has processes!"
fi
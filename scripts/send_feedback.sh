#!/bin/bash

#Usage:
#First argument: Course name (e.g. programmiertechnik)
#Second argument: Assignment name (e.g. ps1)

if [ ! $# -eq 2 ]; then
	echo "USAGE: $0 course assignment"
	exit 1
fi

if [ ! -d /home/jupyter/instructor-workspaces/"$1"/feedback ]; then
	echo ERROR: No generated feedback for course $1 was found.
	exit 1
fi

cd /home/jupyter/instructor-workspaces/"$1"/feedback/

counter=0

for dir_user in */ ; do

	FB_PATH='/var/lib/docker/volumes/jupyterhub-user-'''$dir_user'''_data/_feedback'

	mkdir -p $FB_PATH/"$1"/

	if [ ! -d "$dir_user""$2" ]; then
		echo ERROR: No generated feedback for assignment $2 was found.
	else
		cp -R "$dir_user""$2" $FB_PATH/"$1"/
		echo "Moved feedback into:" $FB_PATH/"$1"/"$2"
		counter=$((counter+1))
	fi
done

echo "Feedback was successfully moved for" $counter "students"

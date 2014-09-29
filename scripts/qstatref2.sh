#!/bin/sh
COUNTER=1
while [ $COUNTER ]; do
	clear
	qstat
	sleep 60
done

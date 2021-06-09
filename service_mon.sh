#!/bin/bash

##### 
# This script monitor the service which should be provided as a first  argument
# and start it if it is not running. In additional mail to the root user
# will be sent in case the servece has been restarted by the script
#####

if [ -z $1 ]
then
	echo "Service name should be provided as a first argument to this script"
	exit 1
else
	SERVICE=$1
fi


if ps aux | grep $SERVICE | grep -v grep | grep -v service_mon.sh
then
	echo "$SERVICE is running and will be auto restared in case it stops"
else
	echo "$SERVICE not be found as a process"
	echo "Ensure $SERVICE is running and try again"
	echo "The command ps aux | grep $SERVICE should show the service up and running"
	exit 1
fi

function monitor_service {
	while ps aux | grep $SERVICE | grep -v grep | grep -v service_mon.sh
	do	
		sleep 5
	done
}

function restart_servcie {
	service $SERVICE start
        logger service_mon: $SERVICE was restarted by the monitoring script
        mail -s "service_mon: $SERVICE restarted at $(date '+%d-%m-%Y %H:%M')" root < .
}

while true
do
	sleep 5
	monitor_service > /dev/null
	restart_servcie 
done

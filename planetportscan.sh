#!/bin/bash
echo -----------------------------------
for ip in 127.0.{1..255}.{1..255}; do
echo "$ip started"
for port in {80..80}; do
	/usr/bin/screen -dmS nmap-$ip-$port nmap -p --host-timeout 1 $port $ip
done
done
echo -----------------------------------
exit 0

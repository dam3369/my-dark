#!/bin/bash

gateway=`netstat -r | grep ^default | awk '{print $2}'`;
#gateway=`$(perl mygateway.pl)`;

echo "Gateway:" $gateway
mask=`echo $gateway | cut -d"." -f1-3`
echo "Mask:" $mask

for x in $(seq 1 +1 254)

do
    ping -c 1 -t 1 $mask.$x
done

arp -a

#!/bin/bash

echo "-------------------------"
echo "Finding your gateway. Loading..."
echo "-------------------------"

#gateway=`netstat -r | grep ^default | awk '{print $2}'`;
#gateway=`$(perl mygateway.pl)`;
gateway=`netstat -rn | awk '/default/ {print $2}'`;

echo "Gateway:" $gateway
mask=`echo $gateway | cut -d"." -f1-3`
echo "Mask:" $mask

echo " "
echo "-------------------------"
echo "Select your Wi-fi interface name"
echo "-------------------------"


#ifconfig | grep flags= | cut -d":" -f1-1
networksetup -listallhardwareports | grep -v "Address"
echo " "
echo "-------------------------"
echo "Type interface: (i.e. en1)"
echo "-------------------------"
read cardid

read -r -p "T'as faim? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "mange!!"
        ;;
    *)
        echo "tu devrais..."
        ;;
esac

for x in $(seq 1 +1 254)

do
    ping -c 1 -t 1 $mask.$x > /dev/null 2>&1
    countdown=`expr 254 - $x`
    echo -ne " Ready in $countdown \033[0K\r"
done

ARP="$(arp -a | grep -v incomplete | grep $cardid)"

function selectmac() {
echo -e "$ARP"

# | cut -d" " -f4-
echo " "
echo "-------------------------"
echo "Type xx:xx:xx:xx:xx:xx "
echo "-------------------------"
read mac
sudo ifconfig $cardid ether $mac

echo " "
echo "-------------------------"
echo "Ifconfig "
echo "-------------------------"

ifconfig | grep $mac

networksetup -setairportpower airport off
networksetup -setairportpower airport on 

echo "-------------------------"
echo "Hold on a sec"
echo "-------------------------"
sleep 7
echo "Trying ping"
echo "-------------------------"
ping -c 5 google.com

echo " "
echo "-------------------------"
echo "Try an other MAC? (Ctrl+C to exit)"
echo "-------------------------"
read retry

selectmac

}

selectmac


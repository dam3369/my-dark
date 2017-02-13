#!/bin/sh
for x in $(seq 100 +1 155)
do
  ping -c 1 192.168.1.$x | grep ttl
done

for x in $(seq 1 +1 100)
do
  ping -c 1 192.168.1.$x | grep ttl
done

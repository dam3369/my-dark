#!/bin/bash
hosts=(
"92.91.151.10"
# "server2"
)
for host in "${hosts[@]}"
do
        echo "=========================================="
        echo "Scanning $host"
        echo "=========================================="
            for port in {1..65535}
            do
            echo "" > /dev/tcp/$host/$port && echo "Port $port is open"
    done 2>/dev/null
done

#!/bin/sh
#
# my_ip - one-liner to get a list of local IP addresses assigned
#

ip addr | awk '$1 == "inet" && $2 != "127.0.0.1/8" { split ($2, a, "/"); print a[1]  }'

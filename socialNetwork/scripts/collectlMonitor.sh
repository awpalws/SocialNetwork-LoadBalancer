#!/bin/bash

echo -e "\e[33mstart fine-grained CPU monitoring using collectl\e[0m"

# remove the previous collectl data in Control node
rm /tmp/node*

for i in "node-0" "node-1" "node-2" "node-3" "node-4" "node-5"
do
	echo 'come here1'
	ssh $i '
	rm /tmp/node*
	hostname
	collectl -i 0.1 -F30 -sCdnZ -oTm -f /tmp &> /dev/null &
	'
done
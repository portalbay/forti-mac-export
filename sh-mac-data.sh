#!/bin/bash

path="/project_path/mac"

com_str=$(cat $path/.creds | grep snmp | cut -f 2 -d =)

while read line ;do
	switch=`echo $line | cut -f 1 -d,`
	ip=`echo $line | cut -f 2 -d,`
	method=`echo $line | cut -f 3 -d,`


	
	echo "Reading $switch $ip, export method $method..."
	
	if [ $method == 1 ]
	then
		echo "1 Found"
		snmpwalk -v2c -c $com_str $ip iso.3.6.1.2.1.17.7.1.2.2.1.1.1 | /bin/sed 's/iso.3.6.1.2.1.17.7.1.2.2.1.1.1//g' > $path/mac-data/$switch.mac &
                snmpwalk -v2c -c $com_str $ip iso.3.6.1.2.1.17.7.1.2.2.1.2.1 | /bin/sed 's/1.3.6.1.2.1.17.7.1.2.2.1.2.1//g' > $path/mac-data/$switch.if &
	elif [ $method == 2 ]
	then
		echo "2 Found"
		snmpwalk -v2c -c $com_str $ip  iso.3.6.1.2.1.17.7.1.2.2.1.2 | /bin/sed 's/iso.3.6.1.2.1.17.7.1.2.2.1.2//g' > $path/mac-data/$switch.mac &
	elif [ $method == 3 ]
	then
		echo "3 Found"
                snmpwalk -v2c -c $com_str $ip  iso.3.6.1.2.1.17.4.3.1.1 | /bin/sed 's/iso.3.6.1.2.1.17.4.3.1.1//g' > $path/mac-data/$switch.mac &
                snmpwalk -v2c -c $com_str $ip iso.3.6.1.2.1.17.4.3.1.2 | /bin/sed 's/iso.3.6.1.2.1.17.4.3.1.2//g' > $path/mac-data/$switch.if &

	else
		echo "Invalid Method in switch.dat"
		exit 0
	fi

done<$path/switches.dat




#Notes

#Method 1 1.3.6.1.2.1.17.7.1.2.2.1.1.1
#Method 2 1.3.6.1.2.1.17.7.1.2.2.1.2
#Method 3 1.3.6.1.2.1.17.4.3.1.1,1.3.6.1.2.1.17.4.3.1.2

#legacy switches

#snmpwalk -v2c -c  192.168.7.2 iso.3.6.1.2.1.17.7.1.2.2.1.1.1
#snmpwalk -v2c -c  192.168.7.2 iso.3.6.1.2.1.17.7.1.2.2.1.2.1

#newer switches

#snmpwalk -v2c -c  iso.3.6.1.2.1.17.7.1.2.2.1.1.1 192.168.10.2
#snmpwalk -v2c -c  iso.3.6.1.2.1.17.7.1.2.2.1.2.1 192.168.10.2

#snmpwalk -v2c -c  iso.3.6.1.2.1.17.7.1.2.2.1.1.1 | /bin/sed 's/iso.3.6.1.2.1.17.7.1.2.2.1.1.1//g' > mac-data/$switch.mac &
#snmpwalk -v2c -c  $ip iso.3.6.1.2.1.17.7.1.2.2.1.2.1 | /bin/sed 's/iso.3.6.1.2.1.17.7.1.2.2.1.2.1//g' > mac-data/$switch.if &

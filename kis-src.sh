#!/bin/bash

# Remove interfaces already in monitor mode.
A=$(ip a | grep -E -c -i 'wlan[0-9]mon')

if [ $A -ne 0 ]
then
	for (( i=0; i<$A; i++ ))
	do
		B=$(ip a | grep -E -m 1 -i 'wlan[0-9]mon' | awk '{print substr($2,1,length($2)-1)}')
		iw dev $B del
		# Add error-handling here for when the device can't (won't) be deleted.
	done
fi


# Add monitor-mode-capable interfaces to kismet_site.conf
C=$(iw dev | grep -E -c -i 'phy#[0-9]')
D=$(iw dev | grep -E -m 1 -i 'phy#[0-9]' | sed '$ s/[a-z#]//g')
echo '' | tee /etc/kismet/kismet_site.conf 1>/dev/null 2>/dev/null

if [ $C -ne 0 ]
then
	for (( j=0; j<=$D; j++ ))
	do
		E=$(iw phy$j info | grep -c '* monitor')
		#echo 'phy'$j': '$E
		if [ $E -ne 0 ]
		then
			F=$(iw dev | grep -E -m 1 -A 1 -i 'phy#'$j | awk '$1=="Interface"{print $2}')
			G=$(echo $F | awk '$0=$NF' FS=)
			#echo $F
			echo 'source='$F':name=Wifi'$G',channel_hop=true' | tee -a /etc/kismet/kismet_site.conf 1>/dev/null 2>/dev/null
		fi
	done
fi


#Probe for Ubertooth units
J=$(lsusb | grep -E -c -i 'Ubertooth One')

if [ $J -gt 0 ]
then
	for (( l=0; l<$J; l++ ))
 	do
  		echo 'source=ubertooth-'$l':name=ubertooth-'$l | tee -a /etc/kismet/kismet_site.conf 1>/dev/null 2>/dev/null
  	done
fi


#Probe for Bluetooth units
K=$(lsusb | grep -E -c -i 'Bluetooth')

if [ $K -gt 0 ]
then
	for (( m=0; m<$J; m++ ))
 	do
  		echo 'source=hci'$m':name=linuxbt'$l | tee -a /etc/kismet/kismet_site.conf 1>/dev/null 2>/dev/null
  	done
fi


# Probe for GPS units
H=$(ls -lh /dev | grep -E -c -i 'gps[0-9]')
I=$(ls -lh /dev | grep -E -c -i 'ttyACM[0-9]')

if [ $H -gt 0 ] || [ $I -gt 0 ]
then
	echo 'gps=gpsd:host=localhost,port=2947' | tee -a /etc/kismet/kismet_site.conf 1>/dev/null 2>/dev/null
fi


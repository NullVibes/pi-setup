#!/bin/bash

# Sleep is REQUIRED to give devices enough to time to be recognized by the OS
sleep 5
SITE='/etc/kismet/kismet_site.conf'

# Remove interfaces already in monitor mode.
cat /dev/null | tee $SITE &>/dev/null

echo 'server_name=Kismet' | tee -a $SITE &>/dev/null
echo 'server_description=Mobile' | tee -a $SITE &>/dev/null

A=$(ip a | grep -E -c -i 'wlan[0-9]mon')

if [ $A -ne 0 ]
then
	for (( i=0; i<$A; i++ ))
	do
		B=$(ip a | grep -E -m 1 -i 'wlan[0-9]mon' | awk '{print substr($2,1,length($2)-1)}')
		iw dev $B del
		# Add error-handling here for when the device can't (or won't) be deleted.
	done
fi

# Add monitor-mode-capable interfaces to kismet_site.conf
C=$(iw dev | grep -E -c -i 'phy#[0-9]')
D=$(iw dev | grep -E -m 1 -i 'phy#[0-9]' | sed '$ s/[a-z#]//g')
#echo 'mask_datasource_name=wlan0' | tee /etc/kismet/kismet_site.conf &>/dev/null

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
   			CHECKWIFI=$(sudo grep -c "source=$F:name=Wifi$G,channel_hop=true" $SITE)
      			if [[ $CHECKWIFI -eq 0 || $CHECKWIFI == "" ]]; then
				echo 'source='$F':name=Wifi'$G',channel_hop=true' | tee -a $SITE &>/dev/null
    			fi
		fi
	done
 	#echo 'source='$F':name=Wifi'$G',channel_hop=true' | tee -a /etc/kismet/kismet_site.conf &>/dev/null
fi


#Probe for Ubertooth units
J=$(lsusb | grep -E -c -i 'Ubertooth One')

if [ $J -gt 0 ]
then
	for (( l=0; l<$J; l++ ))
 	do
  		echo 'source=ubertooth-'$l':name=ubertooth-'$l | tee -a $SITE &>/dev/null
  	done
fi


#Probe for Bluetooth units
K=$(hcitool dev | grep -E -c -i 'hci')

if [ $K -gt 0 ]
then
 	for (( m=0; m<$K; m++ ))
 	do
  		echo 'source=hci'$m':name=linuxbt'$m',type=linuxbluetooth' | tee -a $SITE &>/dev/null
  	done
fi


#Probe for RTL-SDR units
N=$(lsusb | grep -E -c -i 'RTL[[:alnum:]]{4,5}.DVB-T')
Q="sudo grep -c channel="
if [ $N -gt 0 ]
then
	for (( p=0; p<$N; p++ ))
 	do
  		if [ $($Q'315Hz' $SITE) -eq 0 ]; then
  			echo 'source=rtl433-'$p':type=rtl433,channel=315MHz' | tee -a /etc/kismet/kismet_site.conf &>/dev/null
     		elif [ $($Q'433Hz' $SITE) -eq 0 ]; then
       			echo 'source=rtl433-'$p':type=rtl433,channel=433MHz' | tee -a /etc/kismet/kismet_site.conf &>/dev/null
	  	else
    			:
       		fi
  	done
   	echo 'mask_datasource_type=rtladsb' | tee -a /etc/kismet/kismet_site.conf &>/dev/null
    	echo 'mask_datasource_type=rtlamr' | tee -a /etc/kismet/kismet_site.conf &>/dev/null
fi


# Probe for GPS units
H=$(ls -lh /dev | grep -E -c -i 'gps[0-9]')
I=$(ls -lh /dev | grep -E -c -i 'ttyACM[0-9]')

if [ $H -gt 0 ] || [ $I -gt 0 ]
then
	echo 'gps=gpsd:host=localhost,port=2947,reconnect=true' | tee -a /etc/kismet/kismet_site.conf &>/dev/null
fi


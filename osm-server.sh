##############################################
#                                            #
#           Storage req. > 256GB             #
#                                            #
##############################################

rpi_install() {

echo 'options g_ether host_addr='$(dmesg | awk '/: HOST MAC/{print $NF}')' dev_addr='$(dmesg | awk '/: MAC/{print $NF}') | sudo tee /etc/modprobe.d/g_ether.conf

# Disable BT
#echo 'Disabling BT requires rebooting.'
#sed '/\[all\]/a\ dtoverlay=disable-bt' /boot/config.txt

apt update && apt upgrade -y
}

ubuntu_install () {
}


if uname -a | grep -i raspberry; then rpi_install; fi
if uname -a | grep -i ubuntu; then ubuntu_install; fi

apt update && apt upgrade -y


# Check RAM and resize Swap
# free
# dphys-swapfile swapoff
# sed '/CONF_SWAPSIZE=500/r\CONF_SWAPSIZE=2048' /etc/dphys-swapfile
# dphys-swapfile swapon
# systemctl restart dphys-swapfile
# sysctl vm.swappiness

## Persistent Change
# sed '/vm.swappiness=60/r\vm.swappiness=100' /etc/sysctl.conf

## Temporary Change
# sysctl -w vm.swappiness=100

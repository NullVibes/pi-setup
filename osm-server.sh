##############################################
#                                            #
#           Storage req. > 256GB             #
#                                            #
##############################################

apt update && apt upgrade -y

echo 'options g_ether host_addr='$(dmesg | awk '/: HOST MAC/{print $NF}')' dev_addr='$(dmesg | awk '/: MAC/{print $NF}') | sudo tee /etc/modprobe.d/g_ether.conf

# Disable BT
echo 'Disabling BT requires rebooting.'
sed '/\[all\]/a\ dtoverlay=disable-bt' /boot/config.txt

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

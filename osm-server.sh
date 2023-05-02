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
  
  usermod -aG sudo renderaccount
  
  apt install postgresql-13-postgis-3 postgresql-13-postgis-3-scripts -y
}


ubuntu_install () {
  usermod -aG sudo renderaccount
  
  apt install postgresql-12-postgis-3 postgresql-12-postgis-3-scripts -y
}

apt update && apt upgrade -y

apt install libboost-all-dev git tar unzip wget bzip2 build-essential autoconf libtool libxml2-dev libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev munin-node munin protobuf-c-compiler libfreetype6-dev libtiff5-dev libicu-dev libgdal-dev libcairo2-dev libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev ttf-unifont lua5.1 liblua5.1-0-dev postgresql postgresql-contrib postgis -y

if uname -a | grep -i raspberry; then rpi_install; fi
if uname -a | grep -i ubuntu; then ubuntu_install; fi

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

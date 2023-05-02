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
  
  apt install postgresql-13-postgis-3 postgresql-13-postgis-3-scripts -y
}


ubuntu_install () {
  apt install postgresql-12-postgis-3 postgresql-12-postgis-3-scripts -y
  
  #swapoff -a
  #dd if=/dev/zero of=/swapfile bs=1M count=12288
  #mkswap /swapfile
  #swapon /swapfile
}

apt update && apt upgrade -y

apt install libboost-all-dev git tar unzip wget bzip2 build-essential autoconf libtool libxml2-dev libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev munin-node munin protobuf-c-compiler libfreetype6-dev libtiff5-dev libicu-dev libgdal-dev libcairo2-dev libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev ttf-unifont lua5.1 liblua5.1-0-dev postgresql postgresql-contrib postgis -y

if uname -a | grep -i raspberry; then rpi_install; fi
if uname -a | grep -i ubuntu; then ubuntu_install; fi

useradd -m -g user -G user,sudo -s /bin/bash renderaccount
passwd renderaccount
su - postgres -c 'createuser renderaccount; createdb -E UTF8 -O renderaccount gis'
su - postgres -c 'psql -d gis -c "CREATE EXTENSION postgis"'
su - postgres -c 'psql -d gis -c "CREATE EXTENSION hstore"'
su - postgres -c 'psql -d gis -c "ALTER TABLE geometry_columns OWNER TO renderaccount"'
su - postgres -c 'psql -d gis -c "ALTER TABLE spatial_ref_sys OWNER TO renderaccount"'

apt install npm osm2pgsql autoconf apache2-dev libtool libxml2-dev libbz2-dev libgeos-dev libgeos++-dev libproj-dev gdal-bin libmapnik-dev mapnik-utils python3-mapnik python3-psycopg2 python3-yaml -y

mkdir ~/src
cd ~/src
git clone https://github.com/SomeoneElseOSM/mod_tile.git
cd mod_tile
./autogen.sh
./configure
make
make install
make install-mod_tile
ldconfig

su - renderaccount -c 'mkdir ~/src; cd ~/src; git clone https://github.com/gravitystorm/openstreetmap-carto;'
su - renderaccount -c 'cd ~/src; npm install -g carto'
su - renderaccount -c 'carto ~/src/openstreetmap-carto/project.mml > ~/src/openstreetmap-carto/mapnik.xml'
su - renderaccount -c 'mkdir ~/data; cd ~/data; wget https://download.geofabrik.de/north-america/us-latest.osm.pbf'
su - renderaccount -c 'osm2pgsql -d gis --create --slim  -G --hstore --tag-transform-script ~/src/openstreetmap-carto/openstreetmap-carto.lua -C 8192 --number-processes 2 -S ~/src/openstreetmap-carto/openstreetmap-carto.style ~/data/us-latest.osm.pbf'
su - renderaccount -c 'cd ~/src/openstreetmap-carto; psql -d gis -f indexes.sql; scripts/get-external-data.py; scripts/get-fonts.sh'


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

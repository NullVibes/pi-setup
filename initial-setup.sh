# Disable IPv6
# GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"
# sudo update-grub

# Static MAC/Interface name
echo 'options g_ether host_addr='$(dmesg | awk '/: HOST MAC/{print $NF}')' dev_addr='$(dmesg | awk '/: MAC/{print $NF}') | sudo tee /etc/modprobe.d/g_ether.conf

# Change prompt color
export PS1="\[$(tput bold)$(tput setaf 1)\]\u@\h:\w\$\[$(tput sgr0)\] "

# Optional: Add window data for more info
# export PS1="\[$(tput bold)\e]2;REMOTE: \h\a\]\[$(tput setaf 1)\]THIS IS REMOTE MACHINE \h\n\[$(tput setaf 4)\]\u@\h:\w\$\[$(tput sgr0)\] '

# Alias'es'es:  Add to ~/.bashrc
# alias prompt_red='export PS1="\[$(tput bold)$(tput setaf 1)\]\u@\h:\w\$\[$(tput sgr0)\] "'

sudo apt update && sudo apt upgrade -y
sudo apt install git vim tree -y
#sudo apt install terminator openvpn wireguard -y

#cd /opt
#sudo git clone https://github.com/OpenVPN/easy-rsa.git
#sudo chown studentX:studentX /opt/* -R


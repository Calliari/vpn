#!/bin/bash

# 4)user-data
sudo apt-get update -y
sudo apt-get dist-upgrade -y
sudo apt-get install git -y
# sudo reboot || sudo shutdown -r +1


# https://git.io/vpnsetup
git clone https://github.com/hwdsl2/setup-ipsec-vpn

#run the vpn script and piping the output into "vpnsetup.txt"
sudo /home/ubuntu/setup-ipsec-vpn/vpnsetup.sh > /home/ubuntu/vpnsetup.txt

# copy the script to the ubuntu HOME directory
cp /home/ubuntu/setup-ipsec-vpn/vpnsetup.sh /home/ubuntu/vpnsetup.sh

# Get the varibles from "/home/ubuntu/vpnsetup.txt" - OLD
# IPSEC_PSK=$(grep -oP '(?<="IPsec PSK: ).*' /home/ubuntu/vpnsetup.txt | cut -d',' -f1); IPSEC_PSK=$(echo "${IPSEC_PSK::-1}"); USERNAME=$(grep -oP '(?<="Username: ).*' /home/ubuntu/vpnsetup.txt | cut -d',' -f1); USERNAME=$(echo "${USERNAME::-1}"); PASSWORD=$(grep -oP '(?<="Password: ).*' /home/ubuntu/vpnsetup.txt | cut -d',' -f1); PASSWORD=$(echo "${PASSWORD::-1}");

# Get the varibles from "/home/ubuntu/vpnsetup.txt" - NEW
IPSEC_PSK=$(grep -oP 'IPsec PSK: .*' /home/ubuntu/vpnsetup.txt | awk  '{print $3}');
USERNAME=$(grep -oP 'Username: .*' /home/ubuntu/vpnsetup.txt | awk  '{print $2}');
PASSWORD=$(grep -oP 'Password: .*' /home/ubuntu/vpnsetup.txt | awk  '{print $2}');
PSK=$(cat vpnsetup.sh | grep YOUR_IPSEC_PSK=''); sudo sed -i "s/$PSK/YOUR_IPSEC_PSK=\'$IPSEC_PSK\'/" /home/ubuntu/vpnsetup.sh; USER=$(cat vpnsetup.sh | grep YOUR_USERNAME=''); sudo sed -i "s/$USER/YOUR_USERNAME=\'$USERNAME\'/" /home/ubuntu/vpnsetup.sh;  PASS=$(cat vpnsetup.sh | grep YOUR_PASSWORD=''); sudo sed -i "s/$PASS/YOUR_PASSWORD=\'$PASSWORD\'/" /home/ubuntu/vpnsetup.sh;

# Get the variables-holder from vpnsetup.txt file
IPSEC_PSK=$(grep -oP '(?<=IPsec PSK: ).*' /home/ubuntu/vpnsetup.txt);
USERNAME=$(grep -oP '(?<=Username: ).*' /home/ubuntu/vpnsetup.txt);
PASSWORD=$(grep -oP '(?<=Password: ).*' /home/ubuntu/vpnsetup.txt);

# Replace the variables-holder with the credentials in place on the script file "/home/ubuntu/vpnsetup.sh"
sudo sed -i s/YOUR_IPSEC_PSK=\'\'/YOUR_IPSEC_PSK=\'$IPSEC_PSK\'/ /home/ubuntu/vpnsetup.sh
sudo sed -i s/YOUR_USERNAME=\'\'/YOUR_USERNAME=\'$USERNAME\'/ /home/ubuntu/vpnsetup.sh
sudo sed -i s/YOUR_PASSWORD=\'\'/YOUR_PASSWORD=\'$PASSWORD\'/ /home/ubuntu/vpnsetup.sh

# Fire the script up and start the "ipsec" VPN service
sudo /home/ubuntu/vpnsetup.sh && sudo systemctl restart ipsec.service

### Restart services on the VPN server:
# sudo service ipsec restart && sudo service xl2tpd restart

# Optional - schedule the VPN servrer to shutdown after 53 min, avoid charges on the GCP or AWS instances.
sudo sed -i '/#!\/bin\/sh$/a /sbin/shutdown -P +53' /etc/rc.local


### Check the Libreswan (IPsec) and xl2tpd logs for errors:
## Ubuntu & Debian
# grep pluto /var/log/auth.log
# grep xl2tpd /var/log/syslog

### check connection with
# tail -f /var/log/syslog

#### ====== #### ====== #### ====== #### ====== ####
### Important notes:   https://git.io/vpnnotes
  # For servers with an external firewall (e.g. EC2/GCE), 
  # open UDP ports 500 and 4500 for the VPN on the security-groups.
## Setup VPN clients: https://git.io/vpnclients

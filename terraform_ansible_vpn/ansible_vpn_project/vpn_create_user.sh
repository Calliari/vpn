#!/bin/bash
#
# Configure the VPN server for the specified users.
#
# This is designed to be run via terraform, thus enabling us to use the same
# AMI for multiple instances of the software VPN across multiple projects.
#
# This script should be idempotent, but doesn't currently handle removing users.
# Terraform should rebuild the server from scratch if this script changes
# though.
#
# Note, array syntaxes need to be escaped with a second dollar when called from
# terraform. This is because this script is interpolated by terraform before
# being executed on the server, so by escaping the variable we still allow the
# correct single-$ to be passed on to the server.
#
# @author PK
#

# VPN_PSK="123456ABCD"
VPN_PSK=""

# VPN_CREDENTIALS="username1:password,username2:password,"
VPN_CREDENTIALS=""

# Split the string by commas, separating out the different users.
IFS="," read -a CREDENTIALS <<< "$VPN_CREDENTIALS";

# For each user in the string, split the remaining string on the colon. This
# will separate out the username and the password. Then:
# - Add this user to the CHAP file (if it's not already in there)
# - Encode the password for ipsec
# - Add the VPN_PSK to the correct file.
for USER_CREDENTIALS in "${CREDENTIALS[@]}"; do
  IFS=":" read -a USER_PASS <<< "$USER_CREDENTIALS";

  VPN_USER="${USER_PASS[0]}";
  VPN_PASS="${USER_PASS[1]}";

  if [[ $(grep "^\"$VPN_USER\"" /etc/ppp/chap-secrets) = "" ]]; then
    echo "\"$VPN_USER\" l2tpd \"$VPN_PASS\" *" >> /etc/ppp/chap-secrets;
  fi

  if [[ $(grep "^$VPN_USER:" /etc/ipsec.d/passwd) = "" ]]; then
    VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASS");
    echo "$VPN_USER:$VPN_PASSWORD_ENC:xauth-psk" >> /etc/ipsec.d/passwd;
  fi

  if [[ $(grep "\"$VPN_PSK\"$" /etc/ipsec.secrets) = "" ]]; then
    truncate -s0 /etc/ipsec.secrets
    echo "%any  %any  : PSK \"$VPN_PSK\"" >> /etc/ipsec.secrets
  fi
done

# Finally, restart services:
service ipsec restart
service xl2tpd restart

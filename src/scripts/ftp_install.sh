#!/bin/bash
# ASAS 2.10
# @author: GCornell for devCU Software
# @contact: support@devcu.com
# Compatibility: Debian Core Systems (Tested on Ubuntu 12-14-16-17 & Debian 8/9)
# MAIN: https://www.devcu.com  https://www.devcu.net https://www.exceptionalservers.com
# REPO: https://github.com/GaryCornell/Auto-Server-Installer
# License: GNU General Public License v3.0
# Created:   06/15/2016
# Updated:   09/22/2017

# Install vsFTPd
     apt -qq update
     apt install vsftpd -y
     echo -e "\nConfigure vsFTPd -  We will use IPv6 enabled"
     echo -n "Enter Port - Something high like 23450 > "
     read VPORT
     echo "You Entered: $VPORT"
     echo -n "Optional: Enter IPv4 IP listen address - leave blank for none"
     read VIPADD
     echo "You Entered: $VIPADD"
     echo -n "Optional: Enter IPv6 IP listen address - leave blank for none"
     read VIPADD6
     echo "You Entered: $VIPADD6"
     sleep 1
     echo -e "\nMaking backup of original vsftpd.conf"
     sudo mv /etc/vsftpd.conf /etc/vsftpd.conf.bak
     CONFIG=/etc/vsftpd.conf
     cp config/vsftpd/vsftpd.conf $CONFIG

     $SED -i "s/@@VPORT@@/$VPORT/g" $CONFIG
     $SED -i "s/@@VIPADD@@/$VIPADD/g" $CONFIG
     $SED -i "s/@@VIPADD6@@/$VIPADD6/g" $CONFIG

     chmod 644 /etc/vsftpd.conf
     chown root:root /etc/vsftpd.conf
     echo -e "Restarting FTP Server\n"
     $VSFTPD_INIT
     echo -e "\nvsFTPd  has been configured on port $VPORT."
     echo -e "\nTo enable TLS/SSL please edit the vsftpd.conf manually and uncomment"
     echo -e "\nSSL options setting proper cert/key paths as well if using custom SSL\n"
     read -p "Press [Enter] key to return to main menu..."
     return

#!/bin/bash
# ASAS 2.10
# @author: GCornell for devCU Software
# @contact: support@devcu.com
# Compatibility: Debian Core Systems (Tested on Ubuntu 12-14-16-17 & Debian 8/9)
# MAIN: https://www.devcu.com  https://www.devcu.net https://www.exceptionalservers.com
# REPO: https://github.com/GaryCornell/Auto-Server-Installer
# License: GNU General Public License v3.0
# Created:   06/15/2016
# Updated:   09/24/2017

clear

#Nginx Install Menu

while [ 3 ]
do

SELECTNGINX=$(
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  checkbox=black,lightgray
  actcheckbox=black,blue
  shadow=,gray
  button=lightgray,gray
' \
whiptail --title "Nginx Web Server Installer" --radiolist "\nUse up/down arrows and tab to select an Nginx version" 15 60 4 \
        "1)" "Nginx Latest Mainline (Recommended)" ON \
        "2)" "Nginx Latest Stable" OFF \
        "3)" "Custom Nginx Compiled with Openssl" OFF \
        "4)" "Return to Main Menu"  OFF 3>&1 1>&2 2>&3
)


case $SELECTNGINX in
        "1)")

      return
        ;;

        "2)")

      return
        ;;

        "3)")

      return
        ;;

        "4)")

      return
        ;;

esac

done
exit

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

#PHP Install Menu

while [ 4 ]
do

SELECTPHP=$(
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  checkbox=black,lightgray
  actcheckbox=black,blue
  shadow=,gray
  button=lightgray,gray
' \
whiptail --title "PHP Installer" --radiolist "\nUse up/down arrows and tab to select a PHP version" 15 60 4 \
        "1)" "PHP 5x" OFF \
        "2)" "PHP 7x (Recommended)" ON \
        "3)" "PHP 7.1" OFF \
        "4)" "Return to Main Menu"  OFF 3>&1 1>&2 2>&3
)


case $SELECTPHP in
        "1)")
      echo "Do you want to install required PHP applications (Required) (y/n)"
      read CHECKPHP
     if [ $CHECKPHP == "y" ]; then
      echo -e "\nInstalling Required Applications"
      apt -qq update
      apt install $PHP5_PACKAGES -y
      echo -e "\nPHP Installed"
      echo -e "\nSystem Updated\n"
     else
      echo -e "\nSkipping PHP update\n"
     fi
      read -p "System is ready for configuration, hit ENTER to continue..."
      return
        ;;

        "2)")
      echo "Do you want to install required PHP applications (Required) (y/n)"
      read CHECKPHP
     if [ $CHECKPHP == "y" ]; then
      echo -e "\nInstalling Required Applications"
      apt -qq update
      apt install $PHP7_PACKAGES -y
      echo -e "\nPHP Installed"
      echo -e "\nSystem Updated\n"
     else
      echo -e "\nSkipping PHP update\n"
     fi
      read -p "System is ready for configuration, hit ENTER to continue..."
      return
        ;;

        "3)")
      echo "Do you want to install required PHP applications (Required) (y/n)"
      read CHECKPHP
     if [ $CHECKPHP == "y" ]; then
      echo -e "\nInstalling Required Applications"
      apt -qq update
      apt install $PHP7_PACKAGES -y
      echo -e "\nPHP Installed"
      echo -e "\nSystem Updated\n"
     else
      echo -e "\nSkipping PHP update\n"
     fi
      read -p "System is ready for configuration, hit ENTER to continue..."
      return
        ;;

        "4)")

      return
        ;;

esac

done
exit

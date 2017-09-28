#!/bin/bash
# ASAS 2.10
# @author: GCornell for devCU Software
# @contact: gacornell@devcu.com
# Compatibility: Debian Core Systems (Tested on Ubuntu 14x-16x-17x & Debian 8/9)
# MAIN: https://www.devcu.com
# CODE: https://github.com/GaalexxC/ASAS
# REPO: https://www.devcu.net
# License: GNU General Public License v3.0
# Created:   06/15/2016
# Updated:   09/25/2017

clear

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
whiptail --title "PHP Installer" --radiolist "\nUse up/down arrows and tab to select a PHP version\nPHP 5.4/5.5 are no longer receiving security updates" 18 70 5 \
        "1)" "PHP 5.6" OFF \
        "2)" "PHP 7.0 (Recommended)" ON \
        "3)" "PHP 7.1" OFF \
        "4)" "Configure and Secure PHP.ini (Recommended)" OFF \
        "5)" "Return to Main Menu"  OFF 3>&1 1>&2 2>&3
)

case $SELECTPHP in
        "1)")
      echo -e "\nInstalling Depedencies"
      phpDependencies
      echo -e "\nInstalling PHP 7.1"
      apt install $PHP71_PACKAGES
      echo -e "\nPHP 7.1 Installed"
      echo -e "\nSystem Updated\n"
      return
        ;;

        "2)")
      echo -e "\nInstalling Depedencies"
      phpDependencies
      echo -e "\nInstalling PHP 7.0"
      apt install $PHP70_PACKAGES
      echo -e "\nPHP 7.0 Installed"
      echo -e "\nSystem Updated\n"
      return
        ;;

        "3)")
      echo -e "\nInstalling Depedencies"
      phpDependencies
      echo -e "\nInstalling PHP 5.6"
      apt install $PHP56_PACKAGES
      echo -e "\nPHP 5.6 Installed"
      echo -e "\nSystem Updated\n"
      return
        ;;

        "4)")
      echo -e "\nSecure PHP INI for FPM/CLI - \nThis will secure the following:\ncgi.fix_pathinfo=0\nexposephp=off\ndisable_functions = disable dangerous functions"
      echo -e "\nSecurity Check - Do you want to secure your php.ini? (y/n)"
      read MODIFYPHPINI
   if [ $MODIFYPHPINI == "y" ]; then
      echo -e "\nMaking backup ups of original fpm and cli php.ini"
      sudo mv /etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/php.ini.bak
      sudo mv /etc/php/7.0/cli/php.ini /etc/php/7.0/cli/php.ini.bak
      echo -e "\nUpdating fpm and cli php.ini with secure rules"
      CONFIGFPM=$PHP7_FPM_INI
      cp config/phpini/php.ini $CONFIGFPM 2>/dev/null
      CONFIGCLI=$PHP7_CLI_INI
      cp config/phpini/php.ini $CONFIGCLI 2>/dev/null
      echo -e "\nphp.ini fpm and cli secured\n"
   else
     echo -e "\nSkipping php.ini fpm and cli security\n"
   fi
      return
        ;;

        "5)")

      return
        ;;

  esac

 done

exit

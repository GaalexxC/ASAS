#!/bin/bash
# Auto Server Installer v2.10
# @author: G Cornell for devCU Software
# @contact: support@devcu.com
# @Facebook: facebook.com/garyacornell
# Compatible: Ubuntu 12-14-16.x Servers running PHP 5/7 - README for custom configurations
# MAIN: https://www.devcu.com  https://www.devcu.net
# REPO: https://github.com/GaryCornell/Auto-Server-Installer
# License: GNU General Public License v3.0
# Created:   06/15/2016
# Updated:   09/18/2017

# Install PHP
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

# -------
# PHP INI CONFIG:
# -------
   if [ $CHECKPHP == "y" ]; then
      echo -e "\nSecure PHP INI for FPM/CLI - \nThis will secure the following:\ncgi.fix_pathinfo=0\nexposephp=off\ndisable_functions = disable dangerous stuff"
      echo -e "\nSecurity Check - Do you want to secure your php.ini? (y/n)"
      read CHECKPHPINI
   if [ $CHECKPHPINI == "y" ]; then
      echo -e "\nMaking backup ups of original fpm and cli php.ini"
      sudo mv /etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/php.ini.bak
      sudo mv /etc/php/7.0/cli/php.ini /etc/php/7.0/cli/php.ini.bak
      echo -e "\nUpdating fpm and cli php.ini with secure rules"
      CONFIGFPM=$PHP_FPM_INI
      cp config/phpini/php.ini $CONFIGFPM 2>/dev/null
      CONFIGCLI=$PHP_CLI_INI
      cp config/phpini/php.ini $CONFIGCLI 2>/dev/null
      echo -e "\nphp.ini fpm and cli secured\n"
   else
      echo -e "\nNot a wise choice, We highly suggest securing your php.ini files\n"
   fi
   else
     echo -e "\nSkipping php.ini fpm and cli security\n"
   fi

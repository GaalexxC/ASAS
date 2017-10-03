#!/bin/bash
#################################################################################
#                   *** ASAS 2.10 [Auto Server Admin Script] ***                #
#        @author: GCornell for devCU Software Open Source Projects              #
#        @contact: gacornell@devcu.com                                          #
#        $OS: Debian Core (Tested on Ubuntu 14x -> 17x / Debian 7.x -> 9.x)     #
#        $MAIN: https://www.devcu.com                                           #
#        $SOURCE: https://github.com/GaalexxC/ASAS                              #
#        $REPO: https://www.devcu.net                                           #
#        +Created:   06/15/2016 Ported from nginxubuntu-php7                    #
#        &Updated:   10/03/2017 03:45 EDT                                       #
#                                                                               #
#    This program is free software: you can redistribute it and/or modify       #
#    it under the terms of the GNU General Public License as published by       #
#    the Free Software Foundation, either version 3 of the License, or          #
#    (at your option) any later version.                                        #
#                                                                               #
#    This program is distributed in the hope that it will be useful,            #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#    GNU General Public License for more details.                               #
#                                                                               #
#    You should have received a copy of the GNU General Public License          #
#    along with this program.  If not, see http://www.gnu.org/licenses/         #
#                                                                               #
#################################################################################
clear

while [ 4 ]
do

SELECTPHP=$(
whiptail --title "PHP Installer" --radiolist "\nUse up/down arrows and tab to select a PHP version\nUpon selection operation will begin without prompts" 20 78 8 \
        "1)" "PHP 7.1" OFF \
        "2)" "PHP 7.0 (Recommended)" ON \
        "3)" "PHP 5.6" OFF \
        "4)" "Configure and Secure PHP.ini (Recommended)" OFF \
        "5)" "Remove PHP (Preserves Configurations)" OFF \
        "6)" "Purge PHP (Warning! Removes Everything!)" OFF \
        "7)" "Return to Main Menu" OFF \
        "8)" "Exit" OFF 3>&1 1>&2 2>&3
)

case $SELECTPHP in
        "1)")
      package() {
         printf "apt install $PHP71_PACKAGES"
       }
      systemInstaller
      completeOperation
      return
        ;;

        "2)")
      package() {
         printf "apt install $PHP70_PACKAGES"
       }
      systemInstaller
      completeOperation
      return
        ;;

        "3)")
      package() {
         printf "apt install $PHP56_PACKAGES"
       }
      systemInstaller
      completeOperation
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
         sudo apt remove `dpkg -l | grep php| awk '{print $2}' |tr "\n" " "`
         sudo apt autoremove
         rm -rf /etc/php
         read -p "PHP has been removed, configurations preserved, Press [Enter] to return to main menu"
      return
        ;;

        "6)")
         sudo apt purge `dpkg -l | grep php| awk '{print $2}' |tr "\n" " "`
         sudo apt autoremove
         rm -rf /etc/php
         read -p "PHP has been removed from the system, Press [Enter] to return to main menu"
      return
        ;;

        "7)")
      return
        ;;

        "8)")
      exit 1
        ;;
  esac

 done

exit

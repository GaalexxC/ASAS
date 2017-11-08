#!/bin/bash
#################################################################################
#                   *** ASAS 2.10 [Auto Server Admin Script] ***                #
#        @author: GCornell for devCU Software Open Source Projects              #
#        @contact: gacornell@devcu.com                                          #
#        $OS: Debian Core (Tested on Ubuntu 16x -> 17x / Debian 8.x -> 9.x)     #
#        $MAIN: https://www.devcu.com                                           #
#        $SOURCE: https://github.com/GaalexxC/ASAS                              #
#        $REPO: https://www.devcu.net                                           #
#        +Created:   06/15/2016 Ported from nginxubuntu-php7                    #
#        &Updated:   11/07/2017 23:13 EDT                                       #
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

phpDependencyCheck() {
  if [ -f /etc/apt/sources.list.d/ondrej-ubuntu-php-artful.list ]
    then
    whiptail --title "PHP Dependency Check" --msgbox "PHP dependencies are installed" --ok-button "OK" 10 70
  else
    package() {
       printf "apt --yes install language-pack-en-base software-properties-common"
     }
    systemInstaller

    add-apt-repository ppa:ondrej/php

    pkgcache() {
       printf "apt update"
    }
    updateSources
    whiptail --title "PHP Dependency Check" --msgbox "PHP dependencies are installed" --ok-button "OK" 10 70
  fi
}
phpBackupConf() {
{
    echo -e "XXX\n50\n\nBacking up php.ini configuration... \nXXX"
   if [ ! -d  $CURDIR/backups ]; then
    mkdir $CURDIR/backups
   fi
   if [ -f $PHP72_FPM_INI/$PHPCONFIG ]
       then
     tar cvpfz /php72ini_backup_$CURDAY.tar.gz $PHP72_FPM_INI/$PHPCONFIG 2> /dev/null
     mv /php72ini_backup_$CURDAY.tar.gz $CURDIR/backups
     sleep 1
    echo -e "XXX\n100\n\nBackup to $CURDIR/backups... Done.\nXXX"
    sleep 1.5
   elif [ -f $PHP71_FPM_INI/$PHPCONFIG ]
      then
     tar cvpfz /php71ini_backup_$CURDAY.tar.gz $PHP71_FPM_INI/$PHPCONFIG 2> /dev/null
     mv /php71ini_backup_$CURDAY.tar.gz $CURDIR/backups
     sleep 1
    echo -e "XXX\n100\n\nBackup to $CURDIR/backups... Done.\nXXX"
    sleep 1.5
   elif [ -f $PHP70_FPM_INI/$PHPCONFIG ]
      then
     tar cvpfz /php70ini_backup_$CURDAY.tar.gz $PHP70_FPM_INI/$PHPCONFIG 2> /dev/null
     mv /php70ini_backup_$CURDAY.tar.gz $CURDIR/backups
     sleep 1
    echo -e "XXX\n100\n\nBackup to $CURDIR/backups... Done.\nXXX"
    sleep 1.5
   else
     tar cvpfz /php56ini_backup_$CURDAY.tar.gz $PHP56_FPM_INI/$PHPCONFIG 2> /dev/null
     mv /php56ini_backup_$CURDAY.tar.gz $CURDIR/backups
     sleep 1
    echo -e "XXX\n100\n\nBackup to $CURDIR/backups... Done.\nXXX"
    sleep 1.5
   fi
  } | whiptail --title "PHP Backup" --gauge "\nBacking up php.ini configuration" 10 70 0
}

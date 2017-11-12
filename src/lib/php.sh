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
#        &Updated:   11/09/2017 12:25 EDT                                       #
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
#*****************************
#
# PHP System Functions
#
#****************************
phpCheckInstall() {
   if ! type php > /dev/null 2>&1; then
     whiptail --title "PHP Check-Install" --msgbox "PHP not installed" --ok-button "OK" 10 70
     source $CURDIR/scripts/php_install.sh
   else
     phpver=$(php -r \@phpinfo\(\)\; | grep 'PHP Version' -m 1)
     whiptail --title "PHP Check-Install" --msgbox "PHP Installed!\n\n$phpver" --ok-button "OK" 10 70
     source $CURDIR/scripts/php_install.sh
   fi
}
phpVersion() {
   if [ -f $PHP72_FPM_INI/$PHPCONFIG ]
      then
     PHP_INIT=$PHP72_FPM_INIT
     PHP_INI=$PHP72_FPM_INI/$PHPCONFIG
     PHP_FPMCONF_DIR=$PHP72_FPM_DIR
   elif [ -f $PHP71_FPM_INI/$PHPCONFIG ]
      then
     PHP_INIT=$PHP71_FPM_INIT
     PHP_INI=$PHP71_FPM_INI/$PHPCONFIG
     PHP_FPMCONF_DIR=$PHP71_FPM_DIR
   else
     PHP_INIT=$PHP70_FPM_INIT
     PHP_INI=$PHP70_FPM_INI/$PHPCONFIG
     PHP_FPMCONF_DIR=$PHP70_FPM_DIR
   fi
}
phpaddrepo() {
{
     echo -e "XXX\n50\n\nFetching repository ppa:ondrej/php... \nXXX"
     sleep 1
     add-apt-repository ppa:ondrej/php -y 2> /dev/null
     echo -e "XXX\n100\n\nRepository ppa:ondrej/php installed... Done.\nXXX"
     sleep 1.5
  } | whiptail --title "PHP Add Repo" --gauge "\nChecking for repository ppa:ondrej/php" 10 70 0
}
phpDependencyCheck() {
   if [ -f /etc/apt/sources.list.d/ondrej-*.list ]
      then
     whiptail --title "PHP Dependency Check" --msgbox "PHP dependencies are installed" --ok-button "OK" 10 70
   else
     package() {
       printf "apt --yes install language-pack-en-base software-properties-common"
      }
     systemInstaller
     phpaddrepo
     pkgcache() {
       printf "apt update"
      }
     updateSources
     whiptail --title "PHP Dependency Check" --msgbox "PHP dependencies are installed" --ok-button "OK" 10 70
   fi
}
#*****************************
#
# PHP Security Functions
#
#****************************
phpBackupConf() {
{
   phpVersion
    echo -e "XXX\n50\n\nBacking up php.ini configuration... \nXXX"
   if [ ! -d  $CURDIR/backups ]; then
    mkdir $CURDIR/backups
   fi
   if [ -f $PHP72_FPM_INI/$PHPCONFIG ]
      then
     tar cvpfz /php72ini_backup_$CURDAY.tar.gz $PHP_INI 2> /dev/null
     mv /php72ini_backup_$CURDAY.tar.gz $CURDIR/backups
     sleep 1
     echo -e "XXX\n100\n\nBackup to $CURDIR/backups... Done.\nXXX"
     sleep 1.5
   elif [ -f $PHP71_FPM_INI/$PHPCONFIG ]
      then
     tar cvpfz /php71ini_backup_$CURDAY.tar.gz $PHP_INI 2> /dev/null
     mv /php71ini_backup_$CURDAY.tar.gz $CURDIR/backups
     sleep 1
     echo -e "XXX\n100\n\nBackup to $CURDIR/backups... Done.\nXXX"
     sleep 1.5
   else
     tar cvpfz /php70ini_backup_$CURDAY.tar.gz $PHP_INI 2> /dev/null
     mv /php70ini_backup_$CURDAY.tar.gz $CURDIR/backups
     sleep 1
     echo -e "XXX\n100\n\nBackup to $CURDIR/backups... Done.\nXXX"
     sleep 1.5
   fi
  } | whiptail --title "PHP Backup" --gauge "\nBacking up php.ini configuration" 10 70 0
}
#*****************************
#
# PHP Installer Functions
#
#****************************
phpPurge() {
{
     echo -e "XXX\n20\n\nRemoving ppa:ondrej/php repo...\nXXX"
     rm -rf /etc/apt/sources.list.d/ondrej-*
     rm -rf /etc/apt/trusted.gpg.d/ondrej_*
     rm -rf /var/lib/apt/lists/ppa.launchpad.net_ondrej_*
     sleep .75
     echo -e "XXX\n40\n\nRemoving PHP configurations... \nXXX"
     rm -rf /etc/php
     sleep .75
     echo -e "XXX\n60\n\nRemoving PHP modules... \nXXX"
     rm -rf /var/lib/php
     sleep .75
     echo -e "XXX\n80\n\nRemoving PHP logs... Done.\nXXX"
     rm -rf /var/log/php*-fpm.log
     sleep .75
     echo -e "XXX\n100\n\nAll traces cleaned... Done.\nXXX"
     sleep 1
  } | whiptail --title "PHP Purge" --gauge "\nWiping traces of PHP" 10 70 0
}
phpfpmRestart() {
{
     $PHP_INIT restart 2> /dev/null
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     echo -e "XXX\n50\n\nStopping PHP-FPM Service... Done.\nXXX"
     sleep 1
     echo -e "XXX\n100\n\nSuccessfully restarted PHP-FPM... Done.\nXXX"
     sleep 1
   else
     echo -e "XXX\n0\n\nPHP-FPM failed, check /var/log/php-fpm.log\nScript exiting in 3 seconds...\nXXX"
     sleep 3
    exit 1
   fi
     sleep .80
  } | whiptail --title "Restart PHP-FPM" --gauge "\nRestarting the PHP-FPM service" 10 70 0
}
#*****************************
#
# PHP Settings Functions
#
#****************************
phpengineenable() {
     phpVersion
   if (whiptail --title "PHP Engine Config" --yesno "Do you want to enable/disable PHP engine?\nDefault is enabled (On)" --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/engine = .*/engine = On/g" $PHP_INI
     phpfpmRestart
     whiptail --title "PHP Engine Config" --msgbox "PHP engine enabled" --ok-button "OK" 10 70
   else
     $SED -i "s/engine = .*/engine = Off/g" $PHP_INI
     phpfpmRestart
     whiptail --title "PHP Engine Config" --msgbox "PHP engine disabled" --ok-button "OK" 10 70
   fi
}

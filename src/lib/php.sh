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
#        &Updated:   12/25/2017 07:38 EDT                                       #
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
phpErrorLog() {
     echo "Error date: $DATE_TIME\n\n$phpfail" >> $CURDIR/$LOGS/php-error-$CURDAY.log
}

phpDebugLog() {
     echo "$DATE_TIME: $FUNC" >> $CURDIR/$LOGS/php-$CURDAY.log
}
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
     PHP_VER=$PHP72_FPM_VER
     PHP_INIT=$PHP72_FPM_INIT
     PHP_INI=$PHP72_FPM_INI/$PHPCONFIG
     PHP_FPMCONF_DIR=$PHP72_FPM_DIR
   elif [ -f $PHP71_FPM_INI/$PHPCONFIG ]
      then
     PHP_VER=$PHP71_FPM_VER
     PHP_INIT=$PHP71_FPM_INIT
     PHP_INI=$PHP71_FPM_INI/$PHPCONFIG
     PHP_FPMCONF_DIR=$PHP71_FPM_DIR
   else
     PHP_VER=$PHP70_FPM_VER
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
     FUNC="Repository ppa:ondrej/php installed"
     phpDebugLog
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
phpcgifixpath() {
       phpVersion
       $SED -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" $PHP_INI
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
     FUNC="Successfully restarted PHP-FPM"
     phpDebugLog
     echo -e "XXX\n100\n\nSuccessfully restarted PHP-FPM... Done.\nXXX"
     sleep 1
   else
     phpVersion
     phpfail=$(systemctl status $PHP_VER.service 2>&1)
     phpErrorLog
     FUNC="PHP-FPM failed check $CURDIR/$LOGS"
     phpDebugLog
     echo -e "XXX\n99\n\nPHP-FPM failed, check $CURDIR/$LOGS/php-error-$CURDAY.log...\nXXX"
     sleep 5
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
phpengineswitch() {
     phpVersion
   if (whiptail --title "PHP Configuration" --yesno "Do you want to enable/disable PHP engine?\nDefault is enabled (On)" --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/engine = .*/engine = On/g" $PHP_INI
     phpfpmRestart
     FUNC="PHP engine enabled"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "PHP engine enabled" --ok-button "OK" 10 70
   else
     $SED -i "s/engine = .*/engine = Off/g" $PHP_INI
     phpfpmRestart
     FUNC="PHP engine disabled"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "PHP engine disabled" --ok-button "OK" 10 70
   fi
}
phpexposeswitch() {
     phpVersion
   if (whiptail --title "PHP Configuration" --yesno "Do you want to expose your php version?\nDefault is disabled (Off)" --yes-button "Expose" --no-button "Hide" 10 70) then
     $SED -i "s/expose_php = .*/expose_php = On/g" $PHP_INI
     phpfpmRestart
     FUNC="Expose PHP set to show"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "PHP version is exposed" --ok-button "OK" 10 70
   else
     $SED -i "s/expose_php = .*/expose_php = Off/g" $PHP_INI
     phpfpmRestart
     FUNC="Expose PHP set to hidden"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "PHP version is hidden" --ok-button "OK" 10 70
   fi
}
pmemorysize() {
     phpVersion
   if (whiptail --title "PHP Configuration" --yesno "You Entered: $MEMORYLIMIT" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/memory_limit = .*/memory_limit = $MEMORYLIMIT/g" $PHP_INI
     phpfpmRestart
     FUNC="Memory limit modified to $MEMORYLIMIT"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "Memory limit modified to $MEMORYLIMIT" --ok-button "OK" 10 70
   else
     phpmemorysize
   fi
}
phpmemorysize() {
     MEMORYLIMIT=$(whiptail --inputbox "\nSpecify memory limit value IE: 256M. Default 128M" 10 70 --title "PHP Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     pmemorysize
   else
     cancelOperation
   fi
}
phperrorswitch() {
     phpVersion
   if (whiptail --title "PHP Configuration" --yesno "Do you want to display errors?\nDefault is enabled (Off)" --yes-button "Display" --no-button "Hide" 10 70) then
     $SED -i "s/display_errors = .*/display_errors = On/g" $PHP_INI
     phpfpmRestart
     FUNC="Display errors was enabled"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "Display errors is enabled" --ok-button "OK" 10 70
   else
     $SED -i "s/display_errors = .*/display_errors = Off/g" $PHP_INI
     phpfpmRestart
     FUNC="Display errors was disabled"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "Display errors is disabled" --ok-button "OK" 10 70
   fi
}
pmaxpostsize() {
     phpVersion
   if (whiptail --title "PHP Configuration" --yesno "You Entered: $MAXPOST" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/post_max_size = .*/post_max_size = $MAXPOST/g" $PHP_INI
     phpfpmRestart
     FUNC="Max size of POST modified to $MAXPOST"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "Max size of POST modified to $MAXPOST" --ok-button "OK" 10 70
   else
     phpmaxpostsize
   fi
}
phpmaxpostsize() {
     MAXPOST=$(whiptail --inputbox "\nMax size of POST data IE: 4M. Default 8M" 10 70 --title "PHP Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     pmaxpostsize
   else
     cancelOperation
   fi
}
phpuploadsswitch() {
     phpVersion
   if (whiptail --title "PHP Configuration" --yesno "Do you want to allow HTTP file uploads?\nDefault is enabled (On)" --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/file_uploads = .*/file_uploads = On/g" $PHP_INI
     phpfpmRestart
     FUNC="HTTP file uploads enabled"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "HTTP file uploads is enabled" --ok-button "OK" 10 70
   else
     $SED -i "s/file_uploads = .*/file_uploads = Off/g" $PHP_INI
     phpfpmRestart
     FUNC="HTTP file uploads disabled"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "HTTP file uploads is disabled" --ok-button "OK" 10 70
   fi
}
pmaxfilesize() {
     phpVersion
   if (whiptail --title "PHP Configuration" --yesno "You Entered: $MAXFILE" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/upload_max_filesize = .*/upload_max_filesize = $MAXFILE/g" $PHP_INI
     phpfpmRestart
     FUNC="Max file size modified to $MAXFILE"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "Max file size modified to $MAXFILE" --ok-button "OK" 10 70
   else
     phpmaxfilesize
   fi
}
phpmaxfilesize() {
     MAXFILE=$(whiptail --inputbox "\nMax upload file size IE: 4M. Default 2M" 10 70 --title "PHP Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     pmaxfilesize
   else
     cancelOperation
   fi
}
phpopcacheswitch() {
     phpVersion
   if (whiptail --title "PHP Configuration" --yesno "Do you want to enable Zend OPCache?\nDefault is disabled" --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/.*opcache.enable=.*/opcache.enable=1/g" $PHP_INI
     phpfpmRestart
     FUNC="Zend OPCache was enabled"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "Zend OPCache is enabled" --ok-button "OK" 10 70
   else
     $SED -i "s/.*opcache.enable=.*/opcache.enable=0/g" $PHP_INI
     phpfpmRestart
     FUNC="Zend OPCache was disabled"
     phpDebugLog
     whiptail --title "PHP Configuration" --msgbox "Zend OPCache is disabled" --ok-button "OK" 10 70
   fi
}
phptimezone() {
     phpVersion
     TIMEZONE=$(whiptail --inputbox "\nSet default timezone IE: America/New_York\nhttp://php.net/date.timezone" 10 70 --title "PHP Configuration" 3>&1 1>&2 2>&3)
     $SED -i "s@.*date.timezone = .*@date.timezone = $TIMEZONE@g" $PHP_INI
     phpfpmRestart
     whiptail --title "PHP Configuration" --msgbox "Default timezone modified to $TIMEZONE" --ok-button "OK" 10 70
}

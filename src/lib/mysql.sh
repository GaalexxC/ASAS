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
#        &Updated:   08/02/2018 00:36 EDT                                       #
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
# MySql System Functions
#
#****************************
mysqlErrorLog() {
     echo "Error date: $DATE_TIME\n\n$mysqlfail" >> $CURDIR/$LOGS/mysql-error-$CURDAY.log
}

mysqlDebugLog() {
     echo "$DATE_TIME: $FUNC" >> $CURDIR/$LOGS/mysql-$CURDAY.log
}
mysqlCheckInstall() {
   if ! type mysql > /dev/null 2>&1; then
     whiptail --title "MySQL Check-Install" --msgbox "MySQL not installed" --ok-button "OK" 10 70
     source $CURDIR/scripts/mysql_install.sh
   else
     dbver=$(mysql -V 2>&1)
     whiptail --title "MySQL Check-Install" --msgbox "MySQL Installed!\n\n$dbver" --ok-button "OK" 10 70
     source $CURDIR/scripts/mysql_install.sh
   fi
}
mysqlConfFile() {
{
     echo -e "XXX\n20\n\nBackup my.cnf file... \nXXX"
     sleep .95
     mv $MYSQLCONFIG $MYSQLCONFIG.bak
     echo -e "XXX\n40\n\nInstall new my.cnf... \nXXX"
     sleep .95
     cp $CURDIR/config/mysql/my.cnf $MYSQLCONFIG 2>/dev/null
     echo -e "XXX\n60\n\nSet permissions on  file... \nXXX"
     sleep .95
     chmod 644 $MYSQLCONFIG
     echo -e "XXX\n80\n\nSet ownership on my.cnf file... \nXXX"
     sleep .95
     chown root:root $MYSQLCONFIG
     echo -e "XXX\n100\n\nDefault Configuration Complete... Done.\nXXX"
     sleep .95
  } | whiptail --title "MySQL Installer" --gauge "\nConfiguring MySQL" 10 70 0
}
mysqlRestart() {
{
     $MYSQL_INIT restart 2> /dev/null
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     echo -e "XXX\n50\n\nStopping MySQL Service... Done.\nXXX"
     sleep 2
     echo -e "XXX\n100\n\nSuccessfully restarted MySQL... Done.\nXXX"
     sleep 1
   else
     echo -e "XXX\n0\n\nMySQL failed, check /var/log/mysql/mysql.log\nScript exiting in 3 seconds...\nXXX"
     sleep 3
    exit 1
   fi
     sleep .80
  } | whiptail --title "Restart MySQL" --gauge "\nRestarting the MySQL service" 10 70 0
}
perconaaddrepo() {
{

     echo -e "XXX\n25\n\nCreating repo directory... \nXXX"
   if [ ! -d  $CURDIR/repos ]; then
     mkdir $CURDIR/repos
   fi
     cd $CURDIR/repos
     sleep 1
     echo -e "XXX\n50\n\nFetching Percona Server 5.7 repository packages... \nXXX"
     wget $PERCONA_MYSQL 2> /dev/null
     sleep 1
     echo -e "XXX\n75\n\nInstalling Percona 5.7 repository packages... \nXXX"
     dpkg -i percona-release_0.1-6.$(lsb_release -sc)_all.deb 2> /dev/null
     FUNC="Repository Percona Server 5.7 installed"
     mysqlDebugLog
     cd $CURDIR
     echo -e "XXX\n100\n\nRepository Percona Server 5.7 installed... Done.\nXXX"
     sleep 1.5
  } | whiptail --title "MySQL Add Repo" --gauge "\nChecking for MySQL repository" 10 70 0
}
mysqlPassword() {
     PASS1=$(whiptail --passwordbox "\nPlease specify a mysql root password\nUse a strong UNIX type pass for security" 10 70 --title "MySQL Password" 3>&1 1>&2 2>&3)
     PASS2=$(whiptail --passwordbox "\nPlease specify password again" 10 70 --title "MySQL Password" 3>&1 1>&2 2>&3)
   if [ $PASS1 == $PASS2 ]
    then
     echo "percona-server-server-5.7 percona-server-server-5.7/root-pass password $PASS1" | debconf-set-selections
     echo "percona-server-server-5.7 percona-server-server-5.7/re-root-pass password $PASS2" | debconf-set-selections
    else
     mysqlPassword2
   fi
}
mysqlPassword2() {
   until [ $PASS1 == $PASS2 ]
   do
     whiptail --title "MySQL Password" --msgbox "Passwords dont match try again" --ok-button "OK" 10 70
     mysqlPassword
   done
}
mysqlCleanup() {
{
     echo -e "XXX\n33\n\nRemoving repo directory... \nXXX"
     rm -rf $CURDIR/repos
     sleep 1
     echo -e "XXX\n66\n\nRemoving debconf set data... \nXXX"
     echo PURGE | debconf-communicate percona-server-server-5.7 2>/dev/null
     sleep 1
     echo -e "XXX\n100\n\nCleanup complete... Done.\nXXX"
     sleep 1.5
  } | whiptail --title "MySQL Cleaner" --gauge "\nCleaning MySQL installation" 10 70 0
}
#*****************************
#
# MySQL Network Functions
#
#*****************************
msport() {
   if (whiptail --title "Port Config" --yesno "You Entered: $MSPORT" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/listen_port=.*/listen_port=$MSPORT/g" $MYSQLCONFIG
     mysqlRestart
     whiptail --title "Port Config" --msgbox "Port $MSPORT successfully updated" --ok-button "OK" 10 70
   else
     mysqlport
   fi
}
mysqlport() {
     MSPORT=$(whiptail --inputbox "\nEnter Port - Default:3306" 10 70 3306 --title "Port Config" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     msport
   else
     cancelOperation
   fi
}
#*****************************
#
# MySQL IP Functions
#
#*****************************
#*****************************
#
# MySQL Security Functions
#
#*****************************
mysqlbackupconf() {
{
     echo -e "XXX\n50\n\nBacking up MySQL configuration... \nXXX"
     tar cvpfz /mysqlcnf_backup_$CURDAY.tar.gz $MYSQLCONFIG 2> /dev/null
   if [ ! -d  $CURDIR/backups ]; then
     mkdir $CURDIR/backups
   fi
     mv /mysqlcnf_backup_$CURDAY.tar.gz $CURDIR/backups
     sleep 1
     echo -e "XXX\n100\n\nBackup to $CURDIR/backups... Done.\nXXX"
     sleep 1.5
  } | whiptail --title "MySQL Backup" --gauge "\nBacking up MySQL configuration" 10 70 0
}
#*****************************
#
# MySQL SSL Functions
#
#*****************************
mysqlsslenable() {
   if (whiptail --title "SSL Config" --yesno "Do you want to enable/disable SSL?\nDefault is disabled"  --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/ssl_enable=.*/ssl_enable=YES/g" $MYSQLCONFIG
     mysqlRestart
     whiptail --title "SSL Config" --msgbox "SSL is now enabled\nPlease add cert/key paths in configuration menu" --ok-button "OK" 10 70
   else
     $SED -i "s/ssl_enable=.*/ssl_enable=NO/g" $MYSQLCONFIG
     mysqlRestart
     whiptail --title "SSL Config" --msgbox "SSL is now disabled" --ok-button "OK" 10 70
   fi
}
mssslcert() {
   if (whiptail --title "SSL Cert Config" --yesno "You Entered:\n$SSLCERT" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s@rsa_cert_file=.*@rsa_cert_file=$SSLCERT@g" $MYSQLCONFIG
     mysqlRestart
     whiptail --title "SSL Cert Config" --msgbox "Path $SSLCERT updated" --ok-button "OK" 10 70
   else
     mysqlsslcert
   fi
}
mysqlsslcert() {
     SSLCERT=$(whiptail --inputbox "\nEnter full path to SSL cert\nIE: /etc/ssl/certs/mysql.pem" 10 70 --title "SSL Cert Config" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     mssslcert
   else
     cancelOperation
   fi
}
mssslkey() {
   if (whiptail --title "SSL Key Config" --yesno "You Entered:\n$SSLKEY" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s@rsa_private_key_file=.*@rsa_private_key_file=$SSLKEY@g" $MYSQLCONFIG
     mysqlRestart
     whiptail --title "SSL Key Config" --msgbox "Path $SSLKEY updated" --ok-button "OK" 10 70
   else
     mysqlsslkey
   fi
}
mysqlsslkey() {
     SSLKEY=$(whiptail --inputbox "\nEnter full path to SSL key\nIE: /etc/ssl/private/mysql.key" 10 70 --title "SSL Key Config" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     mssslkey
   else
     cancelOperation
   fi
}


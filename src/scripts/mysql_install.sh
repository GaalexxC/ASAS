#!/bin/bash
#################################################################################
#                   *** ASAS 2.10 [Auto Server Admin Script] ***                #
#        @author: Gary Cornell for devCU Software Open Source Projects          #
#        @contact: gary@devcu.com                                               #
#        $OS: Debian Core (Tested on Ubuntu 16x -> 18x / Debian 8.x -> 9.x)     #
#        $MAIN: https://www.devcu.com                                           #
#        $SOURCE: https://github.com/GaalexxC/ASAS                              #
#        $REPO: https://www.devcu.net                                           #
#        +Created:   06/15/2016 Ported from nginxubuntu-php7                    #
#        &Updated:   08/09/2020                                                 #
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

      if [ ! -f $CURDIR/$LOGS/mysql-error-$CURDAY.log ]
       then
       touch $CURDIR/$LOGS/mysql-error-$CURDAY.log
      fi
      if [ ! -f $CURDIR/$LOGS/mysql-$CURDAY.log ]
       then
       touch $CURDIR/$LOGS/mysql-$CURDAY.log
      fi

while [ 4 ]
do

SELECTMYSQL=$(
whiptail --title "MySQL Installer" --radiolist "\nUse up/down arrows and space to select\nUpon selection operation will begin without prompts" 20 78 10 \
        "1)" "Percona MySQL Server 8.x (Recommended)" ON \
        "2)" "MariaDB MySQL Server 10.x" OFF \
        "3)" "Oracle MySQL Server 5.7" OFF \
        "4)" "Configure Mysql Settings" OFF \
        "5)" "Backup Config (my.cnf)" OFF \
        "6)" "View Debug Log" OFF \
        "7)" "View Error Log" OFF \
        "8)" "View MySQL Server Log" OFF \
        "9)" "Remove MySQL (Config Saved)" OFF \
        "10)" "Purge MySQL (Wipe Clean)" OFF \
        "11)" "Return to Main Menu" OFF \
        "12)" "Exit" OFF 3>&1 1>&2 2>&3
)

case $SELECTMYSQL in
        "1)")

     if ! type mysql > /dev/null 2>&1; then
       if (whiptail --title "Install MySQL" --yesno "Installing latest Percona MySQL Server v8.x\n\nWould you like to continue?" --yes-button "Install" --no-button "Cancel" 10 70) then
        package() {
         printf "apt --yes install gnupg2"
        }
        perconaaddrepo
        pkgcache() {
         printf "percona-release setup ps80"
        }
        updateSources
        mysqlPassword
        package() {
         printf "apt --yes install percona-server-server"
        }
        systemInstaller
        mysqlCleanup
        MYSQLVER=$(mysql -V 2>&1)
        FUNC="Installed $MYSQLVER"
        mysqlDebugLog
        completemessage() {
         printf "Installed\n$MYSQLVER"
        }
        completeOperation
     else
        cancelOperation
     fi
     else
        whiptail --title "MySQL Check-Install" --msgbox "MySQL already installed\n$MYSQLVER" --ok-button "OK" 10 70
     fi
        ;;

        "2)")

     if ! type mysql > /dev/null 2>&1; then
       if (whiptail --title "Install MySQL" --yesno "Installing latest MariaDB MySQL Server v10.x\n\nWould you like to continue?" --yes-button "Install" --no-button "Cancel" 10 70) then
        mariadbaddrepo
        updateSources
        mysqlPassword
        package() {
         printf "apt --yes install mariadb-server"
        }
        systemInstaller
        mysqlCleanup
        MYSQLVER=$(mysql -V 2>&1)
        FUNC="Installed $MYSQLVER"
        mysqlDebugLog
        completemessage() {
         printf "Installed\n$MYSQLVER"
        }
        completeOperation
     else
        cancelOperation
     fi
     else
        whiptail --title "MySQL Check-Install" --msgbox "MySQL already installed\n$MYSQLVER" --ok-button "OK" 10 70
     fi
        ;;

        "3)")

     if ! type mysql > /dev/null 2>&1; then
        whiptail --title "MySQL Check-Install" --msgbox "MySQL not installed" --ok-button "OK" 10 7
       #phpDependencyCheck
       #package() {
       #  printf "apt --yes install $PHP70_PACKAGES"
       #}
       #systemInstaller
       #completeOperation
     else
        dbver=$(mysql -V 2>&1)
        whiptail --title "MySQL Check-Install" --msgbox "MySQL Installed!\n\n$dbver" --ok-button "OK" 10 7
     fi
        ;;

        "4)")

     if ! type mysql > /dev/null 2>&1; then
       whiptail --title "MySQL Check-Install" --msgbox "MySQL not installed" --ok-button "OK" 10 70
     else
       source $CURDIR/scripts/mysql_configure.sh
     fi
        ;;

        "5)")

     if ! type mysql > /dev/null 2>&1; then
       whiptail --title "MySQL Check-Install" --msgbox "MySQL not installed" --ok-button "OK" 10 70
     else
        whiptail --title "MySQL Check-Install" --msgbox "MySQL not installed" --ok-button "OK" 10 7
       #mysqlBackupConf
     fi
        ;;

        "6)")
         whiptail --textbox $CURDIR/$LOGS/mysql-$CURDAY.log 24 78 10
        ;;

        "7)")
         whiptail --textbox $CURDIR/$LOGS/mysql-error-$CURDAY.log 24 78 10
        ;;

        "8)")
         whiptail --textbox /var/log/mysql/error.log 24 78 10
        ;;


        "9)")

   if type mysql > /dev/null 2>&1; then
    if (whiptail --title "Remove MySQL" --yesno "Warning! Removes MySQL (Preserves Configurations)\n\nWould you like to remove MySQL" --yes-button "Remove" --no-button "Cancel" 10 70) then
       package() {
         printf "apt --yes remove mysql"
       }
       systemInstaller
       sleep 1
       pkgcache() {
          printf "apt-get --yes autoremove"
       }
       updateSources
       sleep 1
       phpPurge
       sleep 1
       pkgcache() {
          printf "apt-get autoclean"
       }
       updateSources
       sleep 1
         whiptail --title "Remove MySQL" --msgbox "MySQL has been removed from system" --ok-button "OK" 10 70
      else
       cancelOperation
    fi
      else
       whiptail --title "Remove MySQL" --msgbox "Nothing to do MySQL not installed" --ok-button "OK" 10 70
   fi
        ;;

        "10)")

   if type mysql > /dev/null 2>&1; then
    if (whiptail --title "Purge MySQL" --yesno "Warning! Wipes all traces of MySQL from your system!\nAll config/databases/logs/repos...etc deleted!\n\nWould you like to purge PHP?" --yes-button "Purge" --no-button "Cancel" 10 70) then
       package() {
         printf "apt --yes purge mysql"
       }
       systemInstaller
       sleep 1
       pkgcache() {
          printf "apt-get --yes autoremove"
       }
       updateSources
       sleep 1
       phpPurge
       sleep 1
       pkgcache() {
          printf "apt-get autoclean"
       }
       updateSources
       sleep 1
         whiptail --title "Purge MySQL" --msgbox "MySQL has been wiped from system" --ok-button "OK" 10 70
    else
       cancelOperation
    fi
   else
         whiptail --title "Purge MySQL" --msgbox "Nothing to do MySQL not installed" --ok-button "OK" 10 70
   fi
        ;;

        "11)")

     return

        ;;

        "12)")

     exit 1

        ;;
  esac

 done

exit

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
#        &Updated:   11/07/2017 18:08 EDT                                       #
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

while [ 5 ]
do

SELECTFTP=$(
whiptail --title "vsFTPd Installer" --radiolist "\nUse up/down arrows and tab to select a operation\nUpon selection operation will begin without prompts" 20 78 8 \
        "1)" "Install vsFTPd" ON \
        "2)" "Configure vsFTPd Settings" OFF \
        "3)" "Backup Config (vsftpd.conf)" OFF \
        "4)" "Remove vsFTPd (Config Saved)" OFF \
        "5)" "Purge vsFTPd (Wipe Clean)" OFF \
        "6)" "Return to Main Menu" OFF \
        "7)" "Exit" OFF 3>&1 1>&2 2>&3
)

case $SELECTFTP in
        "1)")
      if ! type vsftpd > /dev/null 2>&1; then
          package() {
           printf "apt --yes install vsftpd"
         }
          systemInstaller
          vsftpdConfFile
          vsftpdRestart
          ftpver=$(vsftpd -v 0>&1)
          whiptail --title "vsFTPd Installed" --msgbox "$ftpver installed\nvsFTPd has been configured on default port 23452\nYou can change this and other settings from menu" --ok-button "OK" 12 70
       else
          ftpver=$(vsftpd -v 0>&1)
          whiptail --title "vsFTPd Check" --msgbox "$ftpver is already installed\nPress [Enter] to return to vsFTPd menu" --ok-button "OK" 10 70
      fi
        ;;

        "2)")

      if type vsftpd > /dev/null 2>&1; then
         source $CURDIR/scripts/vsftpd_configure.sh
       else
         whiptail --title "vsFTPd Check" --msgbox "vsFTPd is not installed\nPress [Enter] to return to vsFTPd menu" --ok-button "OK" 10 70
      fi
       ;;

        "3)")
      if type vsftpd > /dev/null 2>&1; then
         vsftpdbackupconf
       else
         whiptail --title "vsFTPd Check" --msgbox "vsFTPd is not installed\nPress [Enter] to return to vsFTPd menu" --ok-button "OK" 10 70
      fi
       ;;

        "4)")
      if type vsftpd > /dev/null 2>&1; then
        package() {
          printf "apt --yes remove vsftpd"
        }
        systemInstaller
        sleep 1
        pkgcache() {
           printf "apt-get --yes autoremove"
        }
        updateSources
        sleep 1
       else
         whiptail --title "vsFTPd Check" --msgbox "vsFTPd is not installed\nPress [Enter] to return to vsFTPd menu" --ok-button "OK" 10 70
      fi
        ;;

        "5)")
      if type vsftpd > /dev/null 2>&1; then
        package() {
          printf "apt --yes purge vsftpd"
        }
        systemInstaller
        sleep 1
        pkgcache() {
           printf "apt-get --yes autoremove"
        }
        updateSources
        rm -rf /var/log/vsftpd.log
        sleep 1
       else
         whiptail --title "vsFTPd Check" --msgbox "vsFTPd is not installed\nPress [Enter] to return to vsFTPd menu" --ok-button "OK" 10 70
      fi
        ;;
        "6)")

       return
        ;;

        "7)")

       exit 1
        ;;
  esac

 done

exit

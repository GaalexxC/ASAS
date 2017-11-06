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
#        &Updated:   11/06/2017 00:01 EDT                                       #
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
        "2)" "Configure vsFTPd" OFF \
        "3)" "Purge vsFTPd (No Config Backup)" OFF \
        "4)" "Return to Main Menu" OFF \
        "5)" "Exit" OFF 3>&1 1>&2 2>&3
)

case $SELECTFTP in
        "1)")
      if ! type vsftpd > /dev/null 2>&1; then
          package() {
           printf "apt --yes install vsftpd"
         }
          systemInstaller
          vsftpdConfFile
          ftpver=$(vsftpd -v 0>&1)
          whiptail --title "vsFTPd Installed" --msgbox "$ftpver installed\nDefault port is 23452 (Run configure vsFTPd to edit)\nPress [Enter] to return to vsFTPd menu" --ok-button "OK" 10 70
       else
          ftpver=$(vsftpd -v 0>&1)
          whiptail --title "vsFTPd Check" --msgbox "$ftpver is already installed\nPress [Enter] to return to vsFTPd menu" --ok-button "OK" 10 70
      fi
        ;;

        "2)")

      if type vsftpd > /dev/null 2>&1; then
         vsftpdport
         vsftpdipadd6
         vsftpdRestart
       else
         whiptail --title "vsFTPd Check" --msgbox "vsFTPd is not installed\nPress [Enter] to return to vsFTPd menu" --ok-button "OK" 10 70
      fi
       ;;

        "3)")
      if type vsftpd > /dev/null 2>&1; then
        package() {
          printf "apt --yes purge vsftpd"
        }
        systemInstaller
        sleep 1
        pkgcache() {
           printf "apt-get --yes  autoremove"
        }
        updateSources
        sleep 1
       else
         whiptail --title "vsFTPd Check" --msgbox "vsFTPd is not installed\nPress [Enter] to return to vsFTPd menu" --ok-button "OK" 10 70
      fi
        ;;

        "4)")

       return
        ;;

        "5)")

       exit 1
        ;;
  esac

 done

exit




     echo -e "\nConfigure vsFTPd -  We will use IPv6 enabled"
     echo -n "Enter Port - Something high like 23450 > "
     read VPORT
     echo "You Entered: $VPORT"
     echo -n "Optional: Enter IPv4 IP listen address - leave blank for none"
     read VIPADD
     echo "You Entered: $VIPADD"
     echo -n "Optional: Enter IPv6 IP listen address - leave blank for none"
     read VIPADD6
     echo "You Entered: $VIPADD6"
     sleep 1
     echo -e "\nMaking backup of original vsftpd.conf"
     sudo mv /etc/vsftpd.conf /etc/vsftpd.conf.bak
     CONFIG=/etc/vsftpd.conf
     cp config/vsftpd/vsftpd.conf $CONFIG

     $SED -i "s/@@VPORT@@/$VPORT/g" $CONFIG
     $SED -i "s/@@VIPADD@@/$VIPADD/g" $CONFIG
     $SED -i "s/@@VIPADD6@@/$VIPADD6/g" $CONFIG

     chmod 644 /etc/vsftpd.conf
     chown root:root /etc/vsftpd.conf
     echo -e "Restarting FTP Server\n"
     $VSFTPD_INIT
     echo -e "\nvsFTPd  has been configured on port $VPORT."
     echo -e "\nTo enable TLS/SSL please edit the vsftpd.conf manually and uncomment"
     echo -e "\nSSL options setting proper cert/key paths as well if using custom SSL\n"
     read -p "Press [Enter] key to return to main menu..."
     return

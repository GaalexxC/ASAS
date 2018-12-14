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
#        &Updated:   12/14/2018 01:12 EDT                                       #
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

SELECTBIND9=$(
whiptail --title "Bind9 Installer" --radiolist "\nUse up/down arrows and space to select\nUpon selection operation will begin without prompts" 18 78 10 \
        "1)" "Install Bind9 DNS server" OFF \
        "2)" "Configure Named Conf" OFF \
        "2)" "Configure Named Local" ON \
        "4)" "Configure Named Options" OFF \
        "5)" "Configure Domain" OFF \
        "6)" "Configure DNSSEC" OFF \
        "7)" "Backup Config ()" OFF \
        "8)" "Remove Bind9 (Config Saved)" OFF \
        "9)" "Purge Bind9 (Wipe Clean)" OFF \
        "10)" "Return to Main Menu" OFF \
        "11)" "Exit" OFF 3>&1 1>&2 2>&3
)

case $SELECTBIND9 in
        "1)")

     if ! type named > /dev/null 2>&1; then
       whiptail --title "Bind9 Check-Install" --msgbox "Bind9 not installed" --ok-button "OK" 10 70
     else
        bindver=$(named -V 2>&1)
        whiptail --title "Bind9 Check-Install" --msgbox "Bind9 Installed!\n\n$bindver" --ok-button "OK" 10 7
     fi
        ;;

        "2)")

     if ! type named > /dev/null 2>&1; then
       whiptail --title "Bind9 Check-Install" --msgbox "Bind9 not installed" --ok-button "OK" 10 70
     else
       source $CURDIR/scripts/bind9_configure.sh
     fi
        ;;

        "3)")

     if ! type named > /dev/null 2>&1; then
       whiptail --title "Bind9 Check-Install" --msgbox "Bind9 not installed" --ok-button "OK" 10 70
     else
       source $CURDIR/scripts/bind9_configure.sh
     fi
        ;;

        "4)")

     if ! type named > /dev/null 2>&1; then
       whiptail --title "Bind9 Check-Install" --msgbox "Bind9 not installed" --ok-button "OK" 10 70
     else
       source $CURDIR/scripts/bind9_configure.sh
     fi
        ;;

        "5)")

     if ! type named > /dev/null 2>&1; then
       whiptail --title "Bind9 Check-Install" --msgbox "Bind9 not installed" --ok-button "OK" 10 70
     else
       source $CURDIR/scripts/bind9_configure.sh
     fi
        ;;

        "6)")

     if ! type named > /dev/null 2>&1; then
       whiptail --title "Bind9 Check-Install" --msgbox "Bind9 not installed" --ok-button "OK" 10 70
     else
       source $CURDIR/scripts/bind9_configure.sh
     fi
        ;;

        "7)")

     if ! type named > /dev/null 2>&1; then
       whiptail --title "Bind9 Check-Install" --msgbox "Bind9 not installed" --ok-button "OK" 10 70
     else
       source $CURDIR/scripts/bind9_configure.sh
     fi
        ;;

        "8)")

   if type named > /dev/null 2>&1; then
    if (whiptail --title "Remove Bind9" --yesno "Warning! Removes Bind9 (Preserves Configurations)\n\nWould you like to remove Bind9" --yes-button "Remove" --no-button "Cancel" 10 70) then
       package() {
         printf "apt --yes remove bind9"
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
         whiptail --title "Remove Bind9" --msgbox "Bind9 has been removed from system" --ok-button "OK" 10 70
      else
       cancelOperation
    fi
      else
       whiptail --title "Remove Bind9" --msgbox "Nothing to do Bind9 not installed" --ok-button "OK" 10 70
   fi
        ;;

        "9)")

   if type named > /dev/null 2>&1; then
    if (whiptail --title "Purge Bind9" --yesno "Warning! Wipes all traces of Bind9 from your system!\nAll config/.db/logs...etc deleted!\n\nWould you like to purge PHP?" --yes-button "Purge" --no-button "Cancel" 10 70) then
       package() {
         printf "apt --yes purge bind9"
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
         whiptail --title "Purge Bind9" --msgbox "Bind9 has been wiped from system" --ok-button "OK" 10 70
    else
       cancelOperation
    fi
   else
         whiptail --title "Purge Bind9" --msgbox "Nothing to do Bind9 not installed" --ok-button "OK" 10 70
   fi
        ;;

        "10)")

     return

        ;;

        "11)")

     exit 1

        ;;
  esac

 done

exit

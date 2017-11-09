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
#        &Updated:   11/08/2017 20:15 EDT                                       #
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
################################################################################
clear

while [ 1 ]
do
BIND9SETTINGS=$(
whiptail --title "Bind9 Configuration" --menu "\nConfigure most common settings below\nEdit nginx.conf manually for extended options" 24 78 14 \
        "1)" "Test (Default:None)"   \
        "2)" "Test (Default:None)" \
        "3)" "Test (Default:None)"  \
        "4)" "Test (Default:None)" \
        "5)" "Test (Default:None)" \
        "6)" "Test (Default:None)" \
        "7)" "Test (Default:None)" \
        "8)" "Test (Default:None)" \
        "9)" "Test (Default:None)" \
       "10)" "Return to Nginx Menu" \
       "11)" "Return to Main Menu" \
       "12)" "Exit"  3>&2 2>&1 1>&3
)

case $BIND9SETTINGS in
        "1)")
                #phpengineenable
        ;;

        "2)")
                #vsftpdip4add
        ;;

        "3)")
                #vsftpdip6enable
        ;;

        "4)")
                #vsftpdip6add
        ;;

        "5)")
                #vsftpdhidedot
        ;;

        "6)")
                #vsftpdanonymous
        ;;

        "7)")
                #vsftpdsslenable
        ;;

        "8)")
                #vsftpdsslcert
        ;;

        "9)")
                #vsftpdsslkey
        ;;

        "10)")
               return
        ;;

        "11)")
               asasMainMenu
        ;;

        "12)")
               exit 1
        ;;
   esac

 done

exit

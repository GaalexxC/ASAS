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
#        &Updated:   12/24/2017 02:11 EDT                                       #
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
NGINXSETTINGS=$(
whiptail --title "Nginx Configuration" --menu "\nConfigure most common settings below\nEdit nginx.conf manually for extended options" 24 78 14 \
        "1)" "Nginx Worker Processes (Default:4)"   \
        "2)" "Nginx Worker Connections (Default:2500)" \
        "3)" "Nginx Wworker rlimit_nofile (Default:20000)"  \
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

case $NGINXSETTINGS in
        "1)")
          nginxworkerproc
        ;;

        "2)")
          nginxworkerconn
        ;;

        "3)")
          nginxworkerrlimit
        ;;

        "4)")
          #nginx
        ;;

        "5)")
          #nginx
        ;;

        "6)")
          #nginx
        ;;

        "7)")
          #nginx
        ;;

        "8)")
          #nginx
        ;;

        "9)")
          #nginx
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



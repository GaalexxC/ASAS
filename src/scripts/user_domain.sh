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
#        &Updated:   11/09/2017 13:57 EDT                                       #
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

while [ 2 ]
do

SELECTUSERDOMAIN=$(
whiptail --title "User Domain Installer" --radiolist "\nUse up/down arrows and space to select\nUpon selection operation will begin without prompts" 18 78 10 \
        "1)" "New User and Domain (Remote Server)" ON \
        "2)" "New User and localhost (Local Server)" OFF \
        "3)" "List Active vhosts" OFF \
        "4)" "List Active FPM confs" OFF \
        "5)" "Test Available IPs" OFF \
        "6)" "Return to Main Menu" OFF \
        "7)" "Exit"  OFF 3>&1 1>&2 2>&3
)


case $SELECTUSERDOMAIN in
        "1)")

        return
        ;;

        "2)")

        return
        ;;

        "3)")

        return
        ;;


        "4)")

        return
        ;;


        "5)")

        return
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


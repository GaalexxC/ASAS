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
#        &Updated:   03/25/2019 03:50 EDT                                       #
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

SELECTMAIL=$(
whiptail --title "Mail Installer" --radiolist "\nUse up/down arrows and space to select\nUpon selection operation will begin without prompts" 18 78 10 \
        "1)" "Postfix" ON \
        "2)" "Dovecot w/Dovecot Sieve" OFF \
        "3)" "Spamassassin" OFF \
        "4)" "Clamav" OFF \
        "5)" "Amavis-new" OFF \
        "6)" "Postgrey / DCC" OFF \
        "7)" "Pyzor / Razor" OFF \
        "8)" "Opendkim" OFF \
        "9)" "Mail Administration" OFF \
        "10)" "Return to Main Menu" OFF \
        "11)" "Exit"  OFF 3>&1 1>&2 2>&3
)


case $SELECTMAIL in
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

        return
        ;;


        "8)")

        return
        ;;


        "9)")

        return
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

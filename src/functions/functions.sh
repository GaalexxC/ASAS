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
#        &Updated:   11/07/2017 00:01 EDT                                       #
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
source $CURDIR/functions/global.sh
source $CURDIR/functions/nginx.sh
source $CURDIR/functions/vsftpd.sh
#*****************************
#
# Testing Ground
#
#*****************************
secureCheckModify2() {
            i=0
            $(secureCommand) 2> /dev/null | \
            while read x; do
            case $x in
        *+*)
            count=20
            i=0
        ;;
           +*\ ...)
            proc=$(ps aux | grep -v grep | grep -e "$(secureApp)")
            if [[ "$proc" == "" ]] && [[ $count -gt 0 ]]; then
                i=$((i+1))
                x=${x% (*}
                x=${x% ...}
                x=$(echo ${x:1})
                sleep .50
                printf "XXX\n$((i*100/count))\n\n${x}\nXXX\n$((i*100/count))\n"
           fi
        ;;
    esac
done | whiptail --title "Security Check-Modify"  --gauge "\nGenerating DH parameters, 2048 bit long safe prime, generator 2\nThis is going to take a long time" 10 70 0
}

############
# File End #
############


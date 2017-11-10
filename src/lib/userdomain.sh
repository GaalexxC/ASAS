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
#        &Updated:   11/09/2017 13:02 EDT                                       #
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
# Basic Functions
#
#*****************************
listvhostshosts() {
   if [ ! -f /etc/nginx/sites-available/*.vhost ]; then
     vhostshosts="There are no vhost files to display"
   else
     vhostshosts="$(find /etc/nginx/sites-available/*.vhost  -exec  basename {} .vhost  \;)"
   fi
     echo "vhost files currently in use:\n$vhostshosts" > listvhostshosts_display
     whiptail --textbox listvhostshosts_display 12 80
}
listfpmconfs() {
   if [ ! -f /etc/php/7.0/fpm/pool.d/*.conf ]; then
     fpmconfs="There are no FPM conf files to display"
   else
     fpmconfs="$(find /etc/php/7.0/fpm/pool.d/*.conf  -exec  basename {} .vhost  \;)"
   fi
     echo "FPM conf files currently in use:\n$fpmconfs" > listfpmconfs_display
     whiptail --textbox listfpmconfs_display 12 80
}
listavailips() {
      listips="$(hostname -I)"
   if [ -z "$listips" ]
    then
      availips="There are no available IPs to display"
   else
      availips=$listips
   fi
     echo "Available IP Addresses:\n$availips" > listavailips_display
     whiptail --textbox listavailips_display 12 80
}
createuserdomain() {
   if (whiptail --title "Create User-Domain" --yesno "Create a new user with domain\n\nDefault uses directory paths from config/user_vars.conf\nIE /$HOME_PARTITION/USERNAME/$ROOT_DIRECTORY\n\nCustom allows you set custom paths for users web directory" --yes-button "Default" --no-button "Custom" 12 70) then
    return
  else
   return
   fi
}
createuserlocalhost() {
   if (whiptail --title "Create User-Localhost" --yesno "Create a new user with localhost\n\nDefault uses directory paths from config/user_vars.conf\nIE /$HOME_PARTITION/USERNAME/$ROOT_DIRECTORY\n\nCustom allows you set custom paths for users web directory" --yes-button "Default" --no-button "Custom" 12 70) then
    return
  else
   return
   fi
}
#*****************************
#
# User / localhost Functions
#
#*****************************
createlocalhost() {
   if [ ! -f /etc/nginx/sites-available/*.vhost ]; then
     vhostshosts="There are no vhost files to display"
   else
     vhostshosts="$(find /etc/nginx/sites-available/*.vhost  -exec  basename {} .vhost  \;)"
   fi
     LOCALVHOSTNAME=$(whiptail --inputbox "\nCreate Local vhost, name must be unique per user/web\nCurrent vhost files currently in use:\n$vhostshosts" 10 70 --title "Create Web" 3>&1 1>&2 2>&3)
     hostname="${cat /etc/hostname)"
     LOCALHOSTNAME=$(whiptail --inputbox "\nHostname of local server, you will access via the web\nIE: $hostname:8080" 10 70 --title "Create Web" 3>&1 1>&2 2>&3)
     USERNAME=$(whiptail --inputbox "\nEnter Port for localhost ex: 8080, 8081, 8090, etc" 10 70 --title "Create Web" 3>&1 1>&2 2>&3)
     read PORT
     echo "You Entered: $PORT"
   else
     echo "Invalid Hostname"
     exit 1
   fi
}
addpass() {
     #adduser -d /$HOME_PARTITION/$USERNAME $USERNAME 2> /dev/null
     useradd -d /$HOME_PARTITION/$USERNAME -p $ENCPASSWORD -s /bin/bash $USERNAME  2> /dev/null
     whiptail --title "New User" --msgbox "User $USERNAME successfully created" --ok-button "OK" 10 70
}
addpassword() {
     PASSWORD=$(whiptail --passwordbox "\nPlease specify a password" 10 70 --title "New User" 3>&1 1>&2 2>&3)
     PASSWORD2=$(whiptail --passwordbox "\nPlease specify password again" 10 70 --title "New User" 3>&1 1>&2 2>&3)
   if [ $PASSWORD == $PASSWORD2 ]
    then
     ENCPASSWORD="$(openssl passwd -crypt -quiet $PASSWORD)"
     addpass
   else
     whiptail --title "New User" --msgbox "Passwords dont match" --ok-button "OK" 10 70
     adddpassword
   fi
}
adduser() {
    if (whiptail --title "New User" --yesno "You Entered: $USERNAME" --yes-button "Continue" --no-button "Change" 10 70) then
     #adduser --home /$HOME_PARTITION/$USERNAME --disabled-login $USERNAME 2> /dev/null
     #useradd -d /$HOME_PARTITION/$USERNAME -p $PASSWORD -s /bin/bash $USERNAME
     addpassword
     #whiptail --title "New User" --msgbox "User $USERNAME successfully created" --ok-button "OK" 10 70
    else
     addusername
    fi
}
addusername() {
     USERNAME=$(whiptail --inputbox "\nPlease specify a username" 10 70 --title "New User" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     adduser
   else
     cancelOperation
   fi
}
#*****************************
#
# User / domain Functions
#
#*****************************

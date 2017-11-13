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
#        &Updated:   11/13/2017 04:39 EDT                                       #
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
listvhostsusers() {
   if [ ! -f $CURDIR/tmp/.user ]; then
     whiptail --title "User List" --msgbox "There are no users to display" --ok-button "OK" 10 70
   else
     whiptail --textbox $CURDIR/tmp/.user 12 80
   fi
}
listvhostshosts() {
   if [ -z "/etc/nginx/sites-available/*.vhost" ]; then
     vhostshosts="There are no vhost files to display"
   else
     vhostshosts="$(find /etc/nginx/sites-available/*.vhost  -exec  basename {} .vhost  \;)"
   fi
     echo "vhost files currently in use:\n$vhostshosts" > $CURDIR/tmp/listvhostshosts_display
     whiptail --textbox $CURDIR/tmp/listvhostshosts_display 12 80
}
listfpmconfs() {
   if [ -z "/etc/php/7.0/fpm/pool.d/*.conf" ]; then
     fpmconfs="There are no FPM conf files to display"
   else
     fpmconfs="$(find /etc/php/7.0/fpm/pool.d/*.conf  -exec  basename {} .vhost  \;)"
   fi
     echo "FPM conf files currently in use:\n$fpmconfs" > $CURDIR/tmp/listfpmconfs_display
     whiptail --textbox $CURDIR/tmp/listfpmconfs_display 12 80
}
listavailips() {
   if [ -z "$HOSTLISTIPS" ]
    then
      availips="There are no available IPs to display"
   else
      availips=$HOSTLISTIPS
   fi
     echo "Available IP Addresses:\n$availips" > $CURDIR/tmp/listavailips_display
     whiptail --textbox $CURDIR/tmp/listavailips_display 12 80
}
#*****************************
#
# User / localhost Functions
#
#*****************************
createuserlocalhost() {
   if (whiptail --title "Web Creator" --yesno "Create a new user/localhost vhost/PHP_FPM localhost conf\n\nDefault uses directory paths from config/user_vars.conf\nIE /$HOME_PARTITION/USERNAME/$ROOT_DIRECTORY\n\nCustom allows you set custom paths for users web directory" --yes-button "Default" --no-button "Custom" 12 70) then
     addusernamelocal
   else
     #addusername
     whiptail --title "Web Creator" --msgbox "Domain Creator not ready yet" --ok-button "OK" 10 70
   fi
}
addusernamelocal() {
     USERNAME=$(whiptail --inputbox "\nPlease specify a username" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     PASSWORD=$(whiptail --passwordbox "\nPlease specify a password\nUse a strong UNIX type pass for security" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)
     PASSWORD2=$(whiptail --passwordbox "\nPlease specify password again" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)
   if [ $PASSWORD == $PASSWORD2 ]
    then
     ENCPASSWORD="$(openssl passwd -crypt -quiet $PASSWORD)"
     useradd -d /$HOME_PARTITION/$USERNAME -p $ENCPASSWORD -s /bin/bash $USERNAME 2> /dev/null
     whiptail --title "Web Creator" --msgbox "User $USERNAME successfully created" --ok-button "OK" 10 70
     createlocalsettings
    else
     whiptail --title "Web Creator" --msgbox "Passwords dont match" --ok-button "OK" 10 70
     createuserlocalhost
   fi
    else
     cancelOperation
   fi
}
createlocalsettings() {
   if [ ! -f /etc/nginx/sites-available/*.vhost ]; then
     vhostshosts="There are no vhost files to display"
   else
     vhostshosts="$(find /etc/nginx/sites-available/*.vhost  -exec  basename {} .vhost  \;)"
   fi
     VHOSTNAMEADD=$(whiptail --inputbox "\nCreate Local vhost, name must be unique per user/web\nCurrent vhost files currently in use:\n$vhostshosts" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)
     HOSTNAMEADD=$(whiptail --inputbox "\nHostname of local server, you will access via the web\nDefault: $HOSTNAME:8080" 10 70 $HOSTNAME --title "Web Creator" 3>&1 1>&2 2>&3)
     HOSTPORTADD=$(whiptail --inputbox "\nEnter Port for localhost ex: 8080, 8081, 8090, etc" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)
     HOSTIPADD=$(whiptail --inputbox "\nEnter IP for localhost (optional) leave blank for none\nCurrent available IPs:\n$HOSTLISTIPS" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)

     MAX_SERVERS=$(whiptail --inputbox "\nMax # Spare FPM Servers\nDefault: 6" 10 70 6 --title "Web Creator" 3>&1 1>&2 2>&3)
     MAX_CHILDREN=$(whiptail --inputbox "\nFPM Max Children\nMust be higher then max servers\nDefault: 8" 10 70 8 --title "Web Creator" 3>&1 1>&2 2>&3)
     MIN_SERVERS=$(whiptail --inputbox "\nMin # Spare FPM Servers\nDefault: 2" 10 70 2 --title "Web Creator" 3>&1 1>&2 2>&3)
     FPM_SERVERS=$(whiptail --inputbox "\n# start FPM Servers\nMust not be less than min spare servers\nand not greater than max spare servers\nDefault: 4" 10 70 4 --title "Web Creator" 3>&1 1>&2 2>&3)
   if (whiptail --title "Web Creator" --yesno "Your Settings:\nUser: $USERNAME\nPath to Root:/$HOME_PARTITION/$USERNAME/$ROOT_DIRECTORY\nHostname:$HOSTNAMEADD\nPort:$HOSTPORTADD\nIP Address:$HOSTIPADD" --yes-button "Create" --no-button "Cancel" 12 70) then
     echo "$USERNAME-$VHOSTNAMEADD" >> $CURDIR/tmp/.user
     createlocalhost
    else
   return
    fi
}
createlocalhost() {
{
       echo -e "XXX\n15\n\nStart Web Configuration...\nXXX"
     VHOSTCONFIG=$NGINX_SITES_AVAILABLE/$VHOSTNAMEADD.vhost
     cp $CURDIR/templates/local.vhost.template $VHOSTCONFIG 2> /dev/null
     sleep 1
       echo -e "XXX\n20\n\nInstalling $VHOSTNAMEADD.vhost file...\nXXX"
     HOME_DIR=$USERNAME
     PUBLIC_HTML_DIR=/$ROOT_DIRECTORY
     $SED -i "s/@@HOSTNAME@@/$HOSTNAMEADD/g" $VHOSTCONFIG
     $SED -i "s/@@PORT@@/$HOSTPORTADD/g" $VHOSTCONFIG
     $SED -i "s#@@PATH@@#\/$HOME_PARTITION\/"$USERNAME$PUBLIC_HTML_DIR"#g" $VHOSTCONFIG
     sleep 1.25
       echo -e "XXX\n30\n\nInstalling $VHOSTNAMEADD.vhost file...\nXXX"
     $SED -i "s/@@LOG_PATH@@/\/$HOME_PARTITION\/$USERNAME\/logs/g" $VHOSTCONFIG
     $SED -i "s/@@SSL_PATH@@/\/$HOME_PARTITION\/$USERNAME\/ssl/g" $VHOSTCONFIG
     $SED -i "s#@@SOCKET@@#/var/run/"$USERNAME"_fpm.sock#g" $VHOSTCONFIG
     sleep 1.25
       echo -e "XXX\n45\n\nCreate FPM $VHOSTNAMEADD.conf file...\nXXX"
     phpVersion
     FPMCONFIG="$PHP_FPMCONF_DIR/$VHOSTNAMEADD.conf"
     cp $CURDIR/templates/conf.template $FPMCONFIG 2> /dev/null
     sleep 1.25
       echo -e "XXX\n55\n\nPopulate $VHOSTNAMEADD.conf file...\nXXX"
     $SED -i "s/@@USER@@/$USERNAME/g" $FPMCONFIG
     $SED -i "s/@@GROUP@@/$USERNAME/g" $FPMCONFIG
     $SED -i "s/@@HOME_DIR@@/\/$HOME_PARTITION\/$USERNAME/g" $FPMCONFIG
     $SED -i "s/@@MAX_CHILDREN@@/$MAX_CHILDREN/g" $FPMCONFIG
     $SED -i "s/@@START_SERVERS@@/$FPM_SERVERS/g" $FPMCONFIG
     $SED -i "s/@@MIN_SERVERS@@/$MIN_SERVERS/g" $FPMCONFIG
     $SED -i "s/@@MAX_SERVERS@@/$MAX_SERVERS/g" $FPMCONFIG
     sleep 1.25
       echo -e "XXX\n65\n\nSet System Permissions...\nXXX"
     usermod -aG $USERNAME $WEB_SERVER_GROUP 2> /dev/null
     chmod 600 $VHOSTCONFIG
     ln -s $NGINX_SITES_AVAILABLE/$VHOSTNAMEADD.vhost $NGINX_SITES_ENABLED/
     sleep 1.25
       echo -e "XXX\n75\n\nInstalling Web Directories...\nXXX"
     mkdir -p /$HOME_PARTITION/$HOME_DIR
     chmod g+rx /$HOME_PARTITION/$HOME_DIR
     mkdir -p /$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR
     mkdir -p /$HOME_PARTITION/$HOME_DIR/logs
     mkdir -p /$HOME_PARTITION/$HOME_DIR/ssl
     mkdir -p /$HOME_PARTITION/$HOME_DIR/_sessions
     mkdir -p /$HOME_PARTITION/$HOME_DIR/backup
     sleep 1.25
       echo -e "XXX\n85\n\nInstalling index.php placeholder page...\nXXX"
     CONFIGPATH=/$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR/
     cp -rf $CURDIR/skel/* $CONFIGPATH 2> /dev/null
     sleep 1.25
       echo -e "XXX\n90\n\nSetting Web Directory Permissions...\nXXX"
     chmod 750 /$HOME_PARTITION/$HOME_DIR -R
     chmod 700 /$HOME_PARTITION/$HOME_DIR/_sessions
     chmod 770 /$HOME_PARTITION/$HOME_DIR/ssl
     chmod 770 /$HOME_PARTITION/$HOME_DIR/logs
     chmod 770 /$HOME_PARTITION/$HOME_DIR/backup
     chmod 750 /$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR
     chmod 644 /$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR/index.php
     chown $USERNAME:$USERNAME /$HOME_PARTITION/$HOME_DIR/ -R
     chown root:root /$HOME_PARTITION/$HOME_DIR/ssl -R
     chown root:root /$HOME_PARTITION/$HOME_DIR/backup -R
     sleep 1.25
       echo -e "XXX\n95\n\nSetup User and Web Complete...\nXXX"
     sleep 1.25
       echo -e "XXX\n96\n\n$VHOSTNAMEADD created for $USERNAME + PHP support $HOSTNAMEADD on port $HOSTPORTADD... \nXXX"
     sleep 8
       echo -e "XXX\n97\n\nRestart Services...\nXXX"
     $NGINX_INIT restart 2> /dev/null
     sleep .5
       echo -e "XXX\n98\n\nRestart Services...\nXXX"
     $PHP_INIT restart 2> /dev/null
     sleep .5
       echo -e "XXX\n99\n\nRestart Services...\nXXX"
     sleep .5
  } | whiptail --title "Web Creator" --gauge "\nCreating User and Web" 10 70 0
}
#*****************************
#
# User / domain Functions
#
#*****************************
createuserdomainhost() {
   if (whiptail --title "Web Creator" --yesno "Create a new user/domain vhost/PHP_FPM domain conf\n\nDefault uses directory paths from config/user_vars.conf\nIE /$HOME_PARTITION/USERNAME/$ROOT_DIRECTORY\n\nCustom allows you set custom paths for users web directory" --yes-button "Default" --no-button "Custom" 12 70) then
     addusernamedomain
    else
     #addusername
     whiptail --title "Web Creator" --msgbox "Domain Creator not ready yet" --ok-button "OK" 10 70
   fi
}
addusernamedomain() {
     USERNAME=$(whiptail --inputbox "\nPlease specify a username" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     PASSWORD=$(whiptail --passwordbox "\nPlease specify a password\nUse a strong UNIX type pass for security" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)
     PASSWORD2=$(whiptail --passwordbox "\nPlease specify password again" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)
   if [ $PASSWORD == $PASSWORD2 ]
    then
     ENCPASSWORD="$(openssl passwd -crypt -quiet $PASSWORD)"
     useradd -d /$HOME_PARTITION/$USERNAME -p $ENCPASSWORD -s /bin/bash $USERNAME 2> /dev/null
     whiptail --title "Web Creator" --msgbox "User $USERNAME successfully created" --ok-button "OK" 10 70
     createdomainsettings
    else
     whiptail --title "Web Creator" --msgbox "Passwords dont match" --ok-button "OK" 10 70
     createuserdomainhost
   fi
    else
     cancelOperation
   fi
}
createdomainsettings() {
     DOMAINNAMEADD=$(whiptail --inputbox "\nDomain name, you will access via the web\nIE: yourdomain.com" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)
     HOSTIPADD=$(whiptail --inputbox "\nEnter IP for domain (Main server IP)\nCurrent available IPs:\n$HOSTLISTIPS" 10 70 --title "Web Creator" 3>&1 1>&2 2>&3)

     MAX_SERVERS=$(whiptail --inputbox "\nMax # Spare FPM Servers\nDefault: 6" 10 70 6 --title "Web Creator" 3>&1 1>&2 2>&3)
     MAX_CHILDREN=$(whiptail --inputbox "\nFPM Max Children\nMust be higher then max servers\nDefault: 8" 10 70 8 --title "Web Creator" 3>&1 1>&2 2>&3)
     MIN_SERVERS=$(whiptail --inputbox "\nMin # Spare FPM Servers\nDefault: 2" 10 70 2 --title "Web Creator" 3>&1 1>&2 2>&3)
     FPM_SERVERS=$(whiptail --inputbox "\n# start FPM Servers\nMust not be less than min spare servers\nand not greater than max spare servers\nDefault: 4" 10 70 4 --title "Web Creator" 3>&1 1>&2 2>&3)
   if (whiptail --title "Web Creator" --yesno "Your Settings:\nUser: $USERNAME\nPath to Root:/$HOME_PARTITION/$USERNAME/$ROOT_DIRECTORY\nDomain name:$DOMAINNAMEADD\nIP Address:$HOSTIPADD" --yes-button "Create" --no-button "Cancel" 12 70) then
     echo "$USERNAME-$DOMAINNAMEADD" >> $CURDIR/tmp/.user
     createdomainhost
    else
   return
    fi
}
createdomainhost() {
{
       echo -e "XXX\n15\n\nStart Web Configuration...\nXXX"
     VHOSTCONFIG=$NGINX_SITES_AVAILABLE/$DOMAINNAMEADD.vhost
     cp $CURDIR/templates/remote.vhost.template $VHOSTCONFIG 2> /dev/null
     sleep 1
       echo -e "XXX\n20\n\nInstalling $DOMAINNAMEADD.vhost file...\nXXX"
     HOME_DIR=$USERNAME
     PUBLIC_HTML_DIR=/$ROOT_DIRECTORY
     $SED -i "s/@@HOSTNAME@@/$DOMAINNAMEADD/g" $VHOSTCONFIG
     $SED -i "s/@@IPADD@@/$HOSTIPADD/g" $VHOSTCONFIG
     $SED -i "s#@@PATH@@#\/$HOME_PARTITION\/"$USERNAME$PUBLIC_HTML_DIR"#g" $VHOSTCONFIG
     sleep 1.25
       echo -e "XXX\n30\n\nInstalling $VHOSTNAMEADD.vhost file...\nXXX"
     $SED -i "s/@@LOG_PATH@@/\/$HOME_PARTITION\/$USERNAME\/logs/g" $VHOSTCONFIG
     $SED -i "s/@@SSL_PATH@@/\/$HOME_PARTITION\/$USERNAME\/ssl/g" $VHOSTCONFIG
     $SED -i "s#@@SOCKET@@#/var/run/"$USERNAME"_fpm.sock#g" $VHOSTCONFIG
     sleep 1.25
       echo -e "XXX\n45\n\nCreate FPM $DOMAINNAMEADD.conf file...\nXXX"
     phpVersion
     FPMCONFIG="$PHP_FPMCONF_DIR/$DOMAINNAMEADD.conf"
     cp $CURDIR/templates/conf.template $FPMCONFIG 2> /dev/null
     sleep 1.25
       echo -e "XXX\n55\n\nPopulate $DOMAINNAMEADD.conf file...\nXXX"
     $SED -i "s/@@USER@@/$USERNAME/g" $FPMCONFIG
     $SED -i "s/@@GROUP@@/$USERNAME/g" $FPMCONFIG
     $SED -i "s/@@HOME_DIR@@/\/$HOME_PARTITION\/$USERNAME/g" $FPMCONFIG
     $SED -i "s/@@MAX_CHILDREN@@/$MAX_CHILDREN/g" $FPMCONFIG
     $SED -i "s/@@START_SERVERS@@/$FPM_SERVERS/g" $FPMCONFIG
     $SED -i "s/@@MIN_SERVERS@@/$MIN_SERVERS/g" $FPMCONFIG
     $SED -i "s/@@MAX_SERVERS@@/$MAX_SERVERS/g" $FPMCONFIG
     sleep 1.25
       echo -e "XXX\n65\n\nSet System Permissions...\nXXX"
     usermod -aG $USERNAME $WEB_SERVER_GROUP 2> /dev/null
     chmod 600 $VHOSTCONFIG
     ln -s $NGINX_SITES_AVAILABLE/$DOMAINNAMEADD.vhost $NGINX_SITES_ENABLED/
     sleep 1.25
       echo -e "XXX\n75\n\nInstalling Web Directories...\nXXX"
     mkdir -p /$HOME_PARTITION/$HOME_DIR
     chmod g+rx /$HOME_PARTITION/$HOME_DIR
     mkdir -p /$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR
     mkdir -p /$HOME_PARTITION/$HOME_DIR/logs
     mkdir -p /$HOME_PARTITION/$HOME_DIR/ssl
     mkdir -p /$HOME_PARTITION/$HOME_DIR/_sessions
     mkdir -p /$HOME_PARTITION/$HOME_DIR/backup
     sleep 1.25
       echo -e "XXX\n85\n\nInstalling index.php placeholder page...\nXXX"
     CONFIGPATH=/$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR/
     cp -rf $CURDIR/skel/* $CONFIGPATH 2> /dev/null
     sleep 1.25
       echo -e "XXX\n90\n\nSetting Web Directory Permissions...\nXXX"
     chmod 750 /$HOME_PARTITION/$HOME_DIR -R
     chmod 700 /$HOME_PARTITION/$HOME_DIR/_sessions
     chmod 770 /$HOME_PARTITION/$HOME_DIR/ssl
     chmod 770 /$HOME_PARTITION/$HOME_DIR/logs
     chmod 770 /$HOME_PARTITION/$HOME_DIR/backup
     chmod 750 /$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR
     chmod 644 /$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR/index.php
     chown $USERNAME:$USERNAME /$HOME_PARTITION/$HOME_DIR/ -R
     chown root:root /$HOME_PARTITION/$HOME_DIR/ssl -R
     chown root:root /$HOME_PARTITION/$HOME_DIR/backup -R
     sleep 1.25
       echo -e "XXX\n95\n\nSetup User and Web Complete...\nXXX"
     sleep 1.25
       echo -e "XXX\n96\n\nDomain $DOMAINNAMEADD created for $USERNAME with PHP support... \nXXX"
     sleep 8
       echo -e "XXX\n97\n\nRestart Services...\nXXX"
     $NGINX_INIT restart 2> /dev/null
     sleep .5
       echo -e "XXX\n98\n\nRestart Services...\nXXX"
     $PHP_INIT restart 2> /dev/null
     sleep .5
       echo -e "XXX\n99\n\nRestart Services...\nXXX"
     sleep .5
  } | whiptail --title "Web Creator" --gauge "\nCreating User and Web" 10 70 0
}
#*****************************
#
# User Remove Functions
#
#*****************************
removeuserroot() {
     USERNAMEDEL=$(whiptail --inputbox "\nSpecify a username to delete\nWARNING! this will remove home root as well\nMake a backup if you need to first" 10 70 --title "Remove User/Root" 3>&1 1>&2 2>&3)
     USERFILESDEL=$(whiptail --inputbox "\nSpecify users matching vhost to delete\nWARNING! this will remove Nginx vhost and FPM conf\nMake a backup if you need to first" 10 70 --title "Remove User/Root" 3>&1 1>&2 2>&3)
  if (whiptail --title "Remove User/Root" --yesno "You Entered: $USERNAMEDEL $USERFILESDEL.vhost $USERFILESDEL.conf\n\nLast chance to abort! Deletes all user content!" --yes-button "Continue" --no-button "Cancel" 10 70) then
     phpVersion
     FPMCONFIGDEL="$PHP_FPMCONF_DIR/$USERFILESDEL.conf"
    rm -rf $FPMCONFIGDEL
    rm -rf $NGINX_SITES_AVAILABLE/$USERFILESDEL.vhost
    rm -rf $NGINX_SITES_ENABLED/$USERFILESDEL.vhost
    $PHP_INIT restart &>/dev/null
    $NGINX_INIT restart &>/dev/null
    deluser --remove-home $USERNAMEDEL &>/dev/null
    rm -rf /$HOME_PARTITION/$USERNAMEDEL &>/dev/null
     whiptail --title "Remove User/Root" --msgbox "User $USERNAMEDEL successfully removed\n/\nDeleted $HOME_PARTITION/$USERNAMEDEL / $USERFILESDEL.vhost / $USERFILESDEL.conf" --ok-button "OK" 10 70
   else
     cancelOperation
    return
  fi
}

#!/bin/bash
#################################################################################
#                   *** ASAS 2.10 [Auto Server Admin Script] ***                #
#        @author: Gary Cornell for devCU Software Open Source Projects          #
#        @contact: gary@devcu.com                                               #
#        $OS: Debian Core (Tested on Ubuntu 18x -> 20x / Debian 9.x -> 10.x)     #
#        $MAIN: https://www.devcu.com                                           #
#        $SOURCE: https://github.com/GaalexxC/ASAS                              #
#        $REPO: https://www.devcu.net                                           #
#        +Created:   06/15/2016 Ported from nginxubuntu-php7                    #
#        &Updated:   12/25/2020 11:56 EDT                                       #
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
# vsFTPd System Functions
#
#****************************
vsftpdErrorLog() {
     echo "Error date: $DATE_TIME\n\n$vsftpdfail" >> $CURDIR/$LOGS/vsftpd-error-$CURDAY.log
}

vsftpdDebugLog() {
     echo "$DATE_TIME: $FUNC" >> $CURDIR/$LOGS/vsftpd-$CURDAY.log
}

vsftpdCheckInstall() {
   if ! type vsftpd > /dev/null 2>&1; then
     whiptail --title "vsFTPd Check-Install" --msgbox "vsFTPd not installed" --ok-button "OK" 10 70
     source $CURDIR/scripts/vsftpd_install.sh
   else
     ftpver=$(vsftpd -v 0>&1)
     whiptail --title "vsFTPd Check-Install" --msgbox "vsFTPd Installed!\n\n$ftpver" --ok-button "OK" 10 70
     source $CURDIR/scripts/vsftpd_install.sh
   fi
}

vsftpdConfFile() {
{
     echo -e "XXX\n20\n\nBackup vsftpd.conf file... \nXXX"
     sleep .95
     mv $VSFTPDCONFIG $VSFTPDCONFIG.bak
     echo -e "XXX\n40\n\nInstall new vsftpd.conf... \nXXX"
     sleep .95
     cp $CURDIR/config/vsftpd/vsftpd.conf $VSFTPDCONFIG 2>/dev/null
     echo -e "XXX\n60\n\nSet permissions on vsftpd.conf file... \nXXX"
     sleep .95
     chmod 644 $VSFTPDCONFIG
     echo -e "XXX\n80\n\nSet ownership on vsftpd.conf file... \nXXX"
     sleep .95
     chown root:root $VSFTPDCONFIG
     echo -e "XXX\n100\n\nDefault Configuration Complete... Done.\nXXX"
     sleep .95
  } | whiptail --title "vsFTPd Installer" --gauge "\nConfiguring vsFTPd" 10 70 0
}
vsftpdRestart() {
{
     $VSFTPD_INIT restart 2> /dev/null
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     echo -e "XXX\n50\n\nStopping vsFTPd Service... Done.\nXXX"
     sleep 1
     echo -e "XXX\n100\n\nSuccessfully restarted vsFTPd... Done.\nXXX"
     FUNC="Successfully restarted vsFTPd"
     vsftpdDebugLog
     sleep 1
   else
     vsftpdfail=$(systemctl status vsftpd.service 2>&1)
     vsftpdErrorLog
     FUNC="vsFTPd failed, check $CURDIR/$LOGS/vsftpd-error-$CURDAY.log"
     vsftpdDebugLog
     echo -e "XXX\n99\n\nvsFTPd failed, check $CURDIR/$LOGS/vsftpd-error-$CURDAY.log...\nXXX"
     sleep 5
     exit 1
   fi
     sleep .80
  } | whiptail --title "Restart vsFTPd" --gauge "\nRestarting the vsFTPd service" 10 70 0
}
#*****************************
#
# vsFTPd Network Functions
#
#*****************************
vport() {
   if (whiptail --title "vsFTPd Configuration" --yesno "You Entered: $FTPPORT" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/listen_port=.*/listen_port=$FTPPORT/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Port modified to $FTPPORT"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Port $FTPPORT successfully updated" --ok-button "OK" 10 70
   else
     vsftpdport
   fi
}
vsftpdport() {
     FTPPORT=$(whiptail --inputbox "\nEnter Port - Something high, Default:23452" 10 70 --title "vsFTPd Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     vport
   else
     cancelOperation
   fi
}
#*****************************
#
# vsFTPd IP Functions
#
#*****************************
vip6add() {
   if (whiptail --title "vsFTPd Configuration" --yesno "You Entered: $FTPIP6ADD" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/listen_address6=.*/listen_address6=$FTPIP6ADD/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="IPv6 Address modified to $FTPIP6ADD"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "IPv6 Address $FTPIP6ADD successfully updated" --ok-button "OK" 10 70
   else
     vsftpdip6add
   fi
}
vsftpdip6add() {
     FTPIP6ADD=$(whiptail --inputbox "\nEnter IPv6 Address (optional) leave Blank for none\nHas no effect if IPv6 disabled" 10 70 --title "vsFTPd Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     vip6add
   else
     cancelOperation
   fi
}
vip4add() {
   if (whiptail --title "vsFTPd Configuration" --yesno "You Entered: $FTPIP4ADD" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/listen_address=.*/listen_address=$FTPIP4ADD/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="IPv4 Address modified to $FTPIP4ADD"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "IPv4 Address $FTPIP4ADD successfully updated" --ok-button "OK" 10 70
   else
     vsftpdip4add
   fi
}
vsftpdip4add() {
     FTPIP4ADD=$(whiptail --inputbox "\nEnter IPv4 Address (optional) leave Blank for none\nHas no effect if IPv6 enabled" 10 70 --title "vsFTPd Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     vip4add
   else
     cancelOperation
   fi
}
vsftpdip6enable() {
   if (whiptail --title "vsFTPd Configuration" --yesno "Do you want to enable/disable IPv6 listening?\nvsFTPd will listen on both IPv4 and IPv6 if enabled\nand only IPv4 (default) if disabled" --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/listen=.*/listen=NO/g" $VSFTPDCONFIG
     $SED -i "s/listen_ipv6=.*/listen_ipv6=YES/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="IPv6 listening has been enabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "IPv6 listening has been enabled" --ok-button "OK" 10 70
   else
     $SED -i "s/listen=.*/listen=YES/g" $VSFTPDCONFIG
     $SED -i "s/listen_ipv6=.*/listen_ipv6=NO/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="IPv6 listening has been disabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "IPv6 listening has been disabled" --ok-button "OK" 10 70
   fi
}
#*****************************
#
# vsFTPd Security Functions
#
#*****************************
vsftpdhidedot() {
   if (whiptail --title "vsFTPd Configuration" --yesno "Do you want to show/hide dot(.) files from users?\nDefault is to hide these files" --yes-button "Show" --no-button "Hide" 10 70) then
     $SED -i "s/hide_file=.*/#hide_file={.*}/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="dot(.) files set to visible"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "dot(.) files are now visible" --ok-button "OK" 10 70
   else
     $SED -i "s/#hide_file=.*/hide_file={.*}/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="dot(.) files set to hidden"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "dot(.) files are now hidden" --ok-button "OK" 10 70
   fi
}
vsftpdanonymous() {
   if (whiptail --title "vsFTPd Configuration" --yesno "Do you want to enable/disable anonymous FTP logins?\nDefault is disabled (Highly Recommended)" --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/anonymous_enable=.*/anonymous_enable=YES/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Anonymous FTP logins enabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Anonymous FTP logins enabled (Not Recommended!)" --ok-button "OK" 10 70
   else
     $SED -i "s/anonymous_enable=.*/anonymous_enable=NO/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Anonymous FTP logins disabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Anonymous FTP logins disabled" --ok-button "OK" 10 70
   fi
}
vsftpdbackupconf() {
{
     echo -e "XXX\n50\n\nBacking up vsFTPd configuration... \nXXX"
     tar cvpfz /vsftpdconf_backup_$CURDAY.tar.gz $VSFTPDCONFIG 2> /dev/null
   if [ ! -d  $CURDIR/backups ]; then
     mkdir $CURDIR/backups
   fi
     mv /vsftpdconf_backup_$CURDAY.tar.gz $CURDIR/backups
     sleep 1
     FUNC="vsFTPd configuration backup completed"
     vsftpdDebugLog
     echo -e "XXX\n100\n\nBackup to $CURDIR/backups... Done.\nXXX"
     sleep 1.5
  } | whiptail --title "vsFTPd Backup" --gauge "\nBacking up vsFTPd configuration" 10 70 0
}
#*****************************
#
# vsFTPd SSL Functions
#
#*****************************
vsftpdsslenable() {
   if (whiptail --title "vsFTPd Configuration" --yesno "Do you want to enable/disable SSL?\nDefault is disabled"  --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/ssl_enable=.*/ssl_enable=YES/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="SSL has been enabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "SSL is now enabled\nPlease add cert/key paths in configuration menu" --ok-button "OK" 10 70
   else
     $SED -i "s/ssl_enable=.*/ssl_enable=NO/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="SSL has been disabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "SSL is now disabled" --ok-button "OK" 10 70
   fi
}
vsslcert() {
   if (whiptail --title "vsFTPd Configuration" --yesno "You Entered:\n$SSLCERT" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s@rsa_cert_file=.*@rsa_cert_file=$SSLCERT@g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="SSL cert path modified to $SSLCERT"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Path $SSLCERT updated" --ok-button "OK" 10 70
   else
     vsftpdsslcert
   fi
}
vsftpdsslcert() {
     SSLCERT=$(whiptail --inputbox "\nEnter full path to SSL cert\nIE: /etc/ssl/certs/vsftpd.pem" 10 70 --title "vsFTPd Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     vsslcert
   else
     cancelOperation
   fi
}
vsslkey() {
   if (whiptail --title "vsFTPd Configuration" --yesno "You Entered:\n$SSLKEY" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s@rsa_private_key_file=.*@rsa_private_key_file=$SSLKEY@g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="SSL key path modified to $SSLKEY"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Path $SSLKEY updated" --ok-button "OK" 10 70
   else
     vsftpdsslkey
   fi
}
vsftpdsslkey() {
     SSLKEY=$(whiptail --inputbox "\nEnter full path to SSL key\nIE: /etc/ssl/private/vsftpd.key" 10 70 --title "vsFTPd Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     vsslkey
   else
     cancelOperation
   fi
}
#*****************************
#
# vsFTPd USER Functions
#
#*****************************
vsftpdwriteenable() {
   if (whiptail --title "vsFTPd Configuration" --yesno "Do you want to enable/disable Write?\nDefault is enabled"  --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/write_enable=.*/write_enable=YES/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Write set to enabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Write is now enabled" --ok-button "OK" 10 70
   else
     $SED -i "s/write_enable=.*/write_enable=NO/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Write set to disabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Write is now disabled" --ok-button "OK" 10 70
   fi
}
vsftpdwriteablechroot() {
   if (whiptail --title "vsFTPd Configuration" --yesno "Do you want to enable/disable Writeable chroot?\nDefault is enabled"  --yes-button "Enable" --no-button "Disable" 10 70) then
     $SED -i "s/allow_writeable_chroot=.*/allow_writeable_chroot=YES/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Write xchroot set to enabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Write chroot is now enabled" --ok-button "OK" 10 70
   else
     $SED -i "s/allow_writeable_chroot=.*/allow_writeable_chroot=NO/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Write set to disabled"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Write chroot is now disabled" --ok-button "OK" 10 70
   fi
}

vmaxclients() {
   if (whiptail --title "vsFTPd Configuration" --yesno "You Entered: $CLIENTMAX" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/max_clients=.*/max_clients=$CLIENTMAX/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Max clients modified to $CLIENTMAX"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Max clients modified to $CLIENTMAX" --ok-button "OK" 10 70
   else
     vsftpdmaxclients
   fi
}
vsftpdmaxclients() {
     CLIENTMAX=$(whiptail --inputbox "\nvsFTPd Max Clients Default:50" 10 70 --title "vsFTPd Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     vmaxclients
   else
     cancelOperation
   fi
}
vmaxperip() {
   if (whiptail --title "vsFTPd Configuration" --yesno "You Entered: $MAXPERIP" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/max_per_ip=.*/max_per_ip=$MAXPERIP/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Max per IP modified to $MAXPERIP"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Max per IP modified to $MAXPERIP" --ok-button "OK" 10 70
   else
     vsftpmaxperip
   fi
}
vsftpmaxperip() {
     MAXPERIP=$(whiptail --inputbox "\nvsFTPd Max per IP Default:25" 10 70 --title "vsFTPd Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     vmaxperip
   else
     cancelOperation
   fi
}
vmaxlogins() {
   if (whiptail --title "vsFTPd Configuration" --yesno "You Entered: $MAXLOGINS" --yes-button "Update" --no-button "Change" 10 70) then
     $SED -i "s/max_login_fails=.*/max_login_fails=$MAXLOGINS/g" $VSFTPDCONFIG
     vsftpdRestart
     FUNC="Max failed logins modified to $MAXLOGINS"
     vsftpdDebugLog
     whiptail --title "vsFTPd Configuration" --msgbox "Max failed logins modified to $MAXLOGINS" --ok-button "OK" 10 70
   else
     vsftpdmaxloginfails
   fi
}
vsftpdmaxloginfails() {
     MAXLOGINS=$(whiptail --inputbox "\nvsFTPd Max failed logins Default:5" 10 70 --title "vsFTPd Configuration" 3>&1 1>&2 2>&3)
     exitstatus=$?
   if [ $exitstatus = 0 ]; then
     vmaxlogins
   else
     cancelOperation
   fi
}

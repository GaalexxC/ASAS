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
#*****************************
#
# vsFTPd System Functions
#
#****************************
vsftpdConfFile() {
{
    echo -e "XXX\n20\n\nBackup vsftpd.conf file... \nXXX"
    sleep .95
    mv /etc/vsftpd.conf /etc/vsftpd.conf.bak
    echo -e "XXX\n40\n\nInstall new vsftpd.conf... \nXXX"
    sleep .95
    local CONFIG=/etc/vsftpd.conf
    cp $CURDIR/config/vsftpd/vsftpd.conf $CONFIG 2>/dev/null
    echo -e "XXX\n60\n\nSet permissions on vsftpd.conf file... \nXXX"
    sleep .95
    chmod 644 /etc/vsftpd.conf
    echo -e "XXX\n80\n\nSet ownership on vsftpd.conf file... \nXXX"
    sleep .95
    chown root:root /etc/vsftpd.conf
    echo -e "XXX\n100\n\nDefault Configuration Complete... Done.\nXXX"
    sleep .95
  } | whiptail --title "vsFTPd Installer" --gauge "\nConfiguring vsFTPd" 10 70 0
}
vsftpdRestart() {
{
    $VSFTPD_INIT 2> /dev/null
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
    echo -e "XXX\n50\n\nStopping vsFTPd Service... Done.\nXXX"
    sleep 1
    echo -e "XXX\n100\n\nSuccessfully restarted vsFTPd... Done.\nXXX"
    sleep 1
    else
    echo -e "XXX\n0\n\nvsFTPd failed, check /var/log/vsftpd.log\nScript exiting in 3 seconds...\nXXX"
    sleep 3
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
    if (whiptail --title "Port Config" --yesno "You Entered: $FTPPORT" --yes-button "Update" --no-button "Change" 10 70) then
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/listen_port=.*/listen_port=$FTPPORT/g" $CONFIG
     vsftpdRestart
     whiptail --title "Port Added" --msgbox "Port $FTPPORT successfully updated" --ok-button "OK" 10 70
    else
     vsftpdport
    fi
}
vsftpdport() {
FTPPORT=$(whiptail --inputbox "\nEnter Port - Something high like 23452" 10 70 23452 --title "Configure vsFTPd" 3>&1 1>&2 2>&3)
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
    if (whiptail --title "IPv6 Address Config" --yesno "You Entered: $FTPIP6ADD" --yes-button "Update" --no-button "Change" 10 70) then
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/listen_address6=.*/listen_address6=$FTPIP6ADD/g" $CONFIG
     vsftpdRestart
     whiptail --title "IPv6 Address" --msgbox "IP Address $FTPIP6ADD successfully updated" --ok-button "OK" 10 70
    else
     vsftpdip6add
    fi
}
vsftpdip6add() {
FTPIP6ADD=$(whiptail --inputbox "\nEnter IPv6 Address (optional) leave Blank for none\nHas no effect if IPv6 disabled" 10 70 --title "IPv6 Address" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
vip6add
else
cancelOperation
fi
}
vip4add() {
    if (whiptail --title "IPv4 Address Config" --yesno "You Entered: $FTPIP4ADD" --yes-button "Update" --no-button "Change" 10 70) then
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/listen_address=.*/listen_address=$FTPIP4ADD/g" $CONFIG
     vsftpdRestart
     whiptail --title "IPv4 Address" --msgbox "IP Address $FTPIP4ADD successfully updated" --ok-button "OK" 10 70
    else
     vsftpdip4add
    fi
}
vsftpdip4add() {
FTPIP4ADD=$(whiptail --inputbox "\nEnter IPv4 Address (optional) leave Blank for none\nHas no effect if IPv6 enabled" 10 70 --title "IPv4 Address" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
vip4add
else
cancelOperation
fi
}
vsftpdip6enable() {
    if (whiptail --title "IPv6 Config" --yesno "Do you want to enable/disable IPv6 listening?\nvsFTPd will listen on both IPv4 and IPv6 if enabled\nand only IPv4 (default) if disabled" --yes-button "Enable" --no-button "Disable" 10 70) then
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/listen=.*/listen=NO/g" $CONFIG
     $SED -i "s/listen_ipv6=.*/listen_ipv6=YES/g" $CONFIG
     vsftpdRestart
     whiptail --title "IPv6 Config" --msgbox "IPv6 has been enabled" --ok-button "OK" 10 70
    else
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/listen=.*/listen=YES/g" $CONFIG
     $SED -i "s/listen_ipv6=.*/listen_ipv6=NO/g" $CONFIG
     vsftpdRestart
     whiptail --title "IPv6 Config" --msgbox "IPv6 has been disabled" --ok-button "OK" 10 70
    fi
}
#*****************************
#
# vsFTPd Security Functions
#
#*****************************
vsftpdhidedot() {
    if (whiptail --title "Hide(.) Config" --yesno "Do you want to show/hide dot(.) files from users?\nDefault is to hide these files" --yes-button "Show" --no-button "Hide" 10 70) then
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/hide_file=.*/#hide_file={.*}/g" $CONFIG
     vsftpdRestart
     whiptail --title "Hide(.) Config" --msgbox "dot(.) files are visible" --ok-button "OK" 10 70
    else
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/#hide_file=.*/hide_file={.*}/g" $CONFIG
     vsftpdRestart
     whiptail --title "Hide(.) Config" --msgbox "dot(.) files are hidden" --ok-button "OK" 10 70
    fi
}
vsftpdanonymous() {
    if (whiptail --title "Anonymous Config" --yesno "Do you want to enable/disable anonymous FTP logins?\nDefault is disabled (Highly Recommended)" --yes-button "Enable" --no-button "Disable" 10 70) then
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/anonymous_enable=.*/anonymous_enable=YES/g" $CONFIG
     vsftpdRestart
     whiptail --title "Anonymous Config" --msgbox "Anonymous logions enabled (Not Recommended!)" --ok-button "OK" 10 70
    else
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/anonymous_enable=.*/anonymous_enable=NO/g" $CONFIG
     vsftpdRestart
     whiptail --title "Anonymous Config" --msgbox "Anonymous logins disabled" --ok-button "OK" 10 70
    fi
}
#*****************************
#
# vsFTPd SSL Functions
#
#*****************************
vsftpdsslenable() {
    if (whiptail --title "SSL Configuration" --yesno "Do you want to enable/disable SSL?\nDefault is disabled"  --yes-button "Enable" --no-button "Disable" 10 70) then
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/ssl_enable=.*/ssl_enable=YES/g" $CONFIG
     vsftpdRestart
     whiptail --title "SSL Configuration" --msgbox "SSL is enabled\nPlease add cert/key paths in configuration menu" --ok-button "OK" 10 70
    else
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s/ssl_enable=.*/ssl_enable=NO/g" $CONFIG
     vsftpdRestart
     whiptail --title "SSL Configuration" --msgbox "SSL is disabled" --ok-button "OK" 10 70
    fi
}
vsslcert() {
    if (whiptail --title "SSL Configuration" --yesno "You Entered:\n$SSLCERT" --yes-button "Update" --no-button "Change" 10 70) then
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s@rsa_cert_file=.*@rsa_cert_file=$SSLCERT@g" $CONFIG
     vsftpdRestart
     whiptail --title "SSL Configuration" --msgbox "Path $SSLCERT updated" --ok-button "OK" 10 70
    else
     vsftpdsslcert
    fi
}
vsftpdsslcert() {
SSLCERT=$(whiptail --inputbox "\nEnter full path to SSL cert\nIE: /etc/ssl/certs/vsftpd.pem" 10 70 --title "SSL Configuration" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
vsslcert
else
cancelOperation
fi
}
vsslkey() {
    if (whiptail --title "SSL Configuration" --yesno "You Entered:\n$SSLKEY" --yes-button "Update" --no-button "Change" 10 70) then
     local CONFIG=/etc/vsftpd.conf
     $SED -i "s@rsa_private_key_file=.*@rsa_private_key_file=$SSLKEY@g" $CONFIG
     vsftpdRestart
     whiptail --title "SSL Configuration" --msgbox "Path $SSLKEY updated" --ok-button "OK" 10 70
    else
     vsftpdsslkey
    fi
}
vsftpdsslkey() {
SSLKEY=$(whiptail --inputbox "\nEnter full path to SSL key\nIE: /etc/ssl/private/vsftpd.key" 10 70 --title "SSL Configuration" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
vsslkey
else
cancelOperation
fi
}

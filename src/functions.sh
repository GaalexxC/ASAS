#!/bin/bash
# ASAS 2.10
# @author: GCornell for devCU Software
# @contact: gacornell@devcu.com
# Compatibility: Debian Core Systems (Tested on Ubuntu 14x-16x-17x & Debian 8/9)
# MAIN: https://www.devcu.com
# CODE: https://github.com/GaalexxC/ASAS
# REPO: https://www.devcu.net
# License: GNU General Public License v3.0
# Created:   06/15/2016
# Updated:   10/01/2017

#*****************************
#
# Global Functions
#
#*****************************
## NEWT Color palette for ASAS whiptail GUI ##
readarray -t newtcolor < templates/palette
NEWT_COLORS="${newtcolor[@]}"

validateRoot() {
    if [ "$(id -u)" != "0" ]; then
       whiptail --title "System Check" --msgbox "\nYou need root privileges to run this script.\nPress [Enter] to exit\nBye Bye" --ok-button "Exit" 10 70
       exit 1
    else
       whiptail --title "System Check" --msgbox "Root User Confirmed\nPress [Enter] to continue" --ok-button "Continue" 10 70
    fi
}

completeOperation() {
whiptail --title "Operation Complete" --msgbox "Operation Complete\nPress [Enter] for main menu" --ok-button "OK" 10 70
return
}

cancelOperation() {
whiptail --title "Operation Cancelled" --msgbox "Operation Cancelled\nPress [Enter] for main menu" --ok-button "OK" 10 70
return
}

rebootRequired() {
  if [ -f /var/run/reboot-required ]; then
    whiptail --title "Reboot Required" --msgbox "Your Kernel was modified a reboot is required\nPress [Enter] to reboot" --ok-button "Reboot" 10 70
    reboot
  fi
}

# Work In Progress
phpDependencies() {
apt install -y language-pack-en-base &&
export LC_ALL=en_US.UTF-8 &&
export LANG=en_US.UTF-8 &&
apt install -y software-properties-common &&
add-apt-repository ppa:ondrej/php &&
apt update
}

#LicenseView() {
#}

lowercase() {
        echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

clean_string() {
        clean=$1
        clean=${clean//\"/}
        echo $clean
}

#*****************************
#
# System Detect Functions
#
#*****************************
systemDetect()
{
        OS=`uname`
        KERNEL=`uname -r`
        ARCH=`uname -m`
        declare -a osdist=( Debian Ubuntu )
        declare -a osrev=( 8 9 14.04 15.10 16.04 16.10 17.04 17.10 )

        if [ "${OS}" = "Linux" ]; then
                if [ -f /etc/debian_version ]; then
                        BASEDON='Debian'
                        DISTRIBUTION=`cat /etc/*-release | grep '^NAME' | awk -F=  '{ print $2 }'`
                        VERSION=`cat /etc/*-release | grep '^VERSION_ID' | awk -F=  '{ print $2 }'`
                        CODENAME=`cat /etc/*-release | grep '^VERSION' | awk -F=  '{ print $2 }'`
                        RELEASE=`cat /etc/*-release | grep '^PRETTY_NAME' | awk -F=  '{ print $2 }'`
                        fi
                fi
        OS=`clean_string "$OS"`
        DISTRIBUTION=`clean_string $DISTRIBUTION`
        BASEDON=`clean_string "$BASEDON"`
        CODENAME=`clean_string "$CODENAME"`
        RELEASE=`clean_string "$RELEASE"`
        VERSION=`clean_string $VERSION`
        KERNEL=`clean_string "$KERNEL"`
        ARCH=`clean_string "$ARCH"`

        readonly OS
        readonly DISTRIBUTION
        readonly BASEDON
        readonly CODENAME
        readonly VERSION
        readonly RELEASE
        readonly KERNEL
        readonly ARCH
        if [[ "${osdist[*]}" =~ "$DISTRIBUTION"  && "${osrev[*]}" =~ "$VERSION" ]] ; then
                whiptail --title "System Detect" --msgbox "OS: $OS\nDistribution: $DISTRIBUTION\nCodename: $CODENAME\nVersion: $VERSION\nRevision: $RELEASE\nDistroBasedOn: $BASEDON\nKernel: $KERNEL\nArchetecture: $ARCH\n\nGreat $DISTRIBUTION - $VERSION is supported" --ok-button "Continue" 16 70 6
        else
                whiptail --title "System Detect" --msgbox "OS: $OS\nDistribution: $DISTRIBUTION\nCodename: $CODENAME\nVersion: $VERSION\nRevision: $RELEASE\nDistroBasedOn: $BASEDON\nKernel: $KERNEL\nArchetecture: $ARCH\n\nSorry $DISTRIBUTION - $VERSION is not supported" --ok-button "Exit" 16 70 6
        exit 1
        fi
}

#*****************************
#
# System Functions
#
#*****************************
systemInstaller() {
pkg=0
#dmesg -D
#setterm -term linux -msg off
#setterm -term linux -blank 0
$(package) -y 2> /dev/null | \
    tr '[:upper:]' '[:lower:]' | \
while read x; do
    case $x in
        *upgraded*newly*)
            u=${x%% *}
            n=${x%% newly installed*}
            n=${n##*upgraded, }
            r=${x%% to remove*}
            r=${r##*installed, }
            pkgs=$((u*2+n*2+r))
            pkg=0
        ;;
        unpacking*|setting\ up*|updating*|installing*|found*|removing*\ ...)
            if [ $pkgs -gt 0 ]; then
                pkg=$((pkg+1))
                x=${x%% (*}
                x=${x%% ...}
                x=$(echo ${x:0:1} | tr '[:lower:]' '[:upper:]')${x:1}
                sleep .25
                printf "XXX\n$((pkg*100/pkgs))\n\n${x} ...\nXXX\n$((pkg*100/pkgs))\n"
            fi
        ;;
    esac
done | whiptail --title "ASAS System Installer"  --gauge "\nChecking Packages..." 9 78 0
#dmesg -E
#setterm -term linux -msg on
#invoke-rc.d kbd restart # Restore screen blanking to default setting
}

systemInstall() {
    UPGRADECHECK=$(/usr/lib/update-notifier/apt-check 2>&1)
    security=$(echo "${UPGRADECHECK}" | cut -d ";" -f 2)
    nonsecurity=$(echo "${UPGRADECHECK}" | cut -d ";" -f 1)
    totalupgrade=$((security + nonsecurity))
  if [ "$UPGRADECHECK" != "0;0" ]; then
    if (whiptail --title "System Check" --yesno "$totalupgrade Updates are available\n$security are security updates\nWould you like to update now (Recommended)" --yes-button "Update" --no-button "Skip" 10 70) then
      package() {
         printf "apt upgrade"
       }
     systemInstaller
     rebootRequired
     completeOperation
  else
        return
    fi
  else
     whiptail --title "System Check" --msgbox "System is up to date\n\nPress [Enter] for main menu..." --ok-button "OK" 10 70
        return
  fi
}

nginxRepoAdd() {
{
    echo "$debrepo" >> $APT_SOURCES
    echo "$debsrcrepo" >> $APT_SOURCES
    sleep 2
    echo -e "XXX\n25\nAdding Nginx stable repo... \nXXX"
    sleep 1
    echo -e "XXX\n50\nAdding Nginx stable repo... Done.\nXXX"
    sleep 1
    echo -e "XXX\n75\nFetch Nginx signing key... \nXXX"
    curl -O https://nginx.org/keys/nginx_signing.key 2> /dev/null &&
    apt-key add ./nginx_signing.key 2> /dev/null &
    sleep 1
    echo -e "XXX\n100\nFetch Nginx signing key... Done.\nXXX"
    sleep 1
  } | whiptail --title "Nginx Stable Repo" --gauge "Preparing to install Nginx Stable" 9 78 0
}

#*****************************
#
# Check Install
#
#*****************************
whiptailInstallCheck() {
   if ! type whiptail > /dev/null 2>&1; then
      echo -e "\n\nDependency Check...${RED}Whiptail not installed${NOCOL}"
      sleep 1.5
      echo -e "\nInstalling Whiptail - required by this script"
      apt install whiptail -y
      echo -e "\n${GREEN}Whiptail successfully installed${NOCOL}\n\n"
      sleep 2
   else
       whipver=$(whiptail -v 2>&1)
       echo -e "\n\nDependency Check..."
       sleep 1
       echo -e "\n${GREEN}Great! $whipver is installed${NOCOL}\n\n"
       sleep 1.5
   fi
}

emailCheckInstall() {
   if ! type postfix > /dev/null 2>&1; then
     if (whiptail --title "Postfix Check" --yesno "Postfix not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
        source scripts/mail_server.sh
    else
         return
     fi
   else
        postver=$(postfix -v)
        whiptail --title "Postfix Check" --msgbox "$postver is already installed\n\nPress [Enter] to return to main menu" --ok-button "OK" 10 70
        return
   fi
}

bindCheckInstall() {
   if ! type named > /dev/null 2>&1; then
     if (whiptail --title "Bind9 Check" --yesno "Bind9 not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
        source scripts/bind9_install.sh
    else
         return
     fi
   else
        bindver=$(named -v)
        whiptail --title "Bind9 Check" --msgbox "$bindver is already installed\nPress [Enter] to return to main menu" --ok-button "OK" 10 70
        return
   fi
}

mysqlCheckInstall() {
   if ! type mysql > /dev/null 2>&1; then
     if (whiptail --title "MySQL Check" --yesno "MySQL not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
        source scripts/mysql_install.sh
    else
	 return
     fi
    else
        dbver=$(mysql -V 2>&1)
        whiptail --title "MySQL Check" --msgbox "$dbver is currently installed\n\nPress [Enter] to return to main menu" --ok-button "OK" 10 70
        return
   fi
}

nginxCheckInstall() {
   if ! type nginx > /dev/null 2>&1; then
        whiptail --title "Nginx Check-Install" --msgbox "Nginx not installed\nPress [Enter] to continue" --ok-button "OK" 10 70
        source scripts/nginx_install.sh
   else
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver is currently installed\nPress [Enter] to continue" --ok-button "OK" 10 70
        source scripts/nginx_install.sh
   fi
}

phpCheckInstall() {
   if ! type php > /dev/null 2>&1; then
        whiptail --title "PHP Check-Install" --msgbox "PHP not installed\nPress [Enter] to continue" --ok-button "OK" 10 70
        source scripts/php_install.sh
   else
        phpver=$(php -r \@phpinfo\(\)\; | grep 'PHP Version' -m 1)
        whiptail --title "PHP Check-Install" --msgbox "$phpver is currently installed\nPress [Enter] to continue" --ok-button "OK" 10 70
        source scripts/php_install.sh
   fi
}

vsftpdCheckInstall() {
   if ! type vsftpd > /dev/null 2>&1; then
     if (whiptail --title "vsFTPd Check" --yesno "vsFTPd not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
         source scripts/ftp_install.sh
    else
         return
     fi
   else
        ftpver=$(vsftpd -v 0>&1)
        whiptail --title "vsFTPd Check" --msgbox "$ftpver is currently installed\n\nPress [Enter] to return to main menu" --ok-button "OK" 10 70
        return
   fi
}

#systemCheckInstall() {
#}

#securityCheckInstall() {
#}

#clientCheckInstall() {
#}

#*****************************
#
# Check Compile
#
#*****************************
nginxCheckCompile() {
   if ! type nginx > /dev/null 2>&1; then
     if (whiptail --title "Nginx Check" --yesno "Nginx not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
        source scripts/nginx_compile.sh &&
        source scripts/nginx_configure.sh | grep -v 'omitting directory'
    else
         return
     fi
   else
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver is currently installed\nPress [Enter] to return to main menu" --ok-button "OK" 10 70
        return
   fi
}

#*****************************
#
# Security Functions
#
#*****************************
secureCheckModify() {
{
        i="0"
            $(secureCommand) 2> /dev/null &
            sleep 2
            while (true)
            do
            proc=$(ps aux | grep -v grep | grep -e "$(secureApp)")
            if [[ "$proc" == "" ]] && [[ "$i" -eq "0" ]];
            then
                break;
            elif [[ "$proc" == "" ]] && [[ "$i" -gt "0" ]];
            then
                sleep .5
                echo 95
                sleep 1.5
                echo 99
                sleep 1.5
                echo 100
                sleep 2
                break;
            elif [[ "60" -eq "$i" ]]
            then
                i="40"
            fi
            sleep 1
            i=$(expr $i + 1)
            z=$(echo "$output")
            printf "XXX\n$i\n\nGenerating dhparam.pem file... ${z}\nXXX\n$i\n"
        done
  } | whiptail --title "Security Check-Modify"  --gauge "\nGenerating DH parameters, 2048 bit long safe prime, generator 2\nThis is going to take a long time" 9 78 0
}

#*****************************
#
# Update Source List Functions
#
#*****************************
updateSources() {
         i=0
         apt update 2> /dev/null | \
         tr '[:upper:]' '[:lower:]' | \
            while read x; do
            case $x in
        *inrelease*)
            z=4
            i=0
        ;;
            fetched*|building*|reading*|all*\ ...)
            if [ $z -gt 0 ]; then
                i=$((i+1))
                x=${x%% (*}
                x=${x%% ...}
                x=$(echo ${x:0:1} | tr '[:lower:]' '[:upper:]')${x:1}
                sleep .50
                printf "XXX\n$((i*100/z))\n\n${x}\nXXX\n$((i*100/z))\n"
           fi
        ;;
    esac
done | whiptail --title "Update Check"  --gauge "\nChecking for system updates" 9 78 0
}

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
            z=20
            i=0
        ;;
           +*\ ...)
            proc=$(ps aux | grep -v grep | grep -e "$(secureApp)")
            if [[ "$proc" == "" ]] && [[ $z -gt 0 ]]; then
                i=$((i+1))
                x=${x% (*}
                x=${x% ...}
                x=$(echo ${x:1})
                sleep .50
                printf "XXX\n$((i*100/z))\n\n${x}\nXXX\n$((i*100/z))\n"
           fi
        ;;
    esac
done | whiptail --title "Security Check-Modify"  --gauge "\nGenerating DH parameters, 2048 bit long safe prime, generator 2\nThis is going to take a long time" 9 78 0
}

############
# File End #
############

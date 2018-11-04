#!/bin/bash
#################################################################################
#                   *** ASAS 2.10 [Auto Server Admin Script] ***                #
#        @author: Gary Cornell for devCU Software Open Source Projects              #
#        @contact: gary@devcu.com                                          #
#        $OS: Debian Core (Tested on Ubuntu 16x -> 18x / Debian 8.x -> 9.x)     #
#        $MAIN: https://www.devcu.com                                           #
#        $SOURCE: https://github.com/GaalexxC/ASAS                              #
#        $REPO: https://www.devcu.net                                           #
#        +Created:   06/15/2016 Ported from nginxubuntu-php7                    #
#        &Updated:   05/04/2018 05:18 EDT                                       #
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
# Global Functions
#
#*****************************
## NEWT Color palette for ASAS whiptail GUI ##
     readarray -t newtcolor < bin/palette
     NEWT_COLORS="${newtcolor[@]}"

   if [ ! -d $CURDIR/tmp ]
    then
     mkdir $CURDIR/tmp
   fi

   if [ ! -d $CURDIR/$LOGS/ ]
    then
     mkdir -p $CURDIR/$LOGS/
   fi

asasMainMenu() {
clear
   while [ 1 ]
    do
MAINNU=$(
whiptail --title "ASAS 2.10" --menu "\nSelect operation from the menu" 20 78 10 \
        "1)" "Nginx Installer (Stable/Mainline/Compiled)"   \
        "2)" "PHP Installer (PHP 7.x)"  \
        "3)" "MySQL Installer (Percona-MariaDB-Oracle)" \
        "4)" "Bind9 DNS Installer (Configure-Secure)" \
        "5)" "vsFTPd Installer (Configure-Secure)" \
        "6)" "Mail Server Installer (Postfix-Dovecot)" \
        "7)" "Web User & Domain Setup" \
        "8)" "Security Tools" \
        "9)" "System Tools" \
       "10)" "Exit"  3>&2 2>&1 1>&3
)

case $MAINNU in
        "1)")
                nginxCheckInstall
        ;;

        "2)")
                phpCheckInstall
        ;;

        "3)")
                mysqlCheckInstall
        ;;

        "4)")
                bind9CheckInstall
        ;;

        "5)")
                vsftpdCheckInstall
        ;;

        "6)")
                mailCheckInstall
        ;;

        "7)")
                source scripts/user_domain.sh
        ;;

        "8)")
                source scripts/security_tools.sh
        ;;

        "9)")
                source scripts/system_tools.sh
        ;;

        "10)")
               exit 1

        ;;
   esac

 done
}
checkRoot() {
   if [ "$(id -u)" != "0" ]; then
     whiptail --title "System Check" --msgbox "\nYou need to be root to run this script.\n\nPress [Enter] to exit\nBye Bye" --ok-button "Exit" 10 70
    exit 1
   else
     whiptail --title "System Check" --msgbox "Root User Confirmed\n\nPress [Enter] to continue" --ok-button "Continue" 10 70
   fi
}
completeOperation() {
     whiptail --title "Operation Complete" --msgbox "Operation Complete\n$(completemessage)" --ok-button "OK" 10 70
}
cancelOperation() {
     whiptail --title "Operation Cancelled" --msgbox "Operation Cancelled" --ok-button "OK" 10 70
}
errorOperation() {
     whiptail --title "Operation Error" --msgbox "Operation Failed\nCheck $CURDIR/$NGINX_LOG/error-$CURDAY.log" --ok-button "OK" 10 70
    exit 1
}
rebootRequired() {
   if [ -f /var/run/reboot-required ]; then
     whiptail --title "Reboot Required" --msgbox "Your Kernel was modified a reboot is required\nPress [Enter] to reboot" --ok-button "Reboot" 10 70
     reboot
   fi
}
wgetFiles() {
{
    wget $(wgetURL) 2>&1 | \
    stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }'
  } | whiptail --title "ASAS Downloader" --gauge "\nFetching application source" 10 70 0
}
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
	OS=`lowercase \`uname\``
        KERNEL=`uname -r`
        ARCH=`uname -m`
        declare -a osdist=( Debian Ubuntu )
        declare -a osrev=( 8 9 9 16.04 17.04 17.10 18.04 )

        if [ "${OS}" = "linux" ] ; then
                if [ -f /etc/debian_version ]; then
                        DistroBaseCore='Debian'
                        DISTRO=`cat /etc/*-release | grep '^NAME' | awk -F=  '{ print $2 }'`
                        VERSION=`cat /etc/*-release | grep '^VERSION_ID' | awk -F=  '{ print $2 }'`
                        CODENAME=`lsb_release -c --short`
                        RELEASE=`cat /etc/*-release | grep '^PRETTY_NAME' | awk -F=  '{ print $2 }'`
                        DISTRIB_CODENAME=`cat /etc/*-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
                        fi
                fi

        OS=`lowercase $OS`
        DISTRO=`clean_string $DISTRO`
        DistroBaseCore=`clean_string "$DistroBaseCore"`
        CODENAME=`clean_string "$CODENAME"`
        RELEASE=`clean_string "$RELEASE"`
        VERSION=`clean_string $VERSION`
        KERNEL=`clean_string "$KERNEL"`
        ARCH=`clean_string "$ARCH"`

        readonly OS
        readonly DISTRO
        readonly DistroBaseCore
        readonly CODENAME
        readonly VERSION
        readonly RELEASE
        readonly KERNEL
        readonly ARCH
        if [[ "${osdist[*]}" =~ "$DISTRO"  && "${osrev[*]}" =~ "$VERSION" ]] ; then
        if (whiptail --title "System Detect" --yesno "OS: $OS\nDistribution: $DISTRO\nVersion: $VERSION\nCodename: $CODENAME\nCommonName: $RELEASE\nDistroBaseCore: $DistroBaseCore\nKernel: $KERNEL\nArchetecture: $ARCH\n\nGreat $DISTRO - $VERSION is supported" --yes-button "Update Check" --no-button "Main Menu" 16 70) then
        pkgcache() {
         printf "apt update"
        }
        updateSources
        systemUpgrades
        asasMainMenu
        else
        asasMainMenu
        fi
        else
        whiptail --title "System Detect" --msgbox "OS: $OS\nDistribution: $DISTRO\nVersion: $VERSION\nCodename: $CODENAME\nCommonName: $RELEASE\nDistroBaseCore: $DistroBaseCore\nKernel: $KERNEL\nArchetecture: $ARCH\n\nSorry $DISTRO - $VERSION is not supported" --ok-button "Exit" 16 70 
        fi
}

#*****************************
#
# System Functions
#
#*****************************
systemInstaller() {
pkg=0
$(package) 2> /dev/null | \
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
done | whiptail --title "ASAS System Installer"  --gauge "\nChecking Packages..." 10 70 0
}

# TODO
# ** Debian 8x/9x no longer support update-notifier Damn Them! This is a bit messy IMO **
# ** Maybe code something more efficient and elegant if possible in future. Looks like **
# ** a bird sanctuary with all the nesting going on. elif may be more friendly??? **
systemUpgrades() {
     UPGRADECHECK=$(apt-get -s upgrade | grep -Po "^\d+ (?=upgraded)" 2>&1)
   if [ "$UPGRADECHECK" -gt 0 ]; then
    if [ "$DISTRO" = "Ubuntu" ]; then
     UPGRADES=$(/usr/lib/update-notifier/apt-check 2>&1)
     upsecurity=$(echo "${UPGRADES}" | cut -d ";" -f 2)
     upnonsecurity=$(echo "${UPGRADES}" | cut -d ";" -f 1)
     totalupgrade=$((upsecurity + upnonsecurity))
    if (whiptail --title "System Check" --yesno "$totalupgrade Updates are available\n$upsecurity are security updates\nWould you like to update now (Recommended)" --yes-button "Update" --no-button "Skip" 10 70) then
     package() {
       echo "apt --yes upgrade"
      }
     systemInstaller
     rebootRequired
     completeOperation
   else
    return
   fi
  fi
   if [ "$DISTRO" = "Debian" ]; then
    if (whiptail --title "System Check" --yesno "$UPGRADECHECK Updates are available\n\nWould you like to update now (Recommended)" --yes-button "Update" --no-button "Skip" 10 70) then
     package() {
       printf "apt --yes upgrade"
      }
     systemInstaller
     rebootRequired
     completeOperation
   else
     return
   fi
  fi
   else
     whiptail --title "System Check" --msgbox "System is up to date\n\nPress [Enter] for main menu..." --ok-button "OK" 10 70
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
            elif [[ "71" -eq "$i" ]]
            then
                i="52"
            fi
            sleep 1
            i=$(expr $i + 1)
            z=$(echo "$output")
            printf "XXX\n$i\n\nGenerating dhparam.pem file... ${z}\nXXX\n$i\n"
        done
  } | whiptail --title "Security Check-Modify"  --gauge "\nGenerating DH parameters, 2048 bit long safe prime, generator 2\nThis is going to take a long time" 10 70 0
}
#*****************************
#
# Update Source List Functions
#
#*****************************
updateSources() {
         i=0
         $(pkgcache) 2> /dev/null | \
         tr '[:upper:]' '[:lower:]' | \
            while read x; do
            case $x in
        *inrelease*)
            count=4
            i=0
        ;;
            fetched*|building*|reading*|all*\ ...)
            if [[ "$count" -gt 0 ]]; then
                i=$((i+1))
                x=${x%% (*}
                x=${x%% ...}
                x=$(echo ${x:0:1} | tr '[:lower:]' '[:upper:]')${x:1}
                sleep .65
                printf "XXX\n$((i*100/count))\n\n${x}\nXXX\n$((i*100/count))\n"
           fi
        ;;
    esac
done | whiptail --title "Package Check"  --gauge "\nRefreshing package cache" 10 70 0
}
#*****************************
#
# Validation Check
#
#*****************************
validateCheck() {
   if ! type whiptail > /dev/null 2>&1; then
     echo -e "\n\nDependency Check...${RED}Whiptail not installed${NOCOL}"
     sleep 1.5
     echo -e "\nInstalling Whiptail - required by this script"
     apt install whiptail -y
     echo -e "\n${GREEN}Whiptail successfully installed${NOCOL}\n\n"
     sleep 2
   else
     checkRoot
     systemDetect
   fi
}

#!/bin/bash
# ASAS 2.10
# @author: GCornell for devCU Software
# @contact: support@devcu.com
# Compatibility: Debian Core Systems (Tested on Ubuntu 14x-16x-17x & Debian 8/9)
# MAIN: https://www.devcu.com
# CODE: https://github.com/GaalexxC/ASAS
# REPO: https://www.devcu.net
# License: GNU General Public License v3.0
# Created:   06/15/2016
# Updated:   09/24/2017

###########
# Globals #
###########

lowercase(){
        echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

completeOperation() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
' \
whiptail --title "Operation Complete" --msgbox "Operation Complete\nPress [Enter] for main menu" --ok-button "Main Menu" 8 70
return
}

#scriptUpdateCheck() {
#}

#LicenseView() {
#}

phpDependencies() {
apt update &&
apt install -y language-pack-en-base &&
export LC_ALL=en_US.UTF-8 &&
export LANG=en_US.UTF-8 &&
apt install -y software-properties-common &&
add-apt-repository ppa:ondrej/php &&
apt update
}

##############
# Root Check #
##############
validateRoot() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
    if [ "$(id -u)" != "0" ]; then
       whiptail --title "System Check" --msgbox "You need root privileges to run this script.\nPress [Enter] to exit, Bye Bye" --ok-button "Exit" 8 70
       exit 1
    else
       whiptail --title "System Check" --msgbox "Root User Confirmed\nPress [Enter] to continue" --ok-button "Continue" 8 70
    fi
}


#############
# Detection #
#############
systemDetect() {
	OS=`lowercase \`uname\``
	KERNEL=`uname -r`
	MACH=`uname -m`
        declare -a osdist=( Debian Ubuntu )
        declare -a osrev=( 8 9 14.04 15.10 16.04 16.10 17.04 17.10 )

	if [ "${OS}" == "windowsnt" ]; then
		OS=windows
	elif [ "${OS}" == "darwin" ]; then
		OS=mac
	else
		OS=`uname`
		if [ "${OS}" = "SunOS" ] ; then
			OS=Solaris
			ARCH=`uname -p`
			OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
		elif [ "${OS}" = "AIX" ] ; then
			OSSTR="${OS} `oslevel` (`oslevel -r`)"
		elif [ "${OS}" = "Linux" ] ; then
			if [ -f /etc/redhat-release ] ; then
				DistroBasedOn='RedHat'
				DIST=`cat /etc/redhat-release |sed s/\ release.*//`
				PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
				REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
			elif [ -f /etc/SuSE-release ] ; then
				DistroBasedOn='SuSe'
				PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
				REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
			elif [ -f /etc/mandrake-release ] ; then
				DistroBasedOn='Mandrake'
				PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
				REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
			elif [ -f /etc/debian_version ] ; then
				DistroBasedOn='Debian'
				if [ -f /etc/lsb-release ] ; then
			        	DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
			                PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
			                REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
            			fi
			fi
			if [ -f /etc/UnitedLinux-release ] ; then
				DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
			fi
			OS=`lowercase $OS`
			DistroBasedOn=`lowercase $DistroBasedOn`
		 	readonly OS
		 	readonly DIST
			readonly DistroBasedOn
		 	readonly PSUEDONAME
		 	readonly REV
		 	readonly KERNEL
		 	readonly MACH
		fi

	fi
        if [[ "${osdist[*]}" =~ "$DIST"  && "${osrev[*]}" =~ "$REV" ]] ; then
                whiptail --title "System Detect" --msgbox "OS: $OS\nDIST: $DIST\nPSUEDONAME: $PSUEDONAME\nREV: $REV\nDistroBasedOn: $DistroBasedOn\nKERNEL: $KERNEL\nMACH: $MACH\n\nGreat, $DIST - $REV is supported" --ok-button "Continue" 16 70 6
        else
                whiptail --title "System Detect" --msgbox "OS: $OS\nDIST: $DIST\nPSUEDONAME: $PSUEDONAME\nREV: $REV\nDistroBasedOn: $DistroBasedOn\nKERNEL: $KERNEL\nMACH: $MACH\n\nSorry $DIST - $REV is not supported" --ok-button "Exit" 16 70 6
        exit 1
        fi
}

##########
# System #
##########
systemUpdater() {
pkg=0
dmesg -D
setterm -term linux -msg off
setterm -term linux -blank 0
apt upgrade -y  2> /dev/null | \
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
        unpacking*|setting\ up*|found*|removing*\ ...)
            if [ $pkgs -gt 0 ]; then
                pkg=$((pkg+1))
                x=${x%% (*}
                x=${x%% ...}
                x=$(echo ${x:0:1} | tr '[:lower:]' '[:upper:]')${x:1}
                sleep .5
                echo ""
                printf "XXX\n$((pkg*100/pkgs))\n${x} ...\nXXX\n$((pkg*100/pkgs))\n"
            fi
        ;;
    esac
done |
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
' \
         whiptail --title "System Updater" \
        --gauge "Downloading Updates..." 9 78 0
dmesg -E
setterm -term linux -msg on
#invoke-rc.d kbd restart # Restore screen blanking to default setting
}

systemUpdate() {
    UPGRADECHECK=$(/usr/lib/update-notifier/apt-check 2>&1)
    security=$(echo "${UPGRADECHECK}" | cut -d ";" -f 2)
    nonsecurity=$(echo "${UPGRADECHECK}" | cut -d ";" -f 1)
    totalupgrade=$((security + nonsecurity))
  if [ "$UPGRADECHECK" != "0;0" ]; then
     if (whiptail --title "System Check" --yesno "$totalupgrade Updates are available\n$security are security updates\nWould you like to update now (Recommended)" --yes-button "Update" --no-button "Skip" 10 70) then
pkg=0
dmesg -D
setterm -term linux -msg off
setterm -term linux -blank 0
apt upgrade -y  2> /dev/null | \
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
        unpacking*|setting\ up*|found*|removing*\ ...)
            if [ $pkgs -gt 0 ]; then
                pkg=$((pkg+1))
                x=${x%% (*}
                x=${x%% ...}
                x=$(echo ${x:0:1} | tr '[:lower:]' '[:upper:]')${x:1}
                sleep .5
                echo ""
                printf "XXX\n$((pkg*100/pkgs))\n${x} ...\nXXX\n$((pkg*100/pkgs))\n"
            fi
        ;;
    esac
done |
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
' \
         whiptail --title "System Updater" \
        --gauge "Downloading Updates..." 9 78 0
dmesg -E
setterm -term linux -msg on
#invoke-rc.d kbd restart # Restore screen blanking to default setting
     else
         return
     fi
     else
     whiptail --title "System Check" --msgbox "System is up to date\n\nPress [Enter] for main menu..." --ok-button "Main Menu" 10 70
         return
  fi
}

##########
# Reboot #
##########
rebootRequired() {
NEWT_COLORS='
   root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
' \
whiptail --title "Reboot Required" --msgbox "Your Kernel was modified a reboot is required\nPress [Enter] to reboot\nRun our Kernel Cleaner after reboot" --ok-button "Reboot" 10 70
reboot
}

ArebootRequired() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
' \
whiptail --title "Reboot Required" --msgbox "Your Kernel was modified a reboot is required\nPress [Enter] to reboot" --ok-button "Reboot" 10 70
reboot
}

################
# CheckInstall #
################
whiptailCheckInstall() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
   if ! type whiptail > /dev/null 2>&1; then
      echo "Dependency Check..."
      sleep 1.5
      echo "Installing Whiptail - required by this script"
      apt-get -qq install whiptail -y
      sleep 2
else
       whipver=$(whiptail -v 2>&1)
       whiptail --title "System Check" --msgbox "$whipver installed\nPress [Enter] to continue" --ok-button "Continue" 8 70
fi
}

2whiptailCheckInstall() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
   if ! type whiptail > /dev/null 2>&1; then
    {
    i=1
    while read -r line; do
        i=$(( i + 1 ))
        echo $i
    done < <(apt-get install whiptail -y)
  } | whiptail --title "System Check" --gauge "Please wait while installing Whiptail..." 6 60 0

else
       whipver=$(whiptail -v 2>&1)
       whiptail --title "System Check" --msgbox "$whipver installed\nPress [Enter] to continue" --ok-button "Continue" 8 70
fi
}

#clientCheckInstall() {
#}

emailCheckInstall() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
   if ! type postfix > /dev/null 2>&1; then
     if (whiptail --title "Postfix Check" --yesno "Postfix not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 11 78) then
        source scripts/mail_server.sh
    else
         return
     fi
   else
        postver=$(postfix -v)
        whiptail --title "Postfix Check" --msgbox "$postver is already installed\n\nPress [Enter] to return to main menu" --ok-button "Main Menu" 12 78
        return
   fi
}

bindCheckInstall() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
   if ! type named > /dev/null 2>&1; then
     if (whiptail --title "Bind9 Check" --yesno "Bind9 not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
        source scripts/bind9_install.sh
    else
         return
     fi
   else
        bindver=$(named -v)
        whiptail --title "Bind9 Check" --msgbox "$bindver is already installed\nPress [Enter] to return to main menu" --ok-button "Main Menu" 11 78
        return
   fi
}

mysqlCheckInstall() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
   if ! type mysql > /dev/null 2>&1; then
     if (whiptail --title "MySQL Check" --yesno "MySQL not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 11 78) then
        source scripts/mysql_install.sh
    else
	 return
     fi
    else
        dbver=$(mysql -V 2>&1)
        whiptail --title "MySQL Check" --msgbox "$dbver is currently installed\n\nPress [Enter] to return to main menu" --ok-button "Main Menu" 12 78
        return
   fi
}

nginxCheckInstall() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
   if ! type nginx > /dev/null 2>&1; then
     if (whiptail --title "Nginx Check" --yesno "Nginx not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
        source scripts/nginx_install.sh
    else
         return
     fi
   else
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver is currently installed\nPress [Enter] to return to main menu" --ok-button "Main Menu" 11 78
        return
   fi
}

phpCheckInstall() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
   if ! type php > /dev/null 2>&1; then
     if (whiptail --title "PHP Check" --yesno "PHP not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
        source scripts/php_install.sh
    else
         return
     fi
   else
        phpver=$(php -r \@phpinfo\(\)\; | grep 'PHP Version' -m 1)
        whiptail --title "PHP Check" --msgbox "$phpver is currently installed\nPress [Enter] to return to main menu" --ok-button "Main Menu" 11 78
        return
   fi
}

vsftpdCheckInstall() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
   if ! type vsftpd > /dev/null 2>&1; then
     if (whiptail --title "vsFTPd Check" --yesno "vsFTPd not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
         source scripts/ftp_install.sh
    else
         return
     fi
   else
        ftpver=$(vsftpd -v 2>&1)
        whiptail --title "vsFTPd Check" --msgbox "$ftpver is currently installed\n\nPress [Enter] to return to main menu" --ok-button "Main Menu" 12 78
        return
   fi
}

#clearCheckInstall() {
#}

################
# CheckCompile #
################
nginxCheckCompile() {
NEWT_COLORS='
  root=,blue
  window=,lightgray
  border=,white
  shadow=,gray
  button=lightgray,gray
'
   if ! type nginx > /dev/null 2>&1; then
     if (whiptail --title "Nginx Check" --yesno "Nginx not installed\nDo you want to install?" --yes-button "Install" --no-button "Cancel" 10 70) then
        source scripts/nginx_compile.sh &&
        source scripts/nginx_configure.sh | grep -v 'omitting directory'
    else
         return
     fi
   else
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver is currently installed\nPress [Enter] to return to main menu" --ok-button "Main Menu" 11 78
        return
   fi
}

###########
# Logging #
###########
touch $SCRIPT_LOG

SCRIPTENTRY() {
 timeAndDate=`date`
 script_name=`basename "$0"`
 script_name="${script_name%.*}"
 echo "[$timeAndDate] [DEBUG]  > $script_name started new process" >> $SCRIPT_LOG
}

SCRIPTEXIT() {
 script_name=`basename "$0"`
 script_name="${script_name%.*}"
 echo "[$timeAndDate] [DEBUG]  < $script_name $FUNCNAME" >> $SCRIPT_LOG
}

ENTRY() {
 local cfn="${FUNCNAME[1]}"
 timeAndDate=`date`
 echo "[$timeAndDate] [DEBUG]  > $cfn $FUNCNAME" >> $SCRIPT_LOG
}

EXIT() {
 local cfn="${FUNCNAME[1]}"
 timeAndDate=`date`
 echo "[$timeAndDate] [DEBUG]  < $cfn $FUNCNAME" >> $SCRIPT_LOG
}

INFO() {
 local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`date`
    echo "[$timeAndDate] [INFO]  $msg" >> $SCRIPT_LOG
}

DEBUG() {
 local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`date`
 echo "[$timeAndDate] [DEBUG]  $msg" >> $SCRIPT_LOG
}

ERROR() {
 local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`date`
    echo "[$timeAndDate] [ERROR]  $msg" >> $SCRIPT_LOG
}

#apt update sources
updateSources() {
apt-get -qq update & PID=$!

echo -e "\nChecking System Status...\n"
    printf "["
  while kill -0 $PID 2> /dev/null; do
    printf  "▓▓▓"
    sleep 1
  done
    printf "] complete"
}

#updateSources() {
#	{
#        apt update & PID=$!
#
#
#	} | whiptail --gauge "\nChecking System Status..." 6 60 0
#}

############
# File End #
############

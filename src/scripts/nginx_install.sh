#!/bin/bash
#################################################################################
#                   *** ASAS 2.10 [Auto Server Admin Script] ***                #
#        @author: GCornell for devCU Software Open Source Projects              #
#        @contact: gacornell@devcu.com                                          #
#        $OS: Debian Core (Tested on Ubuntu 14x -> 17x / Debian 8.x -> 9.x)     #
#        $MAIN: https://www.devcu.com                                           #
#        $SOURCE: https://github.com/GaalexxC/ASAS                              #
#        $REPO: https://www.devcu.net                                           #
#        +Created:   06/15/2016 Ported from nginxubuntu-php7                    #
#        &Updated:   10/10/2017 19:21 EDT                                       #
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
      if [ ! -d $CURDIR/$NGINX_LOG/ ]
       then
       mkdir -p $CURDIR/$NGINX_LOG/
      fi
      if [ ! -f $CURDIR/$NGINX_LOG/install-$CURDAY.log ]
       then
       touch $CURDIR/$NGINX_LOG/install-$CURDAY.log
      fi
      if [ ! -f $CURDIR/$NGINX_LOG/error-$CURDAY.log ]
       then
       touch $CURDIR/$NGINX_LOG/error-$CURDAY.log
      fi
      if [ ! -f $CURDIR/$NGINX_LOG/nginx-$CURDAY.log ]
       then
       touch $CURDIR/$NGINX_LOG/nginx-$CURDAY.log
      fi
clear

while [ 3 ]
do

SELECTNGINX=$(
whiptail --title "Nginx Web Server Installer" --radiolist "\nUse up/down arrows and space to select operation\n" 20 78 9 \
        "1)" "Nginx Latest Mainline (Recommended)" ON \
        "2)" "Nginx Latest Stable" OFF \
        "3)" "Build Nginx source with Openssl (Advanced)" OFF \
        "4)" "Remove Nginx (Preserves Configurations)" OFF \
        "5)" "Purge Nginx (Wipe Clean)" OFF \
        "6)" "Clean Source Build (Archives Configurations)" OFF \
        "7)" "Generate 2048bit Diffie-Hellman (Required for Nginx SSL/TLS)" OFF \
        "8)" "Return to Main Menu" OFF \
        "9)" "Exit" OFF 3>&1 1>&2 2>&3
)

case $SELECTNGINX in
        "1)")
   if ! type nginx > /dev/null 2>&1; then
    if (whiptail --title "Install Nginx" --yesno "This will install the latest Nginx Mainline version\n\nWould you like to install Nginx mainline" --yes-button "Install" --no-button "Cancel" 10 70) then
     if [ "$DISTRO" = "Ubuntu" ]; then
       echo "deb http://nginx.org/packages/mainline/ubuntu/ $CODENAME nginx" >> $APT_SOURCES
       echo "deb-src http://nginx.org/packages/mainline/ubuntu/ $CODENAME nginx" >> $APT_SOURCES
      elif [ "$DISTRO" = "Debian" ]; then
       echo "deb http://nginx.org/packages/mainline/debian/ $CODENAME nginx" >> $APT_SOURCES
       echo "deb-src http://nginx.org/packages/mainline/debian/ $CODENAME nginx" >> $APT_SOURCES
       package() {
         printf "apt --yes install curl"
       }
       systemInstaller
      else
       whiptail --title "System Check" --msgbox "System OS is not recognized\nPress [Enter] to exit..." --ok-button "OK" 10 70
      exit 1
     fi
       nginxRepoAdd
       pkgcache() {
         printf "apt update"
       }
       updateSources
       package() {
         printf "apt --yes install nginx fcgiwrap spawn-fcgi"
       }
       systemInstaller
       sleep .50
       nginxConfigure
       ngxver=$(nginx -v 2>&1)
       whiptail --title "Nginx Check" --msgbox "$ngxver successfully installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      else
       cancelOperation
    fi
      else
       ngxver=$(nginx -v 2>&1)
       whiptail --title "Nginx Check" --msgbox "$ngxver is already installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
   fi
        ;;

        "2)")
   if ! type nginx > /dev/null 2>&1; then
    if (whiptail --title "Install Nginx" --yesno "This will install the latest Nginx Stable version\n\nWould you like to install Nginx stable" --yes-button "Install" --no-button "Cancel" 10 70) then
     if [ "$DISTRO" = "Ubuntu" ]; then
       echo "deb http://nginx.org/packages/ubuntu/ $CODENAME nginx" >> $APT_SOURCES
       echo "deb-src http://nginx.org/packages/ubuntu/ $CODENAME nginx" >> $APT_SOURCES
      elif [ "$DISTRO" = "Debian" ]; then
       echo "deb http://nginx.org/packages/debian/ $CODENAME nginx" >> $APT_SOURCES
       echo "deb-src http://nginx.org/packages/debian/ $CODENAME nginx" >> $APT_SOURCES
       package() {
         printf "apt --yes install curl"
       }
       systemInstaller
      else
      whiptail --title "System Check" --msgbox "System OS is not recognized\nPress [Enter] to exit..." --ok-button "OK" 10 70
      exit 1
    fi
      nginxRepoAdd
      pkgcache() {
         printf "apt update"
       }
      updateSources
      package() {
         printf "apt --yes install nginx fcgiwrap spawn-fcgi"
       }
      systemInstaller
      sleep 1
      nginxConfigure
      ngxver=$(nginx -v 2>&1)
      whiptail --title "Nginx Check" --msgbox "$ngxver successfully installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      else
      cancelOperation
    fi
      else
       ngxver=$(nginx -v 2>&1)
       whiptail --title "Nginx Check" --msgbox "$ngxver is already installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
   fi
        ;;

        "3)")
   if ! type nginx > /dev/null 2>&1 || [ -f /etc/nginx/.build-$CURDAY ]; then
    if (whiptail --title "Nginx Compiler" --yesno "Nginx-OpenSSL source build\nYou can compile new, recompile, or upgrade compile\nDo you want to run source build?" --yes-button "Build" --no-button "Cancel" 10 70) then
       mkdir $CURDIR/source/
       cd $CURDIR/source
       package() {
         printf "apt --yes install build-essential libpcre3 libpcre3-dev zlib1g-dev libxslt1-dev libgd-dev libgeoip-dev libperl-dev libssl-dev fcgiwrap spawn-fcgi sudo curl"
       }
       systemInstaller
       wgetURL() {
          printf "wget https://www.openssl.org/source/$OPENSSL_SOURCE"
        }
       wgetFiles
       wgetURL() {
          printf "wget http://nginx.org/download/$NGINX_SOURCE"
        }
       wgetFiles
       extractArchive
       cd $CURDIR/source/$(basename $NGINX_SOURCE .tar.gz)/
       echo -e "Build date: $DATE_TIME\n\n" > $CURDIR/$NGINX_LOG/install-$CURDAY.log
       nginxSourceConfigure
       nginxMake
       nginxMakeInstall
       nginxServices
       nginxConfigure
       nginxCleanup
       whiptail --title "Nginx Source Compiled" --textbox /dev/stdin 12 70 <<<"$(sed -n '1,5p' < /etc/nginx/.build-$CURDAY)"
      else
       cancelOperation
    fi
      else
       ngxver=$(nginx -v 2>&1)
       whiptail --title "Nginx Check" --msgbox "$ngxver is already installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
   fi
        ;;

        "4)")
   if type nginx > /dev/null 2>&1 && [ ! -f /etc/nginx/.build-$CURDAY ]; then
    if (whiptail --title "Remove Nginx" --yesno "Warning! Removes Nginx (Preserves Configurations)\n\nWould you like to remove Nginx" --yes-button "Remove" --no-button "Cancel" 10 70) then

       package() {
         printf "apt --yes remove nginx fcgiwrap spawn-fcgi"
       }
       systemInstaller
       sleep 1
       pkgcache() {
          printf "apt-get --yes autoremove"
       }
       updateSources
       sleep 1
       nginxRemove
       sleep 1
       pkgcache() {
          printf "apt-get autoclean"
       }
       updateSources
       sleep 1
       whiptail --title "Nginx Uninstall" --msgbox "Nginx has been removed from system\n\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      else
       cancelOperation
    fi
      elif [ -f /etc/nginx/.build-$CURDAY ]
      then
       whiptail --title "Nginx Source Compiled" --textbox /dev/stdin 12 70 <<<"$(sed -n '1,5p' < /etc/nginx/.build-$CURDAY)"
       whiptail --title "Nginx Check-Install" --msgbox "Nginx source build detected\nYou cannot use tool this to uninstall source build\nPlease use Clean Source Build" --ok-button "OK" 10 70
      else
       whiptail --title "Nginx Uninstall" --msgbox "Nothing to do Nginx not installed\nPress [Enter] to continue" --ok-button "OK" 10 70
   fi
        ;;

        "5)")
     if type nginx > /dev/null 2>&1 && [ ! -f /etc/nginx/.build-$CURDAY ]; then
      if (whiptail --title "Purge Nginx" --yesno "Warning! Wipes all traces of Nginx from your system!\nAll configurations/logs/repos...etc deleted!\n\nWould you like to purge Nginx?" --yes-button "Purge" --no-button "Cancel" 10 70) then
       package() {
         printf "apt --yes purge nginx fcgiwrap spawn-fcgi"
       }
       systemInstaller
       sleep 1
       pkgcache() {
          printf "apt-get --yes  autoremove"
       }
       updateSources
       sleep 1
       nginxPurge
       sleep 1
       pkgcache() {
          printf "apt-get autoclean"
       }
       updateSources
       sleep 1
         whiptail --title "Nginx Uninstall" --msgbox "Nginx has been wiped from system\n\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      else
       cancelOperation
     fi
      elif [ -f /etc/nginx/.build-$CURDAY ]
      then
       whiptail --title "Nginx Source Compiled" --textbox /dev/stdin 12 70 <<<"$(sed -n '1,5p' < /etc/nginx/.build-$CURDAY)"
       whiptail --title "Nginx Check-Install" --msgbox "Nginx source build detected\nYou cannot use tool this to uninstall source build\nPlease use Clean Source Build" --ok-button "OK" 10 70
      else
         whiptail --title "Nginx Uninstall" --msgbox "Nothing to do Nginx not installed\nPress [Enter] to continue" --ok-button "OK" 10 70
    fi
        ;;

        "6)")
    if ! type nginx > /dev/null 2>&1; then
         whiptail --title "Nginx Uninstall" --msgbox "Nothing to do Nginx not installed\nPress [Enter] to continue" --ok-button "OK" 10 70
     elif type nginx > /dev/null 2>&1 && [ -f /etc/nginx/.build-$CURDAY ]; then
      if (whiptail --title "Nginx Uninstall" --yesno "Warning! This tool will wipe Nginx source build from your system\nConfigurations will be archived to $CURDIR/backups folder\n\nWould you like to uninstall Nginx?" --yes-button "Uninstall" --no-button "Cancel" 10 70) then
       package() {
         printf "apt --yes purge fcgiwrap spawn-fcgi"
       }
       systemInstaller
       sleep 1
       pkgcache() {
          printf "apt-get --yes autoremove"
       }
       updateSources
       sleep .50
       cleanBuild
       sleep .50
        whiptail --title "Nginx Uninstall" --msgbox "Nginx has been wiped from system\nConfiguration backup @ $CURDIR/backups/nginxconf_backup.tar.gz\n\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      else
       cancelOperation
      fi
     else
        whiptail --title "Nginx Uninstall" --msgbox "Nginx source build not detected\nYou cannot use this tool to uninstall Nginx\nPlease use remove or purge options in menu" --ok-button "OK" 10 70
      fi
        ;;

        "7)")
      if [ -f /etc/ssl/certs/dhparam.pem ]
      then
        whiptail --title "Security Check-Modify" --msgbox "Diffie-Hellman cert already exists!\nPATH is configured in nginx vhost templates\n\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      else
      secureCommand() {
         output='openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048'
         printf "$output"
       }
      secureApp() {
         printf "openssl"
       }
        secureCheckModify
        whiptail --title "Security Check-Modify" --msgbox "Diffie-Hellman cert @ /etc/ssl/certs/dhparam.pem\nPATH is configured in nginx vhost templates\n\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      fi
        ;;

        "8)")
      return
        ;;

        "9)")
      exit 1
        ;;
    esac

  done

exit

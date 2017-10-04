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
#        &Updated:   10/04/2017 02:15 EDT                                       #
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

while [ 3 ]
do

SELECTNGINX=$(
whiptail --title "Nginx Web Server Installer" --radiolist "\nUse up/down arrows and tab to select an Nginx version\nUpon selection operation will begin without prompts" 20 78 8 \
        "1)" "Nginx Latest Mainline (Recommended)" ON \
        "2)" "Nginx Latest Stable" OFF \
        "3)" "Build Nginx source with Openssl (Advanced)" OFF \
        "4)" "Remove Nginx (Preserves Configurations)" OFF \
        "5)" "Purge Nginx (Wipe Nginx Clean)" OFF \
        "6)" "Generate 2048bit Diffie-Hellman (Required for Nginx SSL/TLS)" OFF \
        "7)" "Return to Main Menu" OFF \
        "8)" "Exit" OFF 3>&1 1>&2 2>&3
)

case $SELECTNGINX in
        "1)")
   if ! type nginx > /dev/null 2>&1; then
    if [ "$DISTRO" = "Ubuntu" ]; then
       echo "deb http://nginx.org/packages/mainline/ubuntu/ $CODENAME nginx" >> $APT_SOURCES
       echo "deb-src http://nginx.org/packages/mainline/ubuntu/ $CODENAME nginx" >> $APT_SOURCES
        elif [ "$DISTRO" = "Debian" ]; then
       echo "deb http://nginx.org/packages/mainline/debian/ $CODENAME nginx" >> $APT_SOURCES
       echo "deb-src http://nginx.org/packages/mainline/debian/ $CODENAME nginx" >> $APT_SOURCES
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
         printf "apt --yes --force-yes install nginx fcgiwrap"
       }
       systemInstaller
       sleep 1
       nginxConfigure
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver sucessfully installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
     else
       ngxver=$(nginx -v 2>&1)
       whiptail --title "Nginx Check" --msgbox "$ngxver is already installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
   fi
        ;;

        "2)")
    if ! type nginx > /dev/null 2>&1; then
     if [ "$DISTRO" = "Ubuntu" ]; then
      echo "deb http://nginx.org/packages/ubuntu/ $CODENAME nginx" >> $APT_SOURCES
      echo "deb-src http://nginx.org/packages/ubuntu/ $CODENAME nginx" >> $APT_SOURCES
     elif [ "$DISTRO" = "Debian" ]; then
      echo "deb http://nginx.org/packages/debian/ $CODENAME nginx" >> $APT_SOURCES
      echo "deb-src http://nginx.org/packages/debian/ $CODENAME nginx" >> $APT_SOURCES
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
         printf "apt --yes --force-yes install nginx fcgiwrap"
       }
      systemInstaller
      sleep 1
        nginxConfigure
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver sucessfully installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      else
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver is already installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      fi
        ;;

        "3)")
      if ! type nginx > /dev/null 2>&1; then
      package() {
         printf "apt --yes --force-yes install build-essential libpcre3 libpcre3-dev zlib1g-dev libxslt1-dev libgd-dev libgeoip-dev libperl-dev libssl-dev fcgiwrap"
       }
      systemInstaller
        mkdir $CURDIR/source/
        cd $CURDIR/source
      wgetURL() {
          printf "wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz"
        }
      wgetFiles
      wgetURL() {
          printf "wget http://nginx.org/download/nginx-1.13.5.tar.gz"
        }
      wgetFiles
        tar -zxvf openssl-1.1.0f.tar.gz
        tar -zxvf nginx-1.13.5.tar.gz
        cd $CURDIR/source/nginx-1.13.5/
        ./configure --prefix=/etc/nginx \
                    --sbin-path=/usr/sbin/nginx \
                    --modules-path=/usr/lib/nginx/modules \
                    --conf-path=/etc/nginx/nginx.conf \
                    --error-log-path=/var/log/nginx/error.log \
                    --http-log-path=/var/log/nginx/access.log \
                    --pid-path=/var/run/nginx.pid \
                    --lock-path=/var/run/nginx.lock \
                    --http-client-body-temp-path=/var/cache/nginx/client_temp \
                    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
                    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
                    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
                    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
                    --user=www-data \
                    --group=www-data \
                    --with-http_ssl_module \
                    --with-http_realip_module \
                    --with-http_addition_module \
                    --with-http_sub_module \
                    --with-http_dav_module \
                    --with-http_flv_module \
                    --with-http_mp4_module \
                    --with-http_gunzip_module \
                    --with-http_gzip_static_module \
                    --with-http_random_index_module \
                    --with-http_secure_link_module \
                    --with-http_stub_status_module \
                    --with-http_auth_request_module \
                    --with-http_xslt_module=dynamic \
                    --with-http_image_filter_module=dynamic \
                    --with-http_geoip_module=dynamic \
                    --with-http_perl_module=dynamic \
                    --with-threads \
                    --with-stream \
                    --with-stream_ssl_module \
                    --with-stream_geoip_module=dynamic \
                    --with-http_slice_module \
                    --with-mail \
                    --with-mail_ssl_module \
                    --with-file-aio \
                    --with-http_v2_module \
                    --with-openssl=$CURDIR/source/openssl-1.1.0f \
                    --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
                    --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' && \
        sudo make && \
        sudo make install
        cd $CURDIR
        rm -rf source
        DATE=$(date +'%Y-%m-%d')
        nginxbuild=$(nginx -V 2>&1)
        echo -e "\nBuild date: $DATE \n$nginxbuild" >> /etc/nginx/.build
        nginxService
        nginxConfigure
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver sucessfully compiled\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
        else
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver is already installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
        fi
        ;;

        "4)")
     if type nginx > /dev/null 2>&1; then
      if (whiptail --title "Remove Nginx" --yesno "Warning! Removes Nginx (Preserves Configurations)\n\nWould you like to remove Nginx" --yes-button "Remove" --no-button "Cancel" 10 70) then

       package() {
         printf "apt --yes --force-yes remove nginx fcgiwrap spawn-fcgi"
       }
       systemInstaller
       sleep 1
       pkgcache() {
          printf "apt-get --yes --force-yes autoremove"
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
         whiptail --title "Operation Cancelled" --msgbox "Operation Cancelled\nPress [Enter] to go back" --ok-button "OK" 10 70
     fi
     else
         whiptail --title "Nginx Check-Install" --msgbox "Nothing to do Nginx not installed\nPress [Enter] to continue" --ok-button "OK" 10 70
     fi
        ;;

        "5)")
     if type nginx > /dev/null 2>&1; then
      if (whiptail --title "Purge Nginx" --yesno "Warning! Wipes all traces of Nginx from your system!\nAll configurations/logs/repos...etc deleted!\n\nWould you like to purge Nginx?" --yes-button "Purge" --no-button "Cancel" 10 70) then

       package() {
         printf "apt --yes --force-yes purge nginx fcgiwrap spawn-fcgi"
       }
       systemInstaller
       sleep 1
       pkgcache() {
          printf "apt-get --yes --force-yes autoremove"
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
         whiptail --title "Operation Cancelled" --msgbox "Operation Cancelled\nPress [Enter] to go back" --ok-button "OK" 10 70
     fi
     else
         whiptail --title "Nginx Check-Install" --msgbox "Nothing to do Nginx not installed\nPress [Enter] to continue" --ok-button "OK" 10 70
     fi
        ;;

        "6)")
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

        "7)")
      return
        ;;

        "8)")
      exit 1
        ;;
    esac

  done

exit

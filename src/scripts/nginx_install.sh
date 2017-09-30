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
# Updated:   09/30/2017

clear

#Nginx Install Menu

while [ 3 ]
do

SELECTNGINX=$(
whiptail --title "Nginx Web Server Installer" --radiolist "\nUse up/down arrows and tab to select an Nginx version\nUpon selection operation will begin without prompts" 20 78 8 \
        "1)" "Nginx Latest Mainline (Recommended)" ON \
        "2)" "Nginx Latest Stable" OFF \
        "3)" "Build Nginx source with Openssl (Advanced)" OFF \
        "4)" "Remove Nginx (Preserves Configurations)" OFF \
        "5)" "Purge Nginx (WARNING! Removes Everything!)" OFF \
        "6)" "Generate 2048bit Diffie-Hellman (Required for Nginx SSL/TLS)" OFF \
        "7)" "Return to Main Menu" OFF \
        "8)" "Exit" OFF 3>&1 1>&2 2>&3
)

case $SELECTNGINX in
        "1)")
   if ! type nginx > /dev/null 2>&1; then
        return
      else
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver is already installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      fi
        ;;

        "2)")
    if ! type nginx > /dev/null 2>&1; then
      debrepo="deb http://nginx.org/packages/ubuntu/ xenial nginx"
      debsrcrepo="deb-src http://nginx.org/packages/ubuntu/ xenial nginx"
      nginxRepoAdd
      updateSources
      package() {
         printf "apt install nginx fcgiwrap"
       }
      systemInstaller
      sleep 2

# -------
# NGINX CONFIG:
# -------
        echo -e "\nMaking backup of original nginx.conf"
        sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
        echo -e "\nUpdating nginx.conf with cache optimization and secure rules\n"
        CONFIGCONF='/etc/nginx/'
        cp config/nginx/nginx.conf $CONFIGCONF 2>/dev/null
        sleep 1
        echo -e "\nCreate nginx $NGINX_SITES_AVAILABLE if doesnt exist"
      if [ -d "$NGINX_SITES_AVAILABLE" ]
      then
        echo -e "\nDirectory $NGINX_SITES_AVAILABLE exists."
      else
        mkdir -p $NGINX_SITES_AVAILABLE
        echo -e "\nFinished directory creation"
      fi
        sleep 1
        echo -e "\nCreate nginx $NGINX_SITES_ENABLED if doesnt exist"
      if [ -d "$NGINX_SITES_ENABLED" ]
      then
        echo -e "\nDirectory $NGINX_SITES_ENABLED exists."
      else
        mkdir -p $NGINX_SITES_ENABLED
        echo -e "\nFinished directory creation"
      fi
        sleep 1
        echo -e "\nCreate nginx $NGINX_CONFD if doesnt exist"
      if [ -d "$NGINX_CONFD" ]
      then
        echo -e "\nDirectory $NGINX_CONFD exists."
      else
        mkdir -p $NGINX_CONFD
        echo -e "\nFinished directory creation"
      fi
        sleep 1
# -------
# NGINX VHOST:
# -------
        echo -e "\nCreate nginx vhosts.conf if doesnt exist"
      if [ -f /etc/nginx/conf.d/vhosts.conf ]
      then
        echo -e "\nGreat! the file exists"
      else
        echo -e "\nThe file doesnt exist, creating..."
        touch /etc/nginx/conf.d/vhosts.conf
        echo "include /etc/nginx/sites-enabled/*.vhost;" >>/etc/nginx/conf.d/vhosts.conf
      fi
        echo -e "\nFinished vhosts.conf creation"
        sleep 1
# Create, chown and optimize nginx cache/gzip directories!
        echo -e "\nCreate, chown and optimize nginx cache/gzip directories"
        mkdir -p /var/cache/nginx
        mkdir -p /var/cache/nginx/fcgi
        mkdir -p /var/cache/nginx/tmp
        chown -R www-data:root /var/cache/nginx
        echo -e "\nOperation Complete"
        echo -e "\nRestart Services\n"
         $NGINX_INIT
        sleep 3
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver sucessfully installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      else
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver is already installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      fi
        ;;

        "3)")
      if ! type nginx > /dev/null 2>&1; then
        return
      else
        ngxver=$(nginx -v 2>&1)
        whiptail --title "Nginx Check" --msgbox "$ngxver is already installed\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
      fi
        ;;

        "4)")
         apt remove nginx -y
         apt autoremove -y
         sed -i.bak '/nginx/d' $APT_SOURCES
         whiptail --title "Nginx Uninstall" --msgbox "Nginx has been removed, configurations preserved\n\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
        ;;

        "5)")
     if type nginx > /dev/null 2>&1; then
      if (whiptail --title "Purge Nginx" --yesno "Warning! This will delete Nginx from your system!\nAll configurations removed, there is no going back!\n\nWould you like to purge Nginx?" --yes-button "Purge" --no-button "Cancel" 10 70) then

       package() {
         printf "apt purge nginx fcgiwrap spawn-fcgi"
       }
       systemInstaller
       sleep 2
       package() {
         printf "apt autoremove"
       }
       systemInstaller
       sleep 2
         echo "removing directories"
         rm -rf /etc/nginx
         echo "Removing Nginx repos"
         sed -i.bak '/nginx/d' $APT_SOURCES
       package() {
         printf "apt autoclean"
       }
       systemInstaller
         sleep 4
         whiptail --title "Nginx Uninstall" --msgbox "Nginx has been removed from system\n\nPress [Enter] to return to Nginx menu" --ok-button "OK" 10 70
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


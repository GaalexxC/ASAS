#!/bin/bash
# Auto Server Installer v2.10
# @author: G Cornell for devCU Software
# @contact: support@devcu.com
# @Facebook: facebook.com/garyacornell
# Compatible: Ubuntu 12-14-16.x Servers running PHP 5/7 - README for custom configurations
# MAIN: http://www.devcu.com  http://www.devcu.net
# REPO: https://github.com/GaryCornell/Auto-Server-Installer
# License: GNU General Public License v3.0
# Created:   06/15/2016
# Updated:   09/16/2017

# Install and/or upgrade Nginx to mainline
      echo -e  "\nDo you want to install Nginx Mainline(y/n)"
      read INSTALLNGINX
   if [ $INSTALLNGINX == "y" ]; then
      echo -e  "\nChecking if Nginx mainline repo exists"
   if grep -q $NGINX_MAINLINE $APT_SOURCES; then
      echo "Great! we found '$NGINX_MAINLINE' lets install:"
      echo -e  "\nLooking for latest nginx, this may take a few seconds..."
      apt -qq update
      apt install nginx fcgiwrap -y
      nginx -v
      echo -e "\nNginx Installed"
   else
      echo "We couldnt find '$NGINX_MAINLINE' adding it now and updating:"
      echo "deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> $APT_SOURCES
      echo "deb-src http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> $APT_SOURCES
      apt clean
      echo "Grabbing signing key"
      curl -O https://nginx.org/keys/nginx_signing.key && apt-key add ./nginx_signing.key
      echo -e  "\nLooking for nginx, this may take a few seconds..."
      apt -qq update
      apt-get install nginx fcgiwrap -y
      nginx -v
      echo -e "\nNginx installed successfully\n"
   fi
   else
      echo -e "\nSkipping Nginx mainline install\n"
   fi

# Install PHP
      echo "Do you want to install required PHP applications (Required) (y/n)"
      read CHECKPHP
   if [ $CHECKPHP == "y" ]; then
      echo -e "\nInstalling Required Applications"
      apt -qq update
      apt install $PHP7_PACKAGES -y
      echo -e "\nPHP Installed"
      echo -e "\nSystem Updated\n"
   else
      echo -e "\nSkipping PHP update\n"
   fi

   read -p "System is ready for configuration, hit ENTER to continue..."


# -------
# Diffie-Hellman:
# -------
      echo -e "\nSecurity Check - Generating 2048bit Diffie-Hellman for TLS"
   if [ -f /etc/ssl/certs/dhparam.pem ]
   then
      echo -e "\nGreat! the file exists\n"
   else
         echo -e "\nFile doesnt exist, creating now"
      openssl dhparam 2048 -out /etc/ssl/certs/dhparam.pem
   fi
      echo -e "\nFinsihed DH TLS Generation\n"


# -------
# PHP INI CONFIG:
# -------
   if [ $CHECKPHP == "y" ]; then
      echo -e "\nSecure PHP INI for FPM/CLI - \nThis will secure the following:\ncgi.fix_pathinfo=0\nexposephp=off\ndisable_functions = disable dangerous stuff"
      echo -e "\nSecurity Check - Do you want to secure your php.ini? (y/n)"
      read CHECKPHPINI
   if [ $CHECKPHPINI == "y" ]; then
      echo -e "\nMaking backup ups of original fpm and cli php.ini"
      sudo mv /etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/php.ini.bak
      sudo mv /etc/php/7.0/cli/php.ini /etc/php/7.0/cli/php.ini.bak
      echo -e "\nUpdating fpm and cli php.ini with secure rules"
      CONFIGFPM=$PHP_FPM_INI
      cp config/phpini/php.ini $CONFIGFPM 2>/dev/null
      CONFIGCLI=$PHP_CLI_INI
      cp config/phpini/php.ini $CONFIGCLI 2>/dev/null
      echo -e "\nphp.ini fpm and cli secured\n"
   else
      echo -e "\nNot a wise choice, We highly suggest securing your php.ini files\n"
   fi
   else
     echo -e "\nSkipping php.ini fpm and cli security\n"
   fi

# -------
# NGINX CONFIG:
# -------
   if [ $INSTALLNGINX == "y" ]; then
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
     echo -e "\nFinsihed directory creation"
   fi
     sleep 1 

     echo -e "\nCreate nginx $NGINX_SITES_ENABLED if doesnt exist"
   if [ -d "$NGINX_SITES_ENABLED" ]
   then
     echo -e "\nDirectory $NGINX_SITES_ENABLED exists."
   else
     mkdir -p $NGINX_SITES_ENABLED
     echo -e "\nFinsihed directory creation"
   fi
     sleep 1

     echo -e "\nCreate nginx $NGINX_CONFD if doesnt exist"
   if [ -d "$NGINX_CONFD" ]
   then
     echo -e "\nDirectory $NGINX_CONFD exists."
   else
     mkdir -p $NGINX_CONFD
     echo -e "\nFinsihed directory creation"
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
     echo -e "\nFinsihed vhosts.conf creation"
     sleep 1
# Create, chown and optimize nginx cache/gzip directories!
     echo -e "\nCreate, chown and optimize nginx cache/gzip directories"
     mkdir -p /var/cache/nginx
     mkdir -p /var/cache/nginx/fcgi
     mkdir -p /var/cache/nginx/tmp
     chown -R www-data:root /var/cache/nginx
     echo -e "\nOperation Complete"
   else
     echo -e "\nSkipping Nginx directory setup"
   fi
   read -p "Hit [ENTER] to return to main menu..."
   return

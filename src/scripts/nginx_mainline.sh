#!/bin/bash
#################################################################################
#                   *** ASAS 2.10 [Auto Server Admin Script] ***                #
#        @author: GCornell for devCU Software Open Source Projects              #
#        @contact: gacornell@devcu.com                                          #
#        $OS: Debian Core Systems (Tested on Ubuntu 14x -> 17x & Debian 8x/9x)  #
#        $MAIN: https://www.devcu.com                                           #
#        $SOURCE: https://github.com/GaalexxC/ASAS                              #
#        $REPO: https://www.devcu.net                                           #
#        +Created:   06/15/2016 Ported from nginxubuntu-php7                    #
#        &Updated:   10/02/2017 02:12 EDT                                       #
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

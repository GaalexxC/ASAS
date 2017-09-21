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

# -------
# NGINX CONFIGURATION:
# -------

        echo -e  "\nNginx Directory and Configuration setup?"
        echo -e  "\nAnswer y (yes) if first compile or n (no) for re-compile on this server"
        read CONFIGURENGINX
    if [ "$CONFIGURENGINX" == "y" ]; then
        echo -e "\nCreate directory structure, service files, and configuration files"

# -------
# NGINX DIRECTORIES:
# -------

        echo -e "\nMaking backup of original nginx.conf"
        sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
        sleep .5
        echo -e "\nUpdating nginx.conf with optimization and secure rules\n"
        CONFIGCONF='/etc/nginx/'
        cp $CURRENT_DIR config/nginx/nginx.conf $CONFIGCONF
        sleep .5
        echo -e "\nCreate nginx $NGINX_SITES_AVAILABLE if doesnt exist"
   if [ -d "$NGINX_SITES_AVAILABLE" ]
   then
        echo -e "Directory $NGINX_SITES_AVAILABLE exists."
   else
        mkdir -p $NGINX_SITES_AVAILABLE
        echo -e "\nFinsihed directory creation"
   fi
        sleep .5
        echo -e "\nCreate nginx $NGINX_SITES_ENABLED if doesnt exist"
   if [ -d "$NGINX_SITES_ENABLED" ]
   then
        echo -e "Directory $NGINX_SITES_ENABLED exists."
   else
        mkdir -p $NGINX_SITES_ENABLED
        echo -e "\nFinsihed directory creation"
   fi
        sleep .5
        echo -e "\nCreate nginx $NGINX_CONFD if doesnt exist"
   if [ -d "$NGINX_CONFD" ]
   then
        echo -e "Directory $NGINX_CONFD exists."
   else
        mkdir -p $NGINX_CONFD
        echo -e "\nFinsihed directory creation"
   fi
        sleep .5
# -------
# NGINX VHOST.CONF:
# -------
        echo -e "\nCreate nginx vhosts.conf"
   if [ -f /etc/nginx/conf.d/vhosts.conf ]
   then
        echo -e "\nGreat! the file exists"
   else
        echo -e "\nThe file doesnt exist, creating..."
        touch /etc/nginx/conf.d/vhosts.conf
        echo "include /etc/nginx/sites-enabled/*.vhost;" >>/etc/nginx/conf.d/vhosts.conf
   fi
        echo -e "\nFinsihed vhosts.conf creation"
        sleep .5
# Create, chown and optimize nginx cache/gzip directories!
        echo -e "\nCreate, chown and optimize nginx cache/gzip directories"
        mkdir -p /var/cache/nginx
        mkdir -p /var/cache/nginx/fcgi
        mkdir -p /var/cache/nginx/tmp
        chown -R $WEB_SERVER_GROUP:root /var/cache/nginx
        echo -e "\nDirectory creation and cofiguration complete"
        sleep .5
# -------
# NGINX SERVICE FILES:
# -------
        echo -e "\nCreate nginx service files"
        sleep .5
        echo -e "\nAdding Nginx service file\n"
        CONFIGSERVICE='/lib/systemd/system/'
        cp $CURRENT_DIR config/nginx/nginx.service $CONFIGSERVICE
        chmod 0644 /lib/systemd/system/nginx.service
        systemctl enable nginx.service
        sleep .5
        echo -e "\nAdding Nginx init.d file\n"
        CONFIGINITD='/etc/init.d/'
        cp $CURRENT_DIR config/nginx/nginx $CONFIGINITD
        sudo chmod 755 /etc/init.d/nginx
        update-rc.d nginx defaults
        echo -e "\nSuccessfully created service files\n"
        sleep .5
   fi
        echo -e "\nRestart nginx Service"
        $NGINX_INIT
        echo ""
        read -p "Press [Enter] for main menu..."
        return

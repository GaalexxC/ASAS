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
#        &Updated:   11/07/2017 18:26 EDT                                       #
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
# Nginx Functions
#
#*****************************
nginxRepoAdd() {
{
    echo -e "XXX\n25\n\nAdding Nginx repos... \nXXX"
    sleep .75
    echo -e "XXX\n50\n\nAdding Nginx repos... Done.\nXXX"
    sleep .75
    echo -e "XXX\n75\n\nFetch Nginx signing key... \nXXX"
    curl -O https://nginx.org/keys/nginx_signing.key 2> /dev/null &&
    apt-key add ./nginx_signing.key 2> /dev/null &
    sleep .75
    echo -e "XXX\n100\n\nFetch Nginx signing key... Done.\nXXX"
    sleep .75
  } | whiptail --title "Nginx Repo Setup" --gauge "\nAdding Nginx repos" 10 70 0
}

nginxRemove() {
{
    echo -e "XXX\n10\n\nRemoving Nginx signing key...\nXXX"
    rm -rf $CURDIR/nginx_signing.key
    sleep .75
    echo -e "XXX\n25\n\nRemoving Nginx logs... Done.\nXXX"
    rm -rf $NGINXLOGDIR
    sleep .75
    echo -e "XXX\n50\n\nRemoving Nginx cache... Done.\nXXX"
    rm -rf $NGINXCACHEDIR
    sleep .75
    echo -e "XXX\n75\n\nRemoving Nginx repos... \nXXX"
    rm -rf /var/lib/apt/lists/nginx*
    rm -rf /usr/local/lib/x86_64-linux-gnu/perl/*/nginx.pm
    rm -rf /usr/local/lib/x86_64-linux-gnu/perl/*/auto/nginx
    sed -i.bak '/nginx/d' $APT_SOURCES
    sleep .75
    echo -e "XXX\n100\n\nConfiguration preserved @ /etc/nginx... Done.\nXXX"
    sleep 1
  } | whiptail --title "Nginx Remove" --gauge "\nWiping traces of Nginx" 10 70 0
}

nginxPurge() {
{
    echo -e "XXX\n10\n\nRemoving Nginx signing key...\nXXX"
    rm -rf $CURDIR/nginx_signing.key
    sleep .75
    echo -e "XXX\n20\n\nRemoving Nginx configurations... \nXXX"
    rm -rf $NGINXCONFDIR
    sleep .75
    echo -e "XXX\n40\n\nRemoving Nginx logs... Done.\nXXX"
    rm -rf $NGINXLOGDIR
    sleep .75
    echo -e "XXX\n60\n\nRemoving Nginx cache... Done.\nXXX"
    rm -rf $NGINXCACHEDIR
    sleep .75
    echo -e "XXX\n80\n\nRemoving Nginx repos... \nXXX"
    rm -rf /var/lib/apt/lists/nginx*
    rm -rf /usr/local/lib/x86_64-linux-gnu/perl/*/nginx.pm
    rm -rf /usr/local/lib/x86_64-linux-gnu/perl/*/auto/nginx
    sed -i.bak '/nginx/d' $APT_SOURCES
    sleep .75
    echo -e "XXX\n100\n\nAll traces cleaned... Done.\nXXX"
    sleep 1
  } | whiptail --title "Nginx Purge" --gauge "\nWiping traces of Nginx" 10 70 0
}

cleanBuild() {
{
    echo -e "XXX\n10\n\nBacking up Nginx configurations... \nXXX"
    tar cvpfz /nginxconf_backup.tar.gz /etc/nginx/ 2> /dev/null
    if [ ! -d  $CURDIR/backups ]; then
    mkdir $CURDIR/backups
    fi
    mv /nginxconf_backup.tar.gz $CURDIR/backups
    rm -rf $NGINXCONFDIR
    rm -rf /etc/default/nginx
    rm -rf /etc/default/nginx-debug
    sleep .75
    echo -e "XXX\n25\n\nStopping Nginx webserver... Done.\nXXX"
    /etc/init.d/nginx stop 2> /dev/null
    sleep .75
    echo -e "XXX\n37\n\nRemoving Nginx cache... Done.\nXXX"
    rm -rf $NGINXCACHEDIR
    rm -rf /etc/logrotate.d/nginx
    sleep .75
    echo -e "XXX\n51\n\nRemoving Nginx services... \nXXX"
    update-rc.d -f nginx remove
    if [ "$ENABLEDEBUG" -eq "1" ]; then
    update-rc.d -f nginx-debug remove
    rm -rf /etc/systemd/system/multi-user.target.wants/nginx-debug.service
    fi
    rm -rf /etc/init.d/nginx
    rm -rf /etc/init.d/nginx-debug
    rm -rf /etc/systemd/system/multi-user.target.wants/nginx.service
    rm -rf /lib/systemd/system/nginx.service
    rm -rf /lib/systemd/system/nginx-debug.service
    sleep .75
    echo -e "XXX\n65\n\nRemoving Nginx logs... \nXXX"
    rm -rf $NGINXLOGDIR
    sleep .75
    echo -e "XXX\n78\n\nRemoving Nginx modules... \nXXX"
    rm -rf /usr/lib/nginx
    rm -rf /usr/local/lib/x86_64-linux-gnu/perl/*/nginx.pm
    rm -rf /usr/local/lib/x86_64-linux-gnu/perl/*/auto/nginx
    rm -rf /usr/local/share/man/man3/nginx.3pm
    rm -rf /usr/sbin/nginx
    rm -rf /usr/sbin/nginx.old
    rm -rf /usr/share/doc/fcgiwrap/examples/nginx.conf
    rm -rf /var/lib/lxcfs/cgroup/blkio/system.slice/nginx.service
    rm -rf /var/lib/lxcfs/cgroup/cpu,cpuacct/system.slice/nginx.service
    rm -rf /var/lib/lxcfs/cgroup/devices/system.slice/nginx.service
    rm -rf /var/lib/lxcfs/cgroup/memory/system.slice/nginx.service
    rm -rf /var/lib/lxcfs/cgroup/name=systemd/system.slice/nginx.service
    rm -rf /var/lib/lxcfs/cgroup/pids/system.slice/nginx.service
    sleep .75
    echo -e "XXX\n90\n\nRemoving temporary files... \nXXX"
    rm -rf /var/tmp/systemd-private-*-nginx.service-*
    sleep .75
    echo -e "XXX\n100\n\nAll traces cleaned... Done.\nXXX"
    sleep 1
  } | whiptail --title "Nginx Clean Build" --gauge "\nWiping traces of Nginx" 10 70 0
}

extractArchive() {
{
    tar -zxvf $OPENSSL_SOURCE 2> /dev/null
    tar -zxvf $NGINX_SOURCE 2> /dev/null
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep .02
        echo $i
    done
  } | whiptail --title "ASAS Archiver" --gauge "\nExtract archived sources" 10 70 0
}

nginxSourceConfigure() {
{
       ./configure --prefix=$NGINXCONFDIR \
             --sbin-path=/usr/sbin/nginx \
             --modules-path=/usr/lib/nginx/modules \
             --conf-path=$NGINXCONFIG \
             --error-log-path=/var/log/nginx/error.log \
             --http-log-path=/var/log/nginx/access.log \
             --pid-path=/var/run/nginx.pid \
             --lock-path=/var/run/nginx.lock \
             --http-client-body-temp-path=$NGINXCACHEDIR/client_temp \
             --http-proxy-temp-path=$NGINXCACHEDIR/proxy_temp \
             --http-fastcgi-temp-path=$NGINXCACHEDIR/fastcgi_temp \
             --http-uwsgi-temp-path=$NGINXCACHEDIR/uwsgi_temp \
             --http-scgi-temp-path=$NGINXCACHEDIR/scgi_temp \
             --user=$WEB_SERVER_USER \
             --group=$WEB_SERVER_GROUP \
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
             --with-debug \
             --with-threads \
             --with-stream \
             --with-stream_ssl_module \
             --with-stream_geoip_module=dynamic \
             --with-http_slice_module \
             --with-mail \
             --with-mail_ssl_module \
             --with-file-aio \
             --with-http_v2_module \
             --with-openssl=$CURDIR/source/$(basename $OPENSSL_SOURCE .tar.gz) \
             --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
             --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' &>> $CURDIR/$NGINX_LOG/install-$CURDAY.log || errorOperation
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep .03
        echo $i
    done
  } | whiptail --title "ASAS Configure" --gauge "\nRunning configuration [./configure]" 10 70 0
}

nginxMake() {
{
        i="0"
            sudo make &>> $CURDIR/$NGINX_LOG/install-$CURDAY.log || errorOperation &
            sleep 1
            while (true)
            do
            proc=$(ps aux | grep -v grep | grep -e "make")
            if [[ "$proc" == "" ]] && [[ "$i" -eq "0" ]];
            then
                break;
            elif [[ "$proc" == "" ]] && [[ "$i" -gt "0" ]];
            then
                sleep .5
                echo 98
                sleep 1.5
                echo 99
                sleep 1.5
                echo 100
                sleep 2
                break;
            elif [[ "97" -eq "$i" ]]
            then
                i="97"
            fi
            sleep 2.28
            i=$(expr $i + 1)
            printf "XXX\n$i\n\nCompiling Nginx [make]...\nBuild Log:$CURDIR/$NGINX_LOG/install-$CURDAY.log \nXXX\n$i\n"
        done
  } | whiptail --title "ASAS Compiler"  --gauge "\nReady to build Nginx w/ OpenSSL from source\n\nThis is going to take a few minutes" 10 70 0
}

nginxMakeInstall() {
{
       sudo make install &>> $CURDIR/$NGINX_LOG/install-$CURDAY.log || errorOperation &
     for ((i = 0 ; i <= 100 ; i+=25)); do
        sleep 1
        printf "XXX\n$i\n\nInstalling Nginx [make install]... \nXXX\n$i\n"
        done
  } | whiptail --title "ASAS Compiler"  --gauge "\nInstalling Nginx build" 10 70 0
}

nginxServices() {
{
    echo -e "XXX\n5\n\nChecking for Nginx service file...\nXXX"
    if [ -f $NGINXCONFIGSERVICE/nginx.service ]
    then
    echo -e "XXX\n25\n\nNginx service already exists, skipping...\nXXX"
    sleep .75
    else
    echo -e "XXX\n15\n\nCreate Nginx service... \nXXX"
    cp $CURDIR/config/nginx/services/nginx.service $NGINXCONFIGSERVICE 2> /dev/null
    chmod 0644 $NGINXCONFIGSERVICE/nginx.service
    sleep .75
    systemctl enable nginx.service 2> /dev/null
    echo -e "XXX\n25\n\nNginx service file enabled... Done.\nXXX"
    sleep .75
    fi

    echo -e "XXX\n30\n\nChecking for Nginx debug service file...\nXXX"
    if [ -f $NGINXCONFIGSERVICE/nginx-debug.service ]
    then
    echo -e "XXX\n45\n\nNginx debug service already exists, skipping...\nXXX"
    sleep .75
    else
    echo -e "XXX\n35\n\nCreate Nginx debug service... \nXXX"
    cp $CURDIR/config/nginx/services/nginx-debug.service $NGINXCONFIGSERVICE 2> /dev/null
    chmod 0644 $NGINXCONFIGSERVICE/nginx-debug.service
    sleep .75
    fi
    if [ "$ENABLEDEBUG" -eq "1" ]; then
    systemctl enable nginx-debug.service 2> /dev/null
    echo -e "XXX\n45\n\nNginx debug service file enabled... Done.\nXXX"
    sleep .75
    else
    echo -e "XXX\n45\n\nNginx debug service file not enabled... Done.\nXXX"
    sleep .75
    fi

    echo -e "XXX\n50\n\nChecking for Nginx init.d file...\nXXX"
    if [ -f $NGINX_INIT ]
    then
    echo -e "XXX\n65\n\nNginx init.d already exists, skipping...\nXXX"
    sleep .75
    else
    echo -e "XXX\n55\n\nCreate Nginx init.d service... \nXXX"
    cp $CURDIR/config/nginx/init.d/nginx $CONFIGINITDDIR 2> /dev/null
    chmod 755 $NGINX_INIT
    echo -e "XXX\n60\n\nNginx init.d file installed... Done.\nXXX"
    sleep .75
    update-rc.d nginx defaults 2> /dev/null
    echo -e "XXX\n65\n\nNginx init.d file enabled... Done.\nXXX"
    sleep .75
    fi

    echo -e "XXX\n70\n\nChecking for Nginx init.d debug file...\nXXX"
    if [ -f $NGINX_INIT-debug ]
    then
    echo -e "XXX\n80\n\nNginx init.d debug already exists, skipping...\nXXX"
    sleep .75
    else
    echo -e "XXX\n75\n\nCreate Nginx init.d debug file... \nXXX"
    cp $CURDIR/config/nginx/init.d/nginx-debug $CONFIGINITDDIR 2> /dev/null
    chmod 755 $NGINX_INIT-debug
    echo -e "XXX\n80\n\nNginx init.d debug file installed... Done.\nXXX"
    sleep .75
    fi
    if [ "$ENABLEDEBUG" -eq "1" ]; then
    update-rc.d nginx-debug defaults 2> /dev/null
    echo -e "XXX\n85\n\nNginx init.d debug file enabled... Done.\nXXX"
    sleep .75
    else
    echo -e "XXX\n85\n\nNginx init.d debug file not enabled... Done.\nXXX"
    sleep .75
    fi

    echo -e "XXX\n90\n\nCreate Nginx logrotate.d service... \nXXX"
    cp $CURDIR/config/nginx/logrotate.d/nginx $CONFIGLOGROTDIR 2> /dev/null
    chown root:root $CONFIGLOGROTDIR/nginx
    sleep .75
    echo -e "XXX\n95\n\nCreate Nginx defaults... \nXXX"
    cp $CURDIR/config/nginx/default/nginx $NGINXDEFAULTDIR 2> /dev/null
    cp $CURDIR/config/nginx/default/nginx-debug $NGINXDEFAULTDIR 2> /dev/null
    chown root:root $NGINXDEFAULTDIR/nginx*
    sleep .75
    echo -e "XXX\n100\n\nNginx services installed... Done.\nXXX"
    sleep .75
  } | whiptail --title "Nginx Services" --gauge "\nCreating service files for Nginx" 10 70 0
}

nginxConfigure() {
{
    echo -e "XXX\n7\n\nMaking backup of default nginx.conf...\nXXX"
    sleep .75
    if [ -f $NGINXCONFIG.bak ]
    then
    echo -e "XXX\n7\n\nBackup already exists, skipping nginx.conf...\nXXX"
    sleep .75
    else
    mv $NGINXCONFIG $NGINXCONFIG.bak
    echo -e "XXX\n13\n\nInstalling optimized nginx.conf...\nXXX"
    sleep .75
    cp $CURDIR/config/nginx/nginx/nginx.conf $NGINXCONFDIR 2>/dev/null
    echo -e "XXX\n15\n\nInstalled optimized nginx.conf...\nXXX"
    sleep .75
    fi
    echo -e "XXX\n20\n\nCreate $NGINX_SITES_AVAILABLE if doesnt exist...\nXXX"
    sleep .75
    if [ -d "$NGINX_SITES_AVAILABLE" ]
    then
    echo -e "XXX\n26\n\nDirectory $NGINX_SITES_AVAILABLE exists...\nXXX"
    sleep .75
    else
    mkdir -p $NGINX_SITES_AVAILABLE
    echo -e "XXX\n26\n\nDirectory $NGINX_SITES_AVAILABLE created...\nXXX"
    sleep .75
    fi
    echo -e "XXX\n35\n\nCreate nginx $NGINX_SITES_ENABLED if doesnt exist...\nXXX"
    sleep .75
    if [ -d "$NGINX_SITES_ENABLED" ]
    then
    echo -e "XXX\n43\n\nDirectory $NGINX_SITES_ENABLED exists...\nXXX"
    sleep .75
    else
    mkdir -p $NGINX_SITES_ENABLED
    echo -e "XXX\n43\n\nDirectory $NGINX_SITES_ENABLED created...\nXXX"
    sleep .75
    fi
    echo -e "XXX\n56\n\nCreate nginx $NGINX_CONFDDIR if doesnt exist...\nXXX"
    sleep .75
    if [ -d "$NGINX_CONFDDIR" ]
    then
    echo -e "XXX\n65\n\nDirectory $NGINX_CONFDDIR exists...\nXXX"
    sleep .75
    else
    mkdir -p $NGINX_CONFDDIR
    echo -e "XXX\n65\n\nDirectory $NGINX_CONFDDIR created...\nXXX"
    sleep .75
    fi
    echo -e "XXX\n73\n\nCreate nginx vhosts.conf if doesnt exist...\nXXX"
    sleep .75
    if [ -f $NGINXVHOSTCONF ]
    then
    echo -e "XXX\n82\n\nGreat! vhosts.conf file exists...\nXXX"
    sleep .75
    else
    touch $NGINXVHOSTCONF
    echo "include $NGINX_SITES_ENABLED/*.vhost;" >>$NGINXVHOSTCONF
    echo -e "XXX\n82\n\nFile vhosts.conf created...\nXXX"
    sleep .75
    fi
    echo -e "XXX\n91\n\nCreate nginx cache/gzip directories if doesnt exist...\nXXX"
    sleep .75
    if [ -d $NGINXCACHEDIR ]
    then
    echo -e "XXX\n93\n\nGreat! Cache directories exist...\nXXX"
    sleep .75
    else
    mkdir -p $NGINXCACHEDIR
    mkdir -p $NGINXCACHEDIR/client_temp
    mkdir -p $NGINXCACHEDIR/fastcgi_temp
    mkdir -p $NGINXCACHEDIR/fastcgi_cache
    mkdir -p $NGINXCACHEDIR/proxy_temp
    mkdir -p $NGINXCACHEDIR/scgi_temp
    mkdir -p $NGINXCACHEDIR/uwsgi_temp
    chown -R $WEB_SERVER_USER:$WEB_SERVER_GROUP $NGINXCACHEDIR
    echo -e "XXX\n93\n\nNginx cache directories created...\nXXX"
    sleep .75
    fi
    echo -e "XXX\n98\n\nRestarting Nginx service... Done.\nXXX"
    sleep 1.50
    $NGINX_INIT restart 2> /dev/null
    if [ $? -eq 0 ]; then
    ngxstart=$(systemctl status nginx.service 2>&1)
    echo -e "Build date: $DATE_TIME\n\n$ngxstart" > $CURDIR/$NGINX_LOG/nginx-$CURDAY.log
    echo -e "XXX\n100\n\nSuccessfully restarted Nginx... Done.\nXXX"
    sleep 1
    else
    ngxfail=$(systemctl status nginx.service 2>&1)
    echo "Build date: $DATE_TIME\n\n$ngxfail" > $CURDIR/$NGINX_LOG/error-$CURDAY.log
    echo -e "XXX\n99\n\nNginx failed, check $CURDIR/$NGINX_LOG...\nXXX"
    sleep 3
    exit 1
    fi
    sleep 1
  } | whiptail --title "Nginx Setup" --gauge "\nNginx directory and configuration" 10 70 0
}

nginxRestart() {
{
    $NGINX_INIT restart 2> /dev/null
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
    echo -e "XXX\n100\n\nSuccessfully restarted Nginx... Done.\nXXX"
    sleep 1
    else
    echo -e "XXX\n100\n\nNginx failed, check $NGINXLOGDIR/error.log\nScript exiting in 3 seconds...\nXXX"
    sleep 3
    exit 1
    fi
    sleep 1
  } | whiptail --title "Restart Nginx" --gauge "\nRestarting the Nginx service" 10 70 0
}

nginxCleanup() {
{
    sleep .50
    echo -e "XXX\n25\n\nRemoving source directory... \nXXX"
    cd $CURDIR
    rm -rf source
    sleep .75
    echo -e "XXX\n50\n\nSource removed... Done.\nXXX"
    rm -rf source
    sleep .75
    echo -e "XXX\n75\n\nCreate .build file... \nXXX"
     if [ -f $NGINXCONFDIR/.build-* ]
      then
     rm -rf $NGINXCONFDIR/.build-*
     touch $NGINXCONFDIR/.build-$CURDAY
    else
       touch $NGINXCONFDIR/.build-$CURDAY
     fi
    sleep .75
    nginxbuild=$(nginx -V 2>&1)
    echo -e "Build date: $DATE_TIME\n$nginxbuild" > $NGINXCONFDIR/.build-$CURDAY
    sleep .75
    echo -e "XXX\n100\n\n.build file written... Done.\nXXX"
    sleep .75
  } | whiptail --title "Nginx Cleanup" --gauge "\nStarting Nginx cleanup" 10 70 0
}


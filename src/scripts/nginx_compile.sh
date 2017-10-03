#!/bin/bash
#################################################################################
#                   *** ASAS 2.10 [Auto Server Admin Script] ***                #
#        @author: GCornell for devCU Software Open Source Projects              #
#        @contact: gacornell@devcu.com                                          #
#        $OS: Debian Core (Tested on Ubuntu 14x -> 17x / Debian 7.x -> 9.x)     #
#        $MAIN: https://www.devcu.com                                           #
#        $SOURCE: https://github.com/GaalexxC/ASAS                              #
#        $REPO: https://www.devcu.net                                           #
#        +Created:   06/15/2016 Ported from nginxubuntu-php7                    #
#        &Updated:   10/03/2017 03:45 EDT                                       #
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
        echo -e "\nCheck for system updates and install dependencies\n"
        apt -qq update && \
        apt upgrade -y && \
        apt install build-essential libpcre3 libpcre3-dev zlib1g-dev libxslt1-dev libgd-dev libgeoip-dev libperl-dev libssl-dev fcgiwrap -y && \
        mkdir source/ && \
        pushd source/ && \
        echo -e "\nLets build Nginx...\n" && \
        wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz && \
        wget http://nginx.org/download/nginx-1.13.5.tar.gz && \
        tar -zxvf openssl-1.1.0f.tar.gz && \
        tar -zxvf nginx-1.13.5.tar.gz && \
        pushd nginx-1.13.5/ && \
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
                    --user=nginx --group=nginx \
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
                    --with-openssl=../openssl-1.1.0f \
                    --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
                    --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' && \
        make && \
        make install && \
        echo -e "\nCleanup the mess..." && \
        popd; popd && \
        rm -rf source && \
        sudo update-grub && \
        sudo apt -qq autoremove && \
        sudo apt -qq autoclean && \
        echo "" && \
        nginx -V && \
        echo -e "\nNginx installed successfully, configuration begins in 3 seconds\n" && \
        sleep 3 && \
        return

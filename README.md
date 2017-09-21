<<<<<<< HEAD
![License](https://img.shields.io/badge/License-GNUv3-blue.svg)  ![Version](https://img.shields.io/badge/Version-2.10-blue.svg)  ![Development](https://img.shields.io/badge/Development-Active-blue.svg)

```diff
- THIS IS AN INCOMPLETE DEVELOPMENT TEST VERSION AND SHOULD NOT BE USED IN ANY ENVIRONMENT YET!!!
```
# Auto Server Admin Script [ASAS] 2.10

<pre>
    .-"^`\                                        /`^"-.
  .'   ___\                                      /___   `.
 /    /.---.                                    .---.\    \
|    //     '-.  ___________________________ .-'     \\    |
|   ;|         \/--------------------------//         |;   |
\   ||       |\_)      devCU Software      (_/|       ||   /
 \  | \  . \ ;  |         Presents         || ; / .  / |  /
  '\_\ \\ \ \ \ |                          ||/ / / // /_/'
        \\ \ \ \| Auto Server Admin Script |/ / / //
         `'-\_\_\         ASAS 2.10        /_/_/-'`
                '--------------------------'
</pre>

A bash script that automates Nginx, PHP5x/7x, PHP-FPM Setup, MySQL, Bind9 DNS, vsFTPd and User/Domain setup in a couple minutes. For new/fresh servers, existing servers, and local servers (development). Can be used to add new users / domains and home / application directory structures anytime.

Uses a standard default $HOME/$USER/public_html directory structure but can be edited for any type directory structure of choice

## Dime a dozen! So why this one?

Yes there are many of these scripts out there so why is this one different? Well anyone can bash code "apt install nginx" but the majority do not actually install the application to a working, secure, and efficient state. Installing binaries is not installing a program, the configuring and securing of the application is what makes it function in an installed state. So most of these scripts are worthless to those who need to get things up and running asap. Calling on my 15 years of experience as a server admininstrator my script includes all the necessary directory structure creation, all the optimized configuration files needed to run the program efficiently, all the security aspects needed to run the application safely, all the correct permissions and paths are set, as well as anything else that needs attention in order to complete the software for instant access to you web upon completion of the scripts run. This is a complete solution for thse whos time is better spent developing or getting their site online as oppposed to running dozens of additional commands in the console.

### New Major Version v2.10

#### New Menu Options

ASAS uses Whiptail GUI and is installed by default on most debian based systems.
If applicable, dependencies will be installed by script automagically.

  1. Nginx Installer (Stable/Mainline/Compiled)
  2. PHP Installer (PHP5x - PHP7x)
  3. MySQL Installer (Percona-MariaDB-Oracle)
  4. Bind9 DNS Installer (Configure-Secure)
  5. vsFTPd Installer (Configure-Secure)
  6. Mail Server Installer (Postfix-Dovecot)
  7. Quick Web User & Domain Setup
  8. Security Tools
  9. System Tools
  10. Exit
 
#### OS Compatibility
- Ubuntu Server 12.04 / 14.04 / 16.04 / 16.10 / 17.04
- Debian 8, 9
 
#### Added Custom Compile Nginx
- Custom compile latest Nginx mainline with latest OpenSSL. Get the latest security enhancements and features as well as add your own custom modules when building Nginx.
Install will create all necessary directories, service scripts, and update all configuration files.
NOTE: Best when installed on a new system, do not install with nginx installed via apt.
Also when using this method you must run the compiler option (2) each time you update your Nginx version.

#### Added Local Server support
- Changed the way port and server is added to the nginx vhost file. 
  * Added a port specification configuration for the vhost so you can choose something like 8080 /8081 for a local server or use the standard port 80 for remote server in order to access via web.
  * Added server hostname configuration to the vhost so you can choose something like devserver or appserver for a local development server [(IE Hyper-V-Win 10-Ubuntu devServer)](https://github.com/GaryCornell/Win-10-Hyper-V-Ubuntu-16.x-Perfect-Dev-Server) or use the standard domain.com for remote server.

#### New directory setup
You can now use any type of home directory and DocumentRoot setup imaginable with no editing of variables.
IE /home /home2 /var /usr/local | public_html, www, htdocs, sites, wwwroot, httpdocs ...etc
  
#### Added Quick System Cleanup
Cleans up the repo sources, temp files, old logs and safely remove older kernels not in use to free up critical space on your box.  

#### Added Logging
Debug, Error, Info logging

#### Added Backup functions
Database, Home DIR, Custom files and directories

#### New Software Install Options

- Added vsFTPd install and configure
- Added Oracle MySQL Server install and configure
- Added MariaDB Server install and configure
- Added Bind9 DNS Server install and configure
- Added Nginx Stable Web Server install and configure

## Functions

- Setup/Create Nginx directory structure, sites_available / sites_enabled / domain.vhost conf / conf.d (if doesnt exist)

- Updates cgi.fix_pathinfo=0 in fpm and cli php.ini and disables dangerous PHP functions (if doesnt exist)

- Optional my.cnf optimization for MySQL Server

- Setup/Create php-fpm directory structure, domain.conf

- Setup/Create user/pass with domain/IP or hostname/port for local server with public/web directory structure

- Setup/Create Nginx gzip mime types and relevant cache directories (editable in nginx.conf)

- Sets all proper permissions on relevant directories.

- Restarts services

- Adds index.php skel to public directory


### Creates the following $HOME directory structure

The script by default uses the following structure but can be edited to accomadate any type setup IE /var/www , /var/htdocs, etc.

* $HOME
    * $USER
        * _sessions
        * backups
        * logs
        * public_html
             * index.php
        * ssl
        
        
## Editable

See [/src/variables.conf](https://github.com/GaryCornell/Nginx-Ubuntu-for-PHP7/blob/dev-210/src/variables.conf) for editable fields

## Simple Usage as root

1. cd /opt  (Any directory you choose is fine)

2. wget https://github.com/GaryCornell/nginxubuntu-php7/archive/2.10.tar.gz

3. tar xvpfz 2.10.tar.gz

4. cd nginxubuntu-php7-2.10/src/

5. chmod u+x auto_server.sh

6. ./auto_server.sh

7. Just follow the prompts

8. The Nginx vhost file is updated with the latest security features for SSL if using a cert you must uncomment and make sure paths are correct. The script sets up the standard path $HOME/$USER/ssl to .crt/.key/trusted_chain.pem but of course you must supply the files. Root path/logs path/php-fpm unix socket and sessions paths are setup and work out of the box for you but can be edited for custom paths.

9. Once completed:
Local Server: Go to your sites web address (EX: http://loacalhost:8080 ) and start building immediately!
Remote Server: if your DNS is setup then you can access your site immediately (EX: http://www.domain.com )

## Proposed Additions (All optional)
- ~~Percona MySQL 5.7 Server setup~~ Added 2.03
- ~~Oracle MySQL Server setup~~ Added 2.10
- ~~MariaDB Server setup~~ Added 2.10
- ~~Bind9 DNS fully configured and ready to go~~ Added 2.10
- ~~Postfix/Dovecot mail server with all the bells and whistles~~ Added 2.10
- ~~vsftpd setup and configuration~~ Added 2.10
- More? >:

## License

GNU General Public License v3.0

## Development / Contribute

Further development is planned but any serious functionality issues or security issues will be addressed immediately if discovered by me or reported by users. I welcome code efficiency and optimization comments. I have extensive knowledge in server setup, security and optimization, whatever makes it easier is my moto. The issue is not if I can its if I have the time to...

## PHP5 User?

Use the PHP5 Ubuntu 12x | 14x version [nginxubuntu-php5](https://github.com/GaryCornell/nginxubuntu-php5)

## Copyrights

Created by Gary Cornell for devCU Software ©2017
=======
![License](https://img.shields.io/badge/License-GNUv3-blue.svg)  ![Version](https://img.shields.io/badge/Version-2.10-blue.svg)  ![Development](https://img.shields.io/badge/Development-Active-blue.svg)

```diff
- THIS IS AN INCOMPLETE DEVELOPMENT TEST VERSION AND SHOULD NOT BE USED IN ANY ENVIRONMENT YET!!!
```
# Auto Server Admin Script [ASAS] 2.10

<pre>
    .-"^`\                                        /`^"-.
  .'   ___\                                      /___   `.
 /    /.---.                                    .---.\    \
|    //     '-.  ___________________________ .-'     \\    |
|   ;|         \/--------------------------//         |;   |
\   ||       |\_)      devCU Software      (_/|       ||   /
 \  | \  . \ ;  |         Presents         || ; / .  / |  /
  '\_\ \\ \ \ \ |                          ||/ / / // /_/'
        \\ \ \ \| Auto Server Admin Script |/ / / //
         `'-\_\_\         ASAS 2.10        /_/_/-'`
                '--------------------------'
</pre>

A bash script that automates Nginx, PHP5x/7x, PHP-FPM Setup, MySQL, Bind9 DNS, vsFTPd and User/Domain setup in a couple minutes. For new/fresh servers, existing servers, and local servers (development). Can be used to add new users / domains and home / application directory structures anytime.

Uses a standard default $HOME/$USER/public_html directory structure but can be edited for any type directory structure of choice

## Dime a dozen! So why this one?

Yes there are many of these scripts out there so why is this one different? Well anyone can bash code "apt install nginx" but the majority do not actually install the application to a working, secure, and efficient state. Installing binaries is not installing a program, the configuring and securing of the application is what makes it function in an installed state. So most of these scripts are worthless to those who need to get things up and running asap. Calling on my 15 years of experience as a server admininstrator my script includes all the necessary directory structure creation, all the optimized configuration files needed to run the program efficiently, all the security aspects needed to run the application safely, all the correct permissions and paths are set, as well as anything else that needs attention in order to complete the software for instant access to you web upon completion of the scripts run. This is a complete solution for thse whos time is better spent developing or getting their site online as oppposed to running dozens of additional commands in the console.

### New Major Version v2.10

#### New Menu Options

ASAS uses Whiptail GUI and is installed by default on most debian based systems.
If applicable, dependencies will be installed by script automagically.

  1. Nginx Installer (Stable/Mainline/Compiled)
  2. PHP Installer (PHP5x - PHP7x)
  3. MySQL Installer (Percona-MariaDB-Oracle)
  4. Bind9 DNS Installer (Configure-Secure)
  5. vsFTPd Installer (Configure-Secure)
  6. Mail Server Installer (Postfix-Dovecot)
  7. Quick Web User & Domain Setup
  8. Security Tools
  9. System Tools
  10. Exit
 
#### OS Compatibility
- Ubuntu Server 12.04 / 14.04 / 16.04 / 16.10 / 17.04
- Debian 8, 9
 
#### Added Custom Compile Nginx
- Custom compile latest Nginx mainline with latest OpenSSL. Get the latest security enhancements and features as well as add your own custom modules when building Nginx.
Install will create all necessary directories, service scripts, and update all configuration files.
NOTE: Best when installed on a new system, do not install with nginx installed via apt.
Also when using this method you must run the compiler option (2) each time you update your Nginx version.

#### Added Local Server support
- Changed the way port and server is added to the nginx vhost file. 
  * Added a port specification configuration for the vhost so you can choose something like 8080 /8081 for a local server or use the standard port 80 for remote server in order to access via web.
  * Added server hostname configuration to the vhost so you can choose something like devserver or appserver for a local development server [(IE Hyper-V-Win 10-Ubuntu devServer)](https://github.com/GaryCornell/Win-10-Hyper-V-Ubuntu-16.x-Perfect-Dev-Server) or use the standard domain.com for remote server.

#### New directory setup
You can now use any type of home directory and DocumentRoot setup imaginable with no editing of variables.
IE /home /home2 /var /usr/local | public_html, www, htdocs, sites, wwwroot, httpdocs ...etc
  
#### Added Quick System Cleanup
Cleans up the repo sources, temp files, old logs and safely remove older kernels not in use to free up critical space on your box.  

#### Added Logging
Debug, Error, Info logging

#### Added Backup functions
Database, Home DIR, Custom files and directories

#### New Software Install Options

- Added vsFTPd install and configure
- Added Oracle MySQL Server install and configure
- Added MariaDB Server install and configure
- Added Bind9 DNS Server install and configure
- Added Nginx Stable Web Server install and configure

## Functions

- Setup/Create Nginx directory structure, sites_available / sites_enabled / domain.vhost conf / conf.d (if doesnt exist)

- Updates cgi.fix_pathinfo=0 in fpm and cli php.ini and disables dangerous PHP functions (if doesnt exist)

- Optional my.cnf optimization for MySQL Server

- Setup/Create php-fpm directory structure, domain.conf

- Setup/Create user/pass with domain/IP or hostname/port for local server with public/web directory structure

- Setup/Create Nginx gzip mime types and relevant cache directories (editable in nginx.conf)

- Sets all proper permissions on relevant directories.

- Restarts services

- Adds index.php skel to public directory


### Creates the following $HOME directory structure

The script by default uses the following structure but can be edited to accomadate any type setup IE /var/www , /var/htdocs, etc.

* $HOME
    * $USER
        * _sessions
        * backups
        * logs
        * public_html
             * index.php
        * ssl
        
        
## Editable

See [/src/variables.conf](https://github.com/GaryCornell/Nginx-Ubuntu-for-PHP7/blob/dev-210/src/variables.conf) for editable fields

## Simple Usage as root

1. cd /opt  (Any directory you choose is fine)

2. wget https://github.com/GaryCornell/nginxubuntu-php7/archive/2.10.tar.gz

3. tar xvpfz 2.10.tar.gz

4. cd nginxubuntu-php7-2.10/src/

5. chmod u+x auto_server.sh

6. ./auto_server.sh

7. Just follow the prompts

8. The Nginx vhost file is updated with the latest security features for SSL if using a cert you must uncomment and make sure paths are correct. The script sets up the standard path $HOME/$USER/ssl to .crt/.key/trusted_chain.pem but of course you must supply the files. Root path/logs path/php-fpm unix socket and sessions paths are setup and work out of the box for you but can be edited for custom paths.

9. Once completed:
Local Server: Go to your sites web address (EX: http://loacalhost:8080 ) and start building immediately!
Remote Server: if your DNS is setup then you can access your site immediately (EX: http://www.domain.com )

## Proposed Additions (All optional)
- ~~Percona MySQL 5.7 Server setup~~ Added 2.03
- ~~Oracle MySQL Server setup~~ Added 2.10
- ~~MariaDB Server setup~~ Added 2.10
- ~~Bind9 DNS fully configured and ready to go~~ Added 2.10
- ~~Postfix/Dovecot mail server with all the bells and whistles~~ Added 2.10
- ~~vsftpd setup and configuration~~ Added 2.10
- More? >:

## License

GNU General Public License v3.0

## Development / Contribute

Further development is planned but any serious functionality issues or security issues will be addressed immediately if discovered by me or reported by users. I welcome code efficiency and optimization comments. I have extensive knowledge in server setup, security and optimization, whatever makes it easier is my moto. The issue is not if I can its if I have the time to...

## PHP5 User?

Use the PHP5 Ubuntu 12x | 14x version [nginxubuntu-php5](https://github.com/GaryCornell/nginxubuntu-php5)

## Copyrights

Created by Gary Cornell for devCU Software ©2017
>>>>>>> origin/HEAD
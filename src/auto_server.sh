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
#        &Updated:   10/31/2017 00:31 EDT                                       #
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
# --------------START SOURCES
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
set -o allexport
source config/user_vars.conf
source config/server_vars.conf
source functions/functions.sh
# --------------END SOURCES
asd() {
cat <<"EOT"

    .-"^`\                                        /`^"-.
  .'   ___\                                      /___   `.
 /    /.---.                                    .---.\    \
|    //     '-.  ___________________________ .-'     \\    |
|   ;|         \/--------------------------//         |;   |
\   ||       |\_)      devCU Software      (_/|       ||   /
 \  | \  . \ ;  |   Open Source Projects   || ; / .  / |  /
  '\_\ \\ \ \ \ |                          ||/ / / // /_/'
        \\ \ \ \| Auto Server Admin Script |/ / / //
         `'-\_\_\         ASAS 2.10        /_/_/-'`
                '--------------------------'
EOT
}

asd

    echo -e "\nWelcome to Auto Server Admin Script [ASAS] 2.10\n"

    echo -e "Installer Version: ${BLUE}$INSTALLER_VERSION${NOCOL}"
    echo -e "Installer Revision: ${BLUE}$INSTALLER_REVISION${NOCOL}"
    echo -e "Installer MD5: ${BLUE}$INSTALLER_MD5${NOCOL}\n"
    sleep 1

    echo "*******************************************************************"
    echo "*       Licensed under the GNU General Public License v3.0        *"
    echo "* You are permitted to use this script for commercial and private *"
    echo "* use. You may modify, distribute, and use this application for   *"
    echo "* patent use. This program comes with ABSOLUTELY NO WARRANTY      *"
    echo "* and we assume NO LIABILITY. Use at your own risk.               *"
    echo "*******************************************************************"

    whiptailInstallCheck

    read -p "Press [Enter] to begin system check..."

    validateRoot
    systemDetect
    pkgcache() {
       printf "apt update"
    }
    updateSources
    systemUpgrades

    asasMainMenu

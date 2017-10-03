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
clear

#MySQL Install Menu

while [ 2 ]
do

SELECTMYSQL=$(
whiptail --title "MySQL Server Installer" --radiolist "\nUse up/down arrows and tab to select a MySQL Server" 15 60 4 \
        "1)" "Percona MySQL Server 5.7 (Recommended)" ON \
        "2)" "MariaDB MySQL Server 10.2" OFF \
        "3)" "Oracle MySQL Server 5.7" OFF \
        "4)" "Return to Main Menu"  OFF 3>&1 1>&2 2>&3
)


case $SELECTMYSQL in
        "1)")

      echo "Option 1 Selected: Percona MySQL Server 5.7"
      echo "Are you sure you want to install Percona MySQL Server 5.7 (y/n)"
      read CHECKPERCONAMYSQL
   if [ $CHECKPERCONAMYSQL == "y" ]; then
# Install Percona MySQL
      mkdir repos/
      pushd repos/
      echo -e "\nInstalling Percona MySQL server 5.7"
      echo -e "\nFetching and installing Percone repo sources list"
      wget $PERCONA_MYSQL
      sudo dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb
      sudo apt -qq update
      echo -e "\nInstalling Percone Mysql Server 5.7"
      sudo apt install percona-server-server-5.7 -y
      echo -e "\nPercone Mysql Server 5.7 Installed\n"
      popd
      rm -rf repos
      $MYSQL_INIT
# Install Percona MySQL Optimized my.cnf
      echo "Do you want to install an optimized my.cnf [recommended for Percona MySQL ONLY] (y/n)"
      read CHECKPERCONAMYSQLCNF
   if [ $CHECKPERCONAMYSQLCNF == "y" ]; then
      echo -e "\nMaking backup my.cnf"
      sudo mv /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
      echo -e "\nOptimizing my.cnf"
      CONFIGMYSQLCNF=$MYSQL_MYCNF
      cp config/mysql/my.cnf.percona $CONFIGMYSQLCNF
      #mv /etc/mysql/my.cnf.percona /etc/mysql/my.cnf
      $MYSQL_INIT
      echo -e "\nmy.cnf optimized\n"
      read -p "Press [Enter] key to return to main menu..."
      return
   else
      echo -e "\nSkipping my.cnf Optimization\n"
      read -p "Press [Enter] key to return to main menu..."
      return
   fi
   else
      echo -e "\nSkipping Percona MySQL install\n"
      read -p "Press [Enter] key to return to main menu..."
      return
   fi

        ;;

        "2)")

      echo "Option 2 Selected: MariaDB MySQL Server 10.2"
      echo "Are you sure you want to install MariaDB MySQL Server 10.2 (y/n)"
      read CHECKMARIADBMYSQL
   if [ $CHECKMARIADBMYSQL == "y" ]; then
# Install MariaDB MySQL
      echo -e "\nFetching and installing MariaDB repo sources list"
      sudo apt install software-properties-common -y
      sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
      sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirrors.syringanetworks.net/mariadb/repo/10.2/ubuntu xenial main'
      sudo apt -qq update
      echo -e "\nInstalling MariaDB MySQL Server 10.2"
      sudo apt install mariadb-server -y
      echo -e "\nMariaDB MySQL Server 10.2 Installed\n"
      rm -rf repos
      $MYSQL_INIT
      echo
      read -p "Press [Enter] key to return to main menu..."
      return
  else
      echo -e "\nSkipping MariaDB MySQL install\n"
      read -p "Press [Enter] key to return to main menu..."
      return
  fi
        ;;

        "3)")

      echo "Option 3 Selected: Oracle MySQL Server 5.7"
      echo "Are you sure you want to install Oracle MySQL Server 5.7 (y/n)"
      read CHECKORACLEMYSQL
   if [ $CHECKORACLEMYSQL == "y" ]; then
# Install Oracle MySQL
      mkdir repos/
      pushd repos/
      echo -e "\nFetching and installing Percone repo sources list"
      wget $ORACLE_MYSQL
      sudo dpkg -i mysql-apt-config_0.8.7-1_all.deb
      apt -qq update
      echo -e "\nInstalling Oracle MySQL Server 5.7"
      apt install mysql-server -y
      echo -e "\nOracle Mysql Server 5.7 Installed\n"
      popd
      rm -rf repos
      $MYSQL_INIT
      echo
      read -p "Press [Enter] key to return to main menu..."
      return
  else
      echo -e "\nSkipping Oracle MySQL install\n"
      read -p "Press [Enter] key to return to main menu..."
      return
  fi
        ;;

        "4)")

      return
        ;;

esac

done
exit

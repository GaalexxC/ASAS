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

  if [ -f /var/run/reboot-required ]; then
    rebootRequired
  fi

echo -e "\nChecking for old kernels\n"

sudo update-grub

echo -e "\nCleaning old kernels\n"

sudo dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge

echo -e "\nCleaning old packages\n"

sudo apt autoremove

sudo apt autoclean

echo -e "\nUpdate kernel\n"

sudo update-grub

echo -e "\nCleaning archived logs\n"

rm -rf /var/log/*.tar.gz
rm -rf /var/log/nginx/*.tar.gz
rm -rf /var/log/mysql/*.tar.gz

echo -e "\nCleanup Complete\n"
sleep 1

  if [ -f /var/run/reboot-required ]; then
    ArebootRequired
  else
    completeOperation
  fi

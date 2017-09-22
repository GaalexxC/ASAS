#!/bin/bash
# ASAS 2.10
# @author: GCornell for devCU Software
# @contact: support@devcu.com
# Compatibility: Debian Core Systems (Tested on Ubuntu 12-14-16-17 & Debian 8/9)
# MAIN: https://www.devcu.com  https://www.devcu.net https://www.exceptionalservers.com
# REPO: https://github.com/GaryCornell/Auto-Server-Installer
# License: GNU General Public License v3.0
# Created:   06/15/2016
# Updated:   09/22/2017

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

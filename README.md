![devCUHead](https://www.devcu.com/mediasrc/github-banner.png?V=1.0)

[![License](https://img.shields.io/badge/License-GNUv3-blue.svg)](https://github.com/GaalexxC/ASAS/blob/master/LICENSE) 
[![Version](https://img.shields.io/badge/Version-2.1.0-ff69b4.svg)](https://www.devcu.com/devcu-tracker/)
[![Build](https://img.shields.io/badge/Build-08092020-yellow.svg)](https://www.devcu.com/devcu-tracker/)
[![Status](https://img.shields.io/badge/Status-PreRelease-active.svg)](https://www.devcu.com/devcu-tracker/)
[![Development](https://img.shields.io/badge/Development-Active-success.svg)](https://www.devcu.com/devcu-tracker/)
[![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.devcu.com/devcu-tracker/)
[![GitHub last commit (branch)](https://img.shields.io/github/last-commit/GaalexxC/ASAS/master.svg)](https://www.devcu.com/devcu-tracker/)


## ** Become a Patron/Supporter of devCU **
	
**Please support our Open Source Projects and keep this software free**

- Donators have access to Beta and Release version up to 2 weeks before the public

[![donate](https://www.devcu.com/mediasrc/support_devcu.png?v=1)](https://www.devcu.com/clients/donations/)


More info: [Current dev state](https://github.com/GaalexxC/ASAS/wiki/Current-State)

# Auto Server Admin Script [ASAS] 2.10

<pre>
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
</pre>

- Bash script that automates basic Linux sysadmin tasks...
See the [Wiki for more info and usage](https://github.com/GaalexxC/ASAS/wiki)

## Pre Release Limited Function Available For Testing

<img src="https://www.devcu.com/mediasrc/asascompile.PNG?V=1.8" width="100%"></img>

Install & Run as root (Updated release 12/01/21)

- PHP 7.2, 7.3, and 7.4 (Default)
- Percona MySQL 8.26x
- MariaDB MySQL 10.x
- Oracle MySQL 8.x
- Nginx 1.21.4
- OpenSSL 1.1.1l
- Supported Ubuntu 18+ and Debian 9+


```bash
# cd /
# wget https://www.devcu.com/mediasrc/ASAS120121_MASTER.tar.gz
# tar xvpfz ASAS120121_MASTER.tar.gz
# rm /ASAS120121_MASTER.tar.gz
# cd /opt
# ./auto_server.sh
```

## User Editable - Set versions, php programs, users, directories, etc.
- config/user_vars.conf
- config/server_vars.conf

## License

GNU General Public License v3.0

## Development / Contribute

Pre-Release Development [Current dev state](https://github.com/GaalexxC/ASAS/wiki/Current-State)

Issue Tracker - Home [Issue Tracker - Home](https://www.devcu.com/forums/devcu-tracker/asas/)

## Thanks!

- Microsoft

Ironically, to a Windows OS for allowing me to test all these great releases in a pure Linux environment. Windows 10 Hyper-V, 5 containers, all rsync synchronized for rapid updates and development. if you are still using archaic apps like Cygwin based applications (XAMPP, WinLAMP, AMPPS) then you havent got a clue.
- Café Bustelo

For obvious reasons...:coffee:

## Jeers!

- Debian Developers

For not fully embracing apt and removing update-notifier

## Copyrights

Created by GCornell for devCU Software ©2020

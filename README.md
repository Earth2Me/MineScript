MineScript
==========

Copyright (c) 2013-2014 Paul Buonopane.  All rights reserved.  Earth2Me, Zenexer, and MineScript are trademarks of Paul Buonopane.

Installation
============

*Do not edit or remove any example files if you want updates.*

~~~ bash
git clone git://github.com/Earth2Me/MineScript.git ~/minescript
sudo mkdir -p /opt
sudo mv ~/minescript /opt/minecraft
sudo ln -s /opt/minecraft /mc
sudo ln -s /opt/minecraft/common/mc /usr/local/bin/mc.sh

sudo useradd -d /opt/minecraft -rU -s /usr/sbin/nologin mc
sudo usermod -aG mc $USER
sudo chgrp -R mc /opt/minecraft
sudo chown -R mc /opt/minecraft/servers
sudo chmod -R g+w /opt/minecraft
sudo chown -R root:root /opt/minecraft/init
sudo chmod -R g-w /opt/minecraft/common
~~~

1. Log out and back in.  If you're using tmux/screen/byobu, you'll need to exit all windows as well and start a fresh session.
1. Based on the example in /mc/init, create mc-servername.conf files for each of your servers.  Do not edit or delete the original if you want updates.
1. Link all of the init files to /etc/init: `sudo ls -s /mc/init/*.conf /etc/init`
1. Based on the example in /mc/servers, create directories for each of your servers.  Do not edit or delete the original examples.  The first example file uses a common server.jar file shared between servers in /mc/common; the second uses a per-server server.jar file in /mc/servers/\*/.  You can use a combination of both.  Move your server files into the server folders and *change the permissions on the files recursively to match.*
1. Based on the example in /mc/common/users, create IGN files for each of the users who will have access to the server console.  They do not need root access, but they do need to be in the mc group: `sudo usermod -aG mc $USER`
1. Create a global default configuration based on the example: /mc/common/config.global.sh
1. Create a cronjob that runs /mc/common/backup.sh as root every 15 minutes or so.  Decreasing the frequency will not significantly decrease file size.

Commands
========

* Start all servers: `sudo start mc`
* Stop all servers: `sudo stop mc`
* Start a single server: `sudo start mc-servername`
* Stop a single server: `sudo stop mc-servername`
* Status of a single server: `sudo status mc-servername`
* Attach to the console: `mc attach`

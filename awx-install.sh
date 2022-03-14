#!/bin/bash

# Installation script for AWX into the NSE sandbox environment.
# Install is for the existing sandbox ansible server.
# Installs AWX 17.0.1 (NB: install process was changed for AWX 18.0.0 and up)
# Requires a docker hub User ID or will most likely fail due to hub download limits
#
# Greg Fraser greg.fraser@dell.com

clear

echo Installation script for AWX into the NSE sandbox

echo You may be prompted for sudo password

echo Script results are redirected to awx-install.log

echo 

rm awx-install.log

# Linux Update

echo >> awx-install.log
echo --- >> awx-install.log
echo Linux Update >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Linux update ...
if sudo apt-get update >> awx-install.log; then

	echo Success

else

	echo Error - See awx-install.log for information 

	exit

fi

# Install Docker

echo >> awx-install.log
echo --- >> awx-install.log
echo Install docker >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Install docker ...
if sudo apt-get install docker docker.io -y >> awx-install.log; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Install Docker Compose

echo >> awx-install.log
echo --- >> awx-install.log
echo Install docker-compose >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Install docker-compose...
if sudo pip3 install docker-compose >> awx-install.log; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Set docker user access

echo >> awx-install.log
echo --- >> awx-install.log
echo Set docker user access >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Set docker user access...
if sudo usermod -aG docker $USER >> awx-install.log; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Git clone awx ansible install

echo >> awx-install.log
echo --- >> awx-install.log
echo Git clone awx ansible install >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Git clone awx ansible install...
if sudo git clone -b 17.0.1 https://github.com/ansible/awx.git >> awx-install.log; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Edit inventory file - set awx host_port=8080

echo >> awx-install.log
echo --- >> awx-install.log
echo Edit inventory file - set awx host_port=8080 >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Edit inventory file - set awx host_port=8080...
if sudo sed -i -e 's/.*host_port=.*/host_port=8080/' ./awx/installer/inventory >> awx-install.log; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Edit inventory file - set awx admin_password

echo >> awx-install.log
echo --- >> awx-install.log
echo Edit inventory file - set awx admin_password >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Edit inventory file - set awx admin_password...
if sudo sed -i -e 's/.*admin_password=.*/admin_password=Password123!/' ./awx/installer/inventory >> awx-install.log; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Edit inventory file - set awx create_preload_data=false

echo >> awx-install.log
echo --- >> awx-install.log
echo Edit inventory file - set awx create_preload_data=falsed >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Edit inventory file - set awx create_preload_data...
if sudo sed -i -e 's/.*create_preload_data=.*/create_preload_data=false/' ./awx/installer/inventory >> awx-install.log; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Docker hub login 

echo >> awx-install.log
echo --- >> awx-install.log
echo Docker hub login >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Docker hub login...
if sudo docker login; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Run awx install playbook

echo >> awx-install.log
echo --- >> awx-install.log
echo Run awx install playbook >> awx-install.log
echo --- >> awx-install.log
echo >> awx-install.log

echo Run awx install playbook.  This may take some time...
if ansible-playbook -i ./awx/installer/inventory ./awx/installer/install.yml; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Install  succeeded

echo AWX installed.
echo From the web browser connect to http://192.168.1.238:8080

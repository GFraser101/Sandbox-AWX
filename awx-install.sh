#!/bin/bash

# Installation script for AWX into the NSE sandbox environment.
# Install is for the existing sandbox ansible server.
# Installs AWX 17.0.1 (NB: install process was changed for AWX 18.0.0 and up)
# Requires a docker hub User ID due to hub download limits
#
# Greg Fraser greg.fraser@dell.com

clear

echo Installation script for AWX into the NSE sandbox

echo You may be prompted for sudo password as well as docker lab user-id and password

echo Most script results are redirected to awx-install.log

sudo echo 

# Clean up from any previous script runs

echo -e "\n---\nClean up from any previous script runs...\n---\n" | tee -a awx-install.log

# Remove previous log file
if sudo test -a "./awx-install.log"
then
	echo Remove previous install log
	if rm awx-install.log | tee -a awx-install.log
	then
		echo Success		
	else 
		echo Error - See awx-install.log for information
		exit
	fi
fi

# Remove cached docker hub credentials
if sudo test -a "/root/.docker/config.json"
then
	echo Remove cached docker hub credentials
	if sudo rm /root/.docker/config.json | tee -a awx-install.log
	then
		echo Success		
	else 
		echo Error - See awx-install.log for information
		exit
	fi
fi	

# Remove AWX clone
if sudo test -a "./awx"
then
	echo Remove previous AWX clone 
	if sudo rm -r awx | tee -a awx-install.log > /dev/null
	then
		echo Success
	else
		echo Error - See awx-install.log for information
		exit
	fi
fi

# Docker hub login 

echo -e "\n---\nDocker hub login...\n---\n" | tee -a awx-install.log

if sudo docker login; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi


# Linux Update

echo -e "\n---\nLinux update...\n---\n" | tee -a awx-install.log

if sudo apt-get update | tee -a awx-install.log > /dev/null; then

	echo Success

else

	echo Error - See awx-install.log for information 

	exit

fi

# Install Docker

echo -e "\n---\nInstall Docker...\n---\n" | tee -a awx-install.log

if sudo apt-get install docker docker.io -y | tee -a awx-install.log > /dev/null; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Install Docker Compose

echo -e "\n---\nInstall Docker compose...\n---\n" | tee -a awx-install.log

if sudo pip3 install docker-compose | tee -a awx-install.log > /dev/null; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Set docker user access

echo -e "\n---\nSet Docker user access...\n---\n" | tee -a awx-install.log

if sudo usermod -aG docker $USER | tee -a awx-install.log > /dev/null; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Git clone awx ansible install

echo -e "\n---\nGit clone awx ansible install...\n---\n" | tee -a awx-install.log

if sudo git clone -b 17.0.1 https://github.com/ansible/awx.git | tee -a awx-install.log > /dev/null; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Edit inventory file - set awx host_port=8080

echo -e "\n---\nEdit inventory file - set awx host_port=8080...\n---\n" | tee -a awx-install.log

if sudo sed -i -e 's/.*host_port=.*/host_port=8080/' ./awx/installer/inventory | tee -a awx-install.log > /dev/null; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Edit inventory file - set awx admin_password

echo -e "\n---\nEdit inventory file - set awx admin_password...\n---\n" | tee -a awx-install.log

if sudo sed -i -e 's/.*admin_password=.*/admin_password=Password123!/' ./awx/installer/inventory | tee -a awx-install.log > /dev/null; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Edit inventory file - set awx create_preload_data=false

echo -e "\n---\nEdit inventory file - set awx create_preload_data...\n---\n" | tee -a awx-install.log

if sudo sed -i -e 's/.*create_preload_data=.*/create_preload_data=false/' ./awx/installer/inventory | tee -a awx-install.log > /dev/null; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Run awx install playbook

echo -e "\n---\nRun awx install playbook.  This may take some time...\n---\n" | tee -a awx-install.log

if sudo ansible-playbook -i ./awx/installer/inventory ./awx/installer/install.yml | tee -a awx-install.log > /dev/null; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Install  succeeded

echo -e "\n---\nSuccess. AWX installed...\n---\n" | tee -a awx-install.log

echo -e "\n---\nFrom the web browser connect to http://192.168.1.238:8080\n---\n" | tee -a awx-install.log

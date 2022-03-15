#!/bin/bash

# Installation script for AWX into the NSE sandbox environment.
# Install is for the existing sandbox ansible server.
# Installs AWX 17.0.1 (NB: install process was changed for AWX 18.0.0 and up)
# Requires a docker hub User ID due to hub download limits
#
# Greg Fraser greg.fraser@dell.com

clear

echo -e "Installation script for AWX into the NSE sandbox"

echo -e "You may be prompted for sudo password as well as docker lab user-id and password"

echo -e "Most script results are redirected to awx-install.log"

# Get sudo password
sudo echo 

# Clean up from any previous script runs

echo -e "\n\n--- Clean up from any previous script runs..." | tee -a awx-install.log

# Remove previous log file
if sudo test -a "./awx-install.log"
then
	echo -e "Remove previous install log..." | tee -a awx-install.log
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
	echo -e "Remove cached docker hub credentials..." | tee -a awx-install.log
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
	echo -e "Remove previous AWX clone..." | tee -a awx-install.log
	if sudo rm -r awx | tee -a awx-install.log > /dev/null
	then
		echo Success
	else
		echo Error - See awx-install.log for information
		exit
	fi
fi

# Docker hub login 

echo -e "\n\n--- Docker hub login..." | tee -a awx-install.log

if sudo docker login; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi


# Linux Update

echo -e "\n\n--- Linux update..." | tee -a awx-install.log

if sudo apt-get update | tee -a awx-install.log > /dev/null; then

	echo Success

else

	echo Error - See awx-install.log for information 

	exit

fi

# Install Docker

echo -e "\n\n--- Install Docker..." | tee -a awx-install.log

if sudo apt-get install docker docker.io -y | tee -a awx-install.log > /dev/null; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Install Docker Compose

echo -e "\n\n--- Install Docker compose..." | tee -a awx-install.log

if sudo pip3 install docker-compose | tee -a awx-install.log > /dev/null; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Set docker user access

echo -e "\n\n--- Set Docker user access..." | tee -a awx-install.log

if sudo usermod -aG docker $USER | tee -a awx-install.log > /dev/null; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Git clone awx ansible install

echo -e "\n\n--- Git clone awx ansible install..." | tee -a awx-install.log

if sudo git clone -b 17.0.1 https://github.com/ansible/awx.git | tee -a awx-install.log > /dev/null; then

	echo  Success

else

	echo  Error - See awx-install.log for information

	exit

fi

# Edit inventory file - set awx host_port=8080

echo -e "\n\n--- Edit inventory file - set awx host_port=8080..." | tee -a awx-install.log

if sudo sed -i -e 's/.*host_port=.*/host_port=8080/' ./awx/installer/inventory | tee -a awx-install.log > /dev/null; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Edit inventory file - set awx admin_password

echo -e "\n\n--- Edit inventory file - set awx admin_password..." | tee -a awx-install.log

if sudo sed -i -e 's/.*admin_password=.*/admin_password=Password123!/' ./awx/installer/inventory | tee -a awx-install.log > /dev/null; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Edit inventory file - set awx create_preload_data=false

echo -e "\n\n--- Edit inventory file - set awx create_preload_data..." | tee -a awx-install.log

if sudo sed -i -e 's/.*create_preload_data=.*/create_preload_data=false/' ./awx/installer/inventory | tee -a awx-install.log > /dev/null; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Run awx install playbook

echo -e "\n\n--- Run awx install playbook.  This may take some time...\" | tee -a awx-install.log

if sudo ansible-playbook -i ./awx/installer/inventory ./awx/installer/install.yml | tee -a awx-install.log > /dev/null; then

        echo  Success

else

        echo  Error - See awx-install.log for information

        exit

fi

# Install  succeeded

echo -e "\n\n--- Success. AWX installed...\n---\n" | tee -a awx-install.log

echo -e "\n\n--- From the web browser connect to http://192.168.1.238:8080" | tee -a awx-install.log

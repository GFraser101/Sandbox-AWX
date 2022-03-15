# Sandbox-AWX
Install AWX container onto the Dell NSE Sandbox lab

Because of docker hub anonymous download limits, you will need a Docker Hub account to succesffully install.

Go to https://hub.docker.com/ to create an account if needed.
![image](https://user-images.githubusercontent.com/16183399/158133591-60b78b9b-9772-4c4d-9950-39dafa2ba16c.png)


Once you are setup with a docker hub account

1. Ensure the Sandbox Ansible server is running in GNS3 environment
![image](https://user-images.githubusercontent.com/16183399/158134021-12344cf3-e4bd-49d7-86e4-434210ed808e.png)


2. Open Sandbox X-Server app and connect the Ansible Server
![image](https://user-images.githubusercontent.com/16183399/158134334-029e5b46-8d04-4e74-88c4-9d8c29225731.png)


3. From the Ansible console clone to the Sandbox Ansible server. 

    <code>git clone https://github.com/GFraser101/Sandbox-AWX.git</code>


![image](https://user-images.githubusercontent.com/16183399/158134574-b6dca161-35c7-4fa3-9b89-b0e999e94199.png)

4. Run the install script.   
    
    <code>./Sandbox-AWX/awx-install.sh</code>

This may take some time and at some point you should be prompted for your Docker Hub credentials.


![image](https://user-images.githubusercontent.com/16183399/158135048-0482604c-9e43-4e99-9574-b332ce4688c5.png)


5. From the Sandbox console Web Browser login to AWX server. 

    <code>http://192.168.1.238:8080</code> 

User = admin

Password = (same as console password)

![image](https://user-images.githubusercontent.com/16183399/158139142-d2226336-3c87-429a-b73a-390e433e8e6d.png)


NOTE : First we setup  Sonarqube server , then Sonar-Scanner and after that the gitlab-ci/cd pipeline . 

1. > **SETUP SONARQUBE IN UBUNTU :**

Installation steps :-

Configure Kernel.

- Now modify the kernel system limits. For this we must set the following:

sudo nano /etc/sysctl.conf

Add the following lines to the bottom of that file:

vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

- Next, open the limits.conf file with the command:

sudo nano /etc/security/limits.conf

At the end of this file, add the following:

sonarqube   -   nofile   65536
sonarqube   -   nproc    4096

- Then, reboot your system so the changes will take effect.:

- Run the following command to install OpenJDK and JRE 11:

sudo apt install openjdk-11-jdk
sudo apt install openjdk-11-jre

sudo apt install postgresql postgresql-contrib

- start and enable the database service with the commands:

sudo systemctl enable postgresql
sudo systemctl start postgresql

- Set a password for the PostgreSQL user with the command:

sudo passwd postgres

- Login as PostgreSQL superuser and Create SonarQube PostgreSQL Database and Database user:

sudo -Hiu postgres
createuser sonaradmin
createdb -O sonaradmin sonarqubedb
psql
ALTER USER sonaradmin WITH ENCRYPTED password 'changeme';
\q
exit

- Now download the latest version of the SonarQube installer from the official website:

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.1.44547.zip
sudo unzip sonarqube-8.9.1.44547.zip -d /opt

- Move extracted setup to /opt/sonarqube directory:

sudo mv /opt/sonarqube-8.9.1.44547 /opt/sonarqube

- Now we create a group as sonar:

sudo groupadd sonar
sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar 
sudo chown sonar:sonar /opt/sonarqube -R

cp /opt/sonarqube/conf/sonar.properties /opt/sonarqube/conf/sonar.properties-bkp

- Next, open the SonarQube configuration file using your favorite text editor:

vim /opt/sonarqube/conf/sonar.properties

Remove all the content of the file sonar.properties and
enter this --> 

sonar.jdbc.username=sonar

sonar.jdbc.password=bigoh@123  --> replace password

sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube  -->>

sonar.web.javaAdditionalOpts=-server

sonar.web.host=104.236.112.77   -->> Replace IP

sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError

sonar.search.host=104.236.112.77  -->  Replace IP 

sonar.log.level=INFO

sonar.path.logs=logs

sonar.java.binaries=build/libs

:wq! 
----------------------------------------------------------------------------------------------------

- Enter the following at the last of the file  /opt/sonarqube/bin/linux-x86-64/sonar.sh :

RUN_AS_USER=sonar

- Let’s now create a systemd file, so the SonarQube service can be controlled. Create the file with the command:

sudo vim /etc/systemd/system/sonar.service

enter the following :-

[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096


[Install]
WantedBy=multi-user.target
-------------------------------------------------------------------------------------------------------

- Save and close the file, you can now start and enable the SonarQube service with the following two commands:

sudo systemctl start sonarqube

sudo systemctl enable sonarqube

****NOTE** :- If sonarqube does not start reflecting on your IP:9000 on browser , then try rebooting the server . **

 Login on IP:9000 with "user:admin" and "passwd:admin" by default and get the token from the sonarqube console (This token we will be needing for the gitlab Ci/Cd pipeline ).






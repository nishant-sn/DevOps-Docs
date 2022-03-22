_1. - **Use apt-get to install the required packages.**​_

apt-get update

apt-get install unzip wget nodejs

_2. Download the Sonarqube scanner package and move it to the OPT directory._

mkdir /downloads/sonarqube -p

cd /downloads/sonarqube

wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip

unzip sonar-scanner-cli-4.2.0.1873-linux.zip

mv sonar-scanner-4.2.0.1873-linux /opt/sonar-scanner

_3. Edit the sonar-scanner.properties file._
​

vi /opt/sonar-scanner/conf/sonar-scanner.properties 

enter this :-

#----- Default SonarQube server
sonar.host.url=http://104.236.112.77:9000  --> Replace IP 

#----- Default source code encoding
sonar.sourceEncoding=UTF-8

_4. Create a file to automate the required environment variables configuration_

vim /etc/profile.d/sonar-scanner.sh

Enter the following

#/bin/bash
export PATH="$PATH:/opt/sonar-scanner/bin"

_5. Reboot your computer or use the source command to add the sonar scanner command to the PATH variable._

reboot

source /etc/profile.d/sonar-scanner.sh

_6. Use the following command to verify if the PATH variable was changed as expected._

Run below command
env | grep PATH
 
Output should be :

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/sonar-scanner/bin

_7. Run "sonar-scanner -v" for checking the version :_

**NOTE : Now mark this version as You will be needing this sonar-scanner-cli-version for your gitlab script **

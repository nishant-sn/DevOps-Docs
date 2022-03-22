# Rocketchat Server upgrade

***Requirements:***
- Ubuntu 18.04
- NodeJS
- MongoDB (For Rocketchat)

## Setps for upgrade Os 18 to 20.04 

```
sudo apt update
sudo apt list --upgradable
sudo apt upgrade
sudo reboot
sudo apt install update-manager-core
sudo do-release-upgrade
```


## Setps for upgrade RocketChat version 1.1.1 to version 3.11.0


ref url : https://docs.rocket.chat/installation/manual-installation/updating
	: https://docs.rocket.chat/installation/manual-installation/ubuntu ( to check node version support 12.18.4)


```
sudo systemctl stop rocketchat

sudo rm -rf /opt/Rocket.Chat

curl -L https://releases.rocket.chat/latest/download -o /tmp/rocket.chat.tgz

tar -xzf /tmp/rocket.chat.tgz -C /tmp

cd /tmp/bundle/programs/server 
```
## test npm and node is working 
```
npm 

node -v 
```
## upgrade node version
```
sudo npm install n -g

sudo n 12.18.4

node -v
```

##
```
cd /tmp/bundle/programs/server

npm install

npm fund
```
##
```
sudo mv /tmp/bundle /opt/Rocket.Chat

sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat

sudo systemctl start rocketchat

sudo systemctl status rocketchat
```
## wait for 2 min , after 2 min check 3000 port (rocket chat port )

netstat -nltp

# restart nginx 

systemctl restart nginx 

nginx -t 

# check rocketchat whit url


example : http://128.199.28.172
	: http://128.199.28.172/api/info
  


==> Open rocketchat client and connect with server url 

---------------------------DONE------------------------------------ 

# NodeJS Docker container 

**Requirements:**

- Linux machine (Here we are using Ubuntu as base OS)
- Docker (latest)
- Firewall for security

## Steps to follow:
- Prepare OS first as base machine
- Install docker
- Create Dockerfile
- Build Dcoker image using Dockerfile
- Start container using docker image.

### Commands to achive your goal.
**Installing docker**
- Use link to [install & configure docker in your machine][identifier]

[identifier]: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04

Sample **Dockerfile**

```
FROM ubuntu:18.04
RUN apt update
RUN apt install -y openssh-server curl sudo wget net-tools git vim gnupg jq
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt install -y nodejs
RUN npm install pm2 -g

RUN mkdir /var/run/sshd
RUN echo 'root:xxxxxxxx' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN mkdir /app

EXPOSE xx xxxx xxxx xxxx

CMD    ["/usr/sbin/sshd", "-D"]
```
```
Note: Set your port, password instaed of xxxx
```


***Build Dcoker image using Dockerfile***
```
docker build -t myimage .
```


***Start container using docker image***
```
docker run -itd -p 9876:22 3010:3000 --name myapp myimage
```
```
Note: All ports, Names are assumed, you need to change port, names as per your need. Here 3000, 22 are container inside ports & 9876, 3010 are for outer world.
It is suggestable to setup your firewall to allow your ports.
```

***To check running & stopped containers***
```
docker ps -a
``` 

Now Enjoy!! All done.
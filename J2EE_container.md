# J2EE Docker container 

***Agenda:*** Create a container for JAR using self managed dockerfile.

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
FROM ubuntu:latest
RUN apt-get update && \
        apt-get install -y openjdk-8-jdk && \
        apt-get install -y ant;

RUN apt-get update && \
        apt-get install -y ca-certificates-java && \
        apt-get clean && \
        update-ca-certificates -f;

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get install -y net-tools && \
    apt-get install -y vim;

RUN mkdir /var/run/sshd
RUN echo 'root:xxxxxxxxxx' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN mkdir /app

EXPOSE xxxx xxxx xxxx xxxx

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
docker run -itd -p 9876:22 8080:8080 -p 8443:8443 --name myapp myimage
```
```
Note: All ports, Names are assumed, you need to change port, names as per your need. Here 8443, 8080, 22 are container inside ports 8443, 8080 & 9876 are for outer world.
It is suggestable to setup your firewall to allow your ports.
```

***To check running & stopped containers***
```
docker ps -a
``` 

Now Enjoy!! All Done.
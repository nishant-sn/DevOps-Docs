Custom Docker for redis server
==============================

#docker pull ubuntu:18.04
#docker run -itd --name mybase ubuntu:18.04
#docker exec -it mybase bash
	apt update
	apt install -y redis-server vim net-tools
	cat redis.sh	
		#!/bin/bash
	  	service redis-server start
	chmod +x redis.sh
	bash redis.sh
    netstat -tnlp
#docker commit -c "EXPOSE 6379" [Container-ID] myredis:latest
#cat redis.sh	
	#!/bin/bash
	service redis-server start
	while true; do sleep 100; done
#cat dockerfile
	FROM myredis:latest

	#RUN sed -ri 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf   //Uncomment for inline change
	#RUN sed -ri 's/daemonize no/daemonize yes/g' /etc/redis/redis.conf   //Uncomment for inline change
	#RUN sed -ri 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf  //Uncomment for inline change
	
	COPY redis.conf /etc/redis/redis.conf
	RUN chown redis:redis /etc/redis/redis.conf

	COPY redis.sh /redis.sh
	RUN chmod +x /redis.sh

	EXPOSE 6379
	ENTRYPOINT ["/bin/bash","/redis.sh"]
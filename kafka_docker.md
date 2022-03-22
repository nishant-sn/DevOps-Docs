Kafka DockerFile with supervisord
=================================

FROM ubuntu:18.04

RUN apt update
RUN apt install -y supervisor vim net-tools wget default-jdk
RUN wget http://www-us.apache.org/dist/kafka/2.4.0/kafka_2.13-2.4.0.tgz
RUN tar xzf kafka_2.13-2.4.0.tgz
RUN mv kafka_2.13-2.4.0 /usr/local/kafka
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN rm kafka_2.13-2.4.0.tgz
EXPOSE 2181 9092
CMD ["/usr/bin/supervisord"]



#cat > supervisord.conf
[supervisord]
nodaemon=true

[program:zookeeper]
command=/usr/local/kafka/bin/zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties

[program:kafka]
environment = JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
command=/usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties


To get public ip of host
hostname -I | awk '{print $1}'
# Fluentd Logs monitoring using Grafana LOKI

**Requirements**

- Docker / Kubernetes
- Dockerfile
- Firewall (Not in our agenda here)

**Create DockerFile**

```
FROM fluentd:v1.9.1-debian-1.0

ARG FLUENTD_LOKI_VERSION="1.2.14"
USER root
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential ruby-dev && \
    gem install fluent-plugin-grafana-loki -v "$FLUENTD_LOKI_VERSION"

RUN mkdir /fluentd/etc/conf.d/
COPY fluent.conf /fluentd/etc/fluent.conf
COPY 50-fluent.conf /fluentd/etc/conf.d/50-fluent.conf
RUN apt update && apt install -y supervisor
RUN mkdir /usr/share/man/man1/ && apt install -y default-jdk
RUN mkdir /app
COPY demo-0.0.1-SNAPSHOT.jar /app
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 8080
CMD ["/usr/bin/supervisord"]
```


**Copy 50-fluent.conf file in /fluentd/etc/conf.d**

cat /flunetd/etc/conf.d/50-fluent.conf
```
<source>
  @type tail
  path /logs/myapp.log
  tag "sample.#{Socket.gethostname}"
  <parse>
    @type multiline
    format_firstline /\d{4}-\d{1,2}-\d{1,2}/
    format1 /(?<timestamp>[^ ]* [^ ]*) (?<level>[^\s]+:)(?<message>[\s\S]*)/
  </parse>
</source>
<filter>
  @type record_transformer
  <record>
    host "#{Socket.gethostname}"
  </record>
</filter>
<match **>
  @type loki
  url "http://<IP Address of Loki>:3100"
  flush_interval 1s
  flush_at_shutdown true
  buffer_chunk_limit 1m
  include_tag_key true
  <label>
    host "#{Socket.gethostname}"
  </label>
  #host "#{ENV['HOSTNAME']}"
  extra_labels {"app":"java-file","env":"stage"}
</match>
```


**Copy fluentd.conf in /fluentd/etc/**

cat /fluentd/etc/fluent.conf
```
@include conf.d/*.conf
<source>
  @type forward
  port 24224
  <parse>
    @type multiline
    format_firstline /\d{4}-\d{1,2}-\d{1,2}/
    format1 /(?<timestamp>[^ ]* [^ ]*) (?<level>[^\s]+:)(?<message>[\s\S]*)/
  </parse>
</source>
<match **>
  @type loki
  url "http://<IP Address of Loki>:3100"
  flush_interval 1s
  flush_at_shutdown true
  buffer_chunk_limit 1m
  extra_labels {"app":"java","env":"stage"}
</match>
```

**Supervisor configuration**

cat /etc/supervisor/conf.d/supervisor.conf

```
[supervisord]
nodaemon=true

[program:fluentd]
command=/usr/local/bundle/bin/fluentd -p /fluentd/plugins -c /fluentd/etc/fluent.conf

[program:java]
command=nohup java -jar /app/demo-0.0.1-SNAPSHOT.jar > /logs/myapp.log 2>&1 &
```

## Start your container in docker
```
docker build -t myimage .
docker run -itd -p 8080:8080 --name myapp myimage
```

**Steps to achive**

- Goto Grafana Dashboard after login
- Configuration **>** Data Sources
- Add data source **>** search loki & select
- give url i.e http://localhost:3100
- save & test

**Check logs**

- Go to explore
- Select Log labels as it is drop down menu
- Select your label

Hurrey!! you achieved.


**For Reference kindly follow**
```
https://docs.fluentd.org/
https://grafana.com/blog/2020/05/12/an-only-slightly-technical-introduction-to-loki-the-prometheus-inspired-open-source-logging-system/
```


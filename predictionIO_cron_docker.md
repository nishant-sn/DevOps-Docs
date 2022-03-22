# PredictionIO in Docker / Kubernetes

**Requirements:**

- Docker
- kubernetes
- deployment & service file in yaml format
- image registry (Here we are using digitalocean sapce as registry)
- PredictionIO (We are using running PredictionIO backup here)



### Create dockerfile, cron, supervisor, deployment.yaml, service.yaml


cat dockerfile
```
FROM ubuntu:18.04
RUN apt update && apt install -y openjdk-8-jdk openjdk-8-jre supervisor cron net-tools vim
COPY ./crons /etc/cron.hourly/
RUN chmod +x /etc/cron.hourly/crons

COPY ./crons /home/crons.sh
RUN chmod +x /home/crons.sh
RUN echo "0 12 * * * uptime >> /var/log/mylog.log" | crontab -
#You can add more cron like below. (Here we are commenting as it is non required)
#RUN (crontab -l ; echo "*/2 * * * * free >> /var/log/mylog.log") 2>&1 | crontab -

COPY PredictionIO /home/PredictionIO/
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
WORKDIR /home/PredictionIO/PredictionIO-0.14.0/templates/ecommerce-template
EXPOSE 8000 7070
CMD ["/usr/bin/supervisord"]
```

cat crons
```
#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
cd /home/PredictionIO/PredictionIO-0.14.0/templates/ecommerce-template
/home/PredictionIO/PredictionIO-0.14.0/bin/pio train
/home/PredictionIO/PredictionIO-0.14.0/bin/pio deploy &
```

cat supervisor.conf
```
[supervisord]
nodaemon=true

[program:cron]
command=cron -f

[program:pio]
command=/home/PredictionIO/PredictionIO-0.14.0/bin/pio-start-all
directory=/home/PredictionIO/PredictionIO-0.14.0/templates/ecommerce-template

[program:eventserver]
command=/home/PredictionIO/PredictionIO-0.14.0/bin/pio eventserver &
directory=/home/PredictionIO/PredictionIO-0.14.0/templates/ecommerce-template

[program:train]
command=/home/crons.sh
autostart=true
```

cat deployment_predictionio.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: xxx-prediction
spec:
  replicas: 1
  selector:
    matchLabels:
      app: xxx-prediction
  template:
    metadata:
      labels:
        app: xxx-prediction
    spec:
      containers:
      - name: xxx-prediction
        image: registry.digitalocean.com/xxxxxxxxxx-kub/predictionio_stage
        imagePullPolicy: Always
      imagePullSecrets:
      - name: doctlsec2
        ports:
        - containerPort: 8000
        - containerPort: 7070
          protocol: TCP
```

cat service_predictionio.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: xxx-prediction
spec:
   type: NodePort
   selector:
     app: xxx-prediction
   ports:
     - name: predictionio
       port: 7070
       protocol: TCP
       targetPort: 7070
     - name: http
       port: 8000
       protocol: TCP
       targetPort: 8000
```

#### Commands to achive

**Create Image**

```
docker build -t registry.digitalocean.com/xxxxxxxxxx-kub/predictionio_stage .
```

**Push image to registry**
```
docker push registry.digitalocean.com/xxxxxxxxxx-kub/predictionio_stage
```

**Kubernetes Part**
```
kubectl get pods
kubectl apply -f deployment_predictionio.yaml --validate=false
kubectl apply -f service_predictionio.yaml
kubectl delete pod xxx-prediction-xxxxxxxxxxxxxxx
kubectl exec xxx-prediction-xxxxxxxxxxxxxx -- bash
ps -aux
nestat -tnlp
```

Great!! you have done

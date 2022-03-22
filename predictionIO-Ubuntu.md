Pridiction IO

#apt install openjdk-8-jre-headles
#java -version
	openjdk version "1.8.0_252"
	OpenJDK Runtime Environment (build 1.8.0_252-8u252-b09-1~18.04-b09)
	OpenJDK 64-Bit Server VM (build 25.252-b09, mixed mode)
#wget https://downloads.apache.org/predictionio/0.14.0/apache-predictionio-0.14.0-bin.tar.gz
#tar -zxvf apache-predictionio-0.14.0-bin.tar.gz
#cd PredictionIO-0.14.0/
#mkdir vendors; cd vendors
#wget https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz
#tar xvzf spark-2.3.0-bin-hadoop2.7.tgz
#cd ..
#vim conf/pio-env.sh

Copy Templete in PredictionIO-0.14.0/
scp -r xyz@1.2.3.4:/home/xyz/PredictionIO-0.14.0/templates .

#./pio app new MyApp1 
[INFO] [App$] Initialized Event Store for this app ID: 1.
[INFO] [Pio$] Created a new app:
[INFO] [Pio$]       Name: MyApp1
[INFO] [Pio$]         ID: 1
[INFO] [Pio$] Access Key: cyWxDHHxBV9KOb5DXk76k-zPeRijOY8PVatUWehWduQSHdQhdRx4Xro6REBL6v-W

#cd template/ecommerce-template/
#vim engine.json
	Change to MyApp1

	eventservwr setup
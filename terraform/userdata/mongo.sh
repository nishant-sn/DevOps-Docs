#!/bin/bash
sudo apt-get update -y
sudo apt-get install mongodb -y
          
sudo systemctl start mongodb
sudo systemctl enable mongodb
sudo mkdir -p /data/db
sudo chown -R $USER /data/db 
sudo chmod -R go+w /data/db
sudo ufw allow 27017
                


sudo tee -a mongodb.conf > /dev/null <<EOT
# mongodb.conf

# Where to store the data.
dbpath=/var/lib/mongodb

#where to log
logpath=/var/log/mongodb/mongodb.log

logappend=true

bind_ip = 0.0.0.0
#port = 27017

# Enable journaling, http://www.mongodb.org/display/DOCS/Journaling
journal=true

# Enables periodic logging of CPU utilization and I/O wait
#cpu = true

# Turn on/off security.  Off is currently the default
#noauth = true
auth = true

# Verbose logging output.
#verbose = true

# Inspect all client data for validity on receipt (useful for
# developing drivers)
#objcheck = true

# Enable db quota management
#quota = true

# Set diagnostic logging level where n is
#   0=off (default)
#   1=W
#   2=R
#   3=both
#   7=W+some reads
#diaglog = 0

# Diagnostic/debugging option
#nocursors = true

# Ignore query hints
#nohints = true

# Disable the HTTP interface (Defaults to localhost:27018).
#nohttpinterface = true

# Turns off server-side scripting.  This will result in greatly limited
# functionality
#noscripting = true

# Turns off table scans.  Any query that would do a table scan fails.
#notablescan = true

# Disable data file preallocation.
#noprealloc = true

# Specify .ns file size for new databases.
# nssize = <size>

# Accout token for Mongo monitoring server.
#mms-token = <token>

# Server name for Mongo monitoring server.
#mms-name = <server-name>

# Ping interval for Mongo monitoring server.
#mms-interval = <seconds>

# Replication Options

# in replicated mongo databases, specify here whether this is a slave or master
#slave = true
#source = master.example.com
# Slave only: specify a single database to replicate
#only = master.example.com
# or
#master = true
#source = slave.example.com

# Address of a server to pair with.
#pairwith = <server:port>
# Address of arbiter server.
#arbiter = <server:port>
# Automatically resync if slave data is stale
#autoresync
# Custom size for replication operation log.
#oplogSize = <MB>
# Size limit for in-memory storage of op ids.
#opIdMem = <bytes>

# SSL options
# Enable SSL on normal ports
#sslOnNormalPorts = true
# SSL Key file and password
#sslPEMKeyFile = /etc/ssl/mongodb.pem
#sslPEMKeyPassword = pass


EOT


sudo cp -apr /mongodb.conf /etc
sudo systemctl restart mongodb

sleep 2


sudo tee -a file.js > /dev/null <<EOT
db.createUser(
  {
    user: "${mongodb_user}",
    pwd: "${mongodb_pass}",
    roles: [ { role: "readWrite", db: "${mongodb_database}" } ]
  }
)
EOT

sleep 2

mongo admin file.js

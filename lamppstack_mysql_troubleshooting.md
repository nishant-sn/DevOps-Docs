lampp Stack MySQL Troubleshooting

Paths to check 
//For Configuration
1. /opt/lampp/etc/my.cnf  

//Change the buffer size of required
2. innodb_buffer_pool_size = 20M <required/desired value>

// Restart the lampp stack
4. sudo /opt/lampp/lampp restart

//check status of lampp stack
5. sudo /opt/lampp/lampp status

// Concern is not resolved than try below steps // If you get error "Bad magic header in tc log" then follow below steps

// For Data or log
1. /opt/lampp/var/mysql

// Check the log file
2. sudo tail -f <name.err>

// You can rename the file as tc.log file is corrupted
3. sudo mv /opt/lampp/var/mysql/tc.log /opt/lampp/var/mysql/tc.log.bak

// You can remove the file as tc.log file is corrupted
3. sudo rm /opt/lampp/var/mysql/tc.log

// Restart the lampp stack
4. sudo /opt/lampp/lampp restart

//check status of lampp stack
5. sudo /opt/lampp/lampp status

// Check using the netstat
5. netstat -tnlp
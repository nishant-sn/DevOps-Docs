```
#!/bin/bash
clear
#ban IPs:
bip() {
echo "" > tmpIPs
ufw status | grep DENY | awk '$1 !="Anywhere" {print $1}' | sort > tmpinc
exst=$(ufw status | grep "Anywhere                   DENY" | awk '{print $3}' | sort | uniq)
cat $cTarget | while read line
do
 add=$(cat tmpinc | grep $line)
 if [ "$add" != "$line" ]
  then
   ip=$(echo $line | cut -d '.' -f 1,2,3)
   if [ $ip != $ignorIP ]
    then
    echo $line >> tmpIPs
   fi
  fi
done

lAdd=$(cat tmpIPs)
cat tmpIPs | while read line
do
 if [ "$line" != "" ]
  then
  /usr/sbin/ufw insert 1 deny from $line to any  >> $cBanIpLog
  /usr/sbin/ufw insert 1 deny to $line from any >> $cBanIpLog
  echo "       Banned $line" >> $cBanIpLog
  fi
done
rm tmpIPs
}

nMax=5 # Maximum failes
cTarget="/tmp/_ban.ip" # Temporary storage file
cLogFile="/var/log/apache2/access.log" # apache2 access log file
cLogFile1="/var/log/apache2/error.log" # apache2 error.log
cLogFile2="/var/log/asterisk/messages" # asterisk log file
cBanLog="/var/log/banips.log"          #This script log file
cBanIpLog="/var/log/banIP.log"
ignorIP="192.168.1" #IP to ignor, usually home network
dt=$(date +%Y-%m-%d)

echo "Banning IP run at $(date)
Maximum offends: $nMax
Checking logs
        $cLogFile
        $cLogFile1
        $cLogFile11
        $cLogFile12
        " > $cBanIpLog

#Get the bastards out of apache2 and asterisk:
#apache2 access.log
grep 404 $cLogFile | cut -d ' ' -f 1,4 | cut -d ':' -f 1,2,3 | tr -d '[' | sort | uniq -c | sort -rn | awk ' $1 > '"$nMax"' {print $2}' | uniq -c | awk '{print $2}' > $cTarget.tmp
#apache2 error.log
grep "not found or unable to stat" $cLogFile1 | awk '{print $1,$2,$3,$5,$10}' | cut -d ':' -f 1 | sort | uniq -c | awk ' $1 > '"$nMax"' {print $6}' >> $cTarget.tmp
#asterisk messages
grep "failed for" $cLogFile2 | awk -F'failed for' '{print $2}' | awk -F' ' '{print $1}' | awk -F':' '{print $1}'  | tr -d "'" | sort | uniq -c | sort -nr | awk ' $1 > '"$nMax"' {print $2}' >> $cTarget.tmp
#asterisk messages
grep "rejected because extension not found" /var/log/asterisk/messages | awk -F'(' '{print $2}' | awk -F':' '{print $1}' | sort | uniq -c | awk ' $1 > '"$nMax"' {print $2}' >> $cTarget.tmp
#Check myAnt logons
#grep LogonERR /var/www/html/_Public/sys_logs/_qryLogIn.log | awk '{print $3}' | sort | uniq -c | sort -nr | awk '$1 > $nMax {print $2}' >> $cTarget.tmp

#Leave uniq ips
cat $cTarget.tmp | sort | uniq > $cTarget
rm $cTarget.tmp

#Banning
bip
if [ "$lAdd" != "" ]
then
 #Conclude:
 /bin/systemctl restart ufw
 /bin/systemctl status ufw >> $cBanIpLog
 /usr/sbin/ufw status >> $cBanIpLog
 cat $cBanLog | sort | uniq | sort >> /var/log/banips.tmp
 rm $cBanLog
 mv /var/log/banips.tmp $cBanLog
 cat $cBanLog | nl >> $cBanIpLog
 echo "Log file at $cBanIpLog
 nano $cBanLog
 Finished banning $(date)
 " >> $cBanIpLog
 #echo nano /var/log/banips.log
 clear
 cat $cBanIpLog
fi
```
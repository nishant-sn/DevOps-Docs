```
---
- hosts: all
  tasks:
  - name: Copy Audit Script to all servers
    copy:
          src: /home/yogi/myproject/LinuxAudit.sh 
          dest: /home/audituser/LinuxAudit.sh 
          owner: audituser
          group: audituser
          mode: '0755' 

  - name: Making AuditOutput.txt file
    file:
          path: '/home/audituser/{{ ansible_hostname }}.txt'
          state: touch
          owner: audituser
          group: audituser
          mode: '0644'

  - name: Run Audit Script on all Server
    shell: /home/audituser/LinuxAudit.sh >> '/home/audituser/{{ ansible_hostname }}'.txt
    args:
          executable: /bin/bash


          #  - name: Ansible command module for listing Dir
          #    register: listout
          #    command: 'ls -l /home/audituser/'
    
          #  - debug:
          #          var: listout
          
  - name: Fetch OutputFiles from Remote
    fetch:
           src: '/home/audituser/{{ ansible_hostname }}.txt'
           dest: /tmp/audit
```


```
#!/bin/bash
tput clear
trap ctrl_c INT

function ctrl_c(){
        echo "**You pressed Ctrl+C...Exiting"
	exit 0;
}
#
echo -e "###############################################"
echo -e "###############################################"
echo -e "###############################################"
echo " _    _                __    __    __      __ _    __ _ __  "
echo "| |  (_)_ _ _  ___ __  \ \  / /  //  \\    / _ _|  |__   __| "
echo "| |__| |   \ || \ \ /   \ \/ /  //    \\  / /  __     | |    "
echo "|____|_|_||_\_ _/_\_\    \  /   \\    //  \ \ |_ |  __| |__  "
echo "                         /_/     \\__//    \ \__// |__ _ __| "
echo
echo "###############################################"
echo "Welcome to security audit of your linux machine:"
echo "###############################################"
echo
echo "Script will automatically gather the required info:"
echo "The checklist can help you in the process of hardening your system:"
echo "Note: it has been tested for Debian Linux Distro:"
echo
sleep 3
echo "###############################################"
echo "OK....$HOSTNAME..lets move on...wait for it to finish:"
echo
sleep 3
echo "Script Starts ;)"
START=$(date +%s) 
echo -e "\e[0;33m 1. Linux Kernel Information////// \e[0m" 
uname -a
echo
echo "###############################################"
echo
echo -e "\e[0;33m 2. Current User and ID information////// \e[0m"
whoami
echo
id
echo
echo "###############################################"
echo
echo -e "\e[0;33m 3.  Linux Distribution Information///// \e[0m"
lsb_release -a
echo
echo "###############################################"
echo
echo -e "\e[0;33m 4. List Current Logged In Users///// \e[0m"
w
echo
echo "###############################################"
echo
echo -e "\e[0;33m 5. $HOSTNAME uptime Information///// \e[0m"
uptime
echo
echo "###############################################"
echo
echo -e "\e[0;33m 6. Running Services///// \e[0m"
service --status-all |grep "+"
echo
echo "###############################################"
echo
echo -e "\e[0;33m 7. Active internet connections and open ports///// \e[0m"
netstat -natp
echo
echo "###############################################"
echo
echo -e "\e[0;33m 8. Check Available Space///// \e[0m"
df
echo
echo "###############################################"
echo 
echo -e "\e[0;33m 9. Check Memory///// \e[0m"
free -h
echo
echo "###############################################"
echo
echo -e "\e[0;33m 10. History (Commands)///// \e[0m"
history
echo
echo "###############################################"
echo
echo -e "\e[0;33m 11. Network Interfaces///// \e[0m"
ifconfig -a | grep -v -e RX -e TX -e lo -e 127.0.0.1 -e ::1
echo
echo "###############################################"
echo 
echo -e "\e[0;33m 12. IPtable Information///// \e[0m"
iptables -L -n -v
echo 
echo "###############################################"
echo 
echo -e "\e[0;33m 13. UFW Information///// \e[0m"
ufw status
echo 
echo "###############################################"
echo
echo -e "\e[0;33m 14. Check Running Processes///// \e[0m"
ps -a
echo 
echo "###############################################"
echo
echo -e "\e[0;33m 15. Check SSH Configuration///// \e[0m"
cat /etc/ssh/sshd_config
echo 
echo "###############################################"
echo -e "\e[0;33m 16. List all packages installed///// \e[0m"
#apt-cache pkgnames 
apt list --installed
echo
echo "###############################################"
echo
echo -e "\e[0;33m 17. Network Parameters///// \e[0m"
#cat /etc/sysctl.conf
echo
echo "###############################################"
echo
echo -e "\e[0;33m 18. Password Policies///// \e[0m"
cat /etc/pam.d/common-password
echo
echo "###############################################"
echo
echo -e "\e[0;33m 19. Check your Source List file///// \e[0m"
#cat /etc/apt/sources.list
echo
echo "###############################################"
echo
echo -e "\e[0;33m 20. Check for broken dependencies \e[0m"
#apt-get check
echo
echo "###############################################"
echo
echo -e "\e[0;33m 21. MOTD banner message \e[0m"
#cat /etc/motd
echo
echo "###############################################"
echo
echo -e "\e[0;33m 22. List user names \e[0m" 
cut -d: -f1 /etc/passwd
echo
echo "###############################################"
echo
echo -e "\e[0;33m 23. Check for null passwords \e[0m"
users="$(cut -d: -f 1 /etc/passwd)"
for x in $users
do
passwd -S $x |grep "NP"
done
echo
echo "###############################################"
echo
echo -e "\e[0;33m 24. List privileged user names \e[0m" 
cat /etc/passwd | awk -F: '$3 > 999'
echo
echo "###############################################"
echo
echo -e "\e[0;33m 25. List Sudo Permissions \e[0m" 
grep -v -e '^[[:space:]]*$' -e '^#' /etc/sudoers
echo
echo "###############################################"
echo
echo -e "\e[0;33m 26. IP routing table \e[0m" 
route
echo
echo "###############################################"
END=$(date +%s) 
DIFF=$(( $END - $START ))
echo "Script completed in $DIFF seconds :"
echo

exit 0;
```

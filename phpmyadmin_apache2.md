
    1 apt update
    2  apt install php libapache2-mod-phpmyadmin
    3  apt install apache2 mysql-server php libapache2-mod-php php-mysql
    4  netstat -tnlp
    5  mysql_secure_installation
    6  mysql
    7  apt install phpmyadmin php-mbstring php-gettext
    8  phpenmod mbstring
    9  systemctl restart apache2
   10  phpenmod mbstring
   11  systemctl restart apache2
   12  phpenmod mycrypt
   13  php -v
   14  php -m | grep mysql
   15  mysql -v
   16  mysql --version
   17  mysql -u root -p
   18  ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/
   19  a2enconf phpmyadmin
   20  systemctl reload apache2
   21  vim /etc/phpmyadmin/config.inc.php
   22  vim /etc/phpmyadmin/config.inc.php
   23  vim /etc/hosts
   24  systemctl reload apache2.service
   25  vim /etc/phpmyadmin/config.inc.php
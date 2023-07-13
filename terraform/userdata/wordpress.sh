#!/bin/bash
set -x
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install php${php_version} \
php${php_version}-cli php${php_version}-fpm \
php${php_version}-mysql \
php${php_version}-opcache php${php_version}-mbstring \
php${php_version}-xml php${php_version}-gd \
php${php_version}-curl -y
sudo apt-get install mysql-client -y
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

sudo tee -a /var/www/html/wp-config.php <<EOF 
<?php
define('DB_NAME', '${DB_NAME}');
define('DB_USER', '${DB_USER}');
define('DB_PASSWORD', '${DB_PASSWORD}');
define('DB_HOST', '${DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define( 'WP_MEMORY_LIMIT', '512M' );
define( 'WP_MAX_MEMORY_LIMIT', '512M' );
define('AUTH_KEY',         'o+zKEv~Fd//HM3_p]%Io.S-?h>-&h`+T1+)0-+{c~9}Z=K#uMlCm7r>(u:44,05 ');
define('SECURE_AUTH_KEY',  'b?S7^;#dHL[1-+8|B-91S%~d&|k3N*(5<+;d*|HIJ)88#nb3>jAF.Xgg`ydfZ]co');
define('LOGGED_IN_KEY',    '(.hZc-RXH4ZuB@k,M~2Ih<:DpMx.*{`3-o?1I:^Y1Ei:ZbQj+]F7d=PyJY{V+jN>');
define('NONCE_KEY',        'tm0^|of8=d/evb- /tNdLFhRg{qzAQfjQaLwNRm@];2/;edy7],2ws%X-o(w(3t6');
define('AUTH_SALT',        'f9Q&64_&|qt,[[T@lOh)P8 :3d2G;,M N;<eT]$fp7$5=P|kgQS+~*IbihSMVR$K');
define('SECURE_AUTH_SALT', '-%ko/}Y/[LuD9$+[zF]h+MCFbaFhv}S6I&ZM(EGq-]`B1;<a$sCqa2w~Y43mgG+k');
define('LOGGED_IN_SALT',   'I|cIwcNB`whD?6QVa7G$>&u.CUae1@3eJmiUb`VNO-&3:pF0[0JAS{(oX%!A[9zh');
define('NONCE_SALT',       'Wn]c%5-Prga>?)?W0%x!7MH[&H*TylIg&j{oYr8]x[VGZczr0%H+x-JqIw7FAZ#v');
$table_prefix  = 'wp_';
define('WP_DEBUG', false);
define('DISABLE_WP_CRON', true);
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');
$_SERVER['HTTPS'] = 'on';
require_once(ABSPATH . 'wp-settings.php');
define('FS_METHOD','direct');
define( 'AWS_ACCESS_KEY_ID', '' );
define( 'AWS_SECRET_ACCESS_KEY', '' );

?>
EOF

sudo tee -a /etc/nginx/sites-available/default > /dev/null <<EOT
server {
            listen 80;
            root /var/www/html/wordpress/public_html;
            index index.php index.html;

            location / {
                         try_files $uri $uri/ =404;
            }

            location ~ \.php$ {
                         include snippets/fastcgi-php.conf;
                         fastcgi_pass unix:/run/php/php${php_version}-fpm.sock;
            }
            
            location ~ /\.ht {
                         deny all;
            }

            location = /favicon.ico {
                         log_not_found off;
                         access_log off;
            }

            location = /robots.txt {
                         allow all;
                         log_not_found off;
                         access_log off;
           }
       
            location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                         expires max;
                         log_not_found off;
           }
}
EOT

MYSQL_PWD=${rds_pass} mysql -h ${DB_HOST} -u ${rds_user} -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
MYSQL_PWD=${rds_pass} mysql -h ${DB_HOST} -u ${rds_user} -e "create database ${DB_NAME};"
MYSQL_PWD=${rds_pass} mysql -h ${DB_HOST} -u ${rds_user} -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
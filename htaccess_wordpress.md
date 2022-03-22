Wordpress (CZ) security in .htaccess file

1. Limit GET/POST/PUT from specific IP/ VPN (wpadmin) in .htaccess
	<Limit GET POST PUT>
		order deny,allow
		deny from all
		allow from xx.xx.xx.xx
	</Limit>

2. Secure Important File
	<FilesMatch "^.*(error_log|wp-config\.php|php.ini|\.[hH][tT][aApP].*)$">
		Order deny,allow
		Deny from all
	</FilesMatch>
3. Restrict wp-config from remote
	<files wp-config.php>
		order allow,deny
		deny from all
	</files>
4. Protect .htaccess itself 
	<files ~ "^.*\.([Hh][Tt][Aa])">
		order allow,deny
		deny from all
		satisfy all
	</files>
5. Restrict All Access To WP Includes
	# Blocks all wp-includes folders and files
	<IfModule mod_rewrite.c>
		RewriteEngine On
		RewriteBase /
		RewriteRule ^wp-admin/includes/ - [F,L]
		RewriteRule !^wp-includes/ - [S=3]
		RewriteRule ^wp-includes/[^/]+\.php$ - [F,L]
		RewriteRule ^wp-includes/js/tinymce/langs/.+\.php - [F,L]
		RewriteRule ^wp-includes/theme-compat/ - [F,L]
	</IfModule>
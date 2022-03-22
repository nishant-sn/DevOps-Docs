# Nginx serve resverse proxy and static file with same configuration for same virutalhost

**Requirements:**

- Ubuntu
- Nginx
- PM2 like (NodeJS/React)

**Prereuqusites:**
```
Apllication is running (Port 3000 or any) by PM2
```
cat /etc/nginx/sites-available/mysite.conf
```
server {

	listen 80;
	servername www.example.com;


location / {
    root /path/to/root/of/static/files;
    try_files $uri $uri/ @reversesite;

    expires max;
    access_log off;
}

location @reversesite {
    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://127.0.0.1:3000;
	}
}
```

***Start & enable Nginx service***
```
systemctl start nginx; systemctl enable nginx
```



```
Check URL in your web-browser
```

Now Enjoy!! you have done.
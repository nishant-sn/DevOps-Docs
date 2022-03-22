# Nginx Path based Routing & host based routing

**Requirements:**

- Linux machine (Here we are using Ubuntu as base OS)
- Docker (latest)
- Firewall for security

## Steps to follow:
- Prepare OS first as base machine
- Intall NGINX
- Firewall setup (Not in Our Agenda here)

### Commands to achive your goal.
**Installing Nginx**
- Use link to [install & start in your machine][identifier]

[identifier]: https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04


#### Configuration settings.
**Path Based Routing**

```
server {
    listen  80;
    ...
    location / {
        proxy_pass http://IP:Port;
    }
    
    location /blog {
        rewrite ^/blog(.*) /$1 break;
        proxy_pass http://IP:Port;
    }

    location /mail {
        rewrite ^/mail(.*) /$1 break;
        proxy_pass http://IP:Port;
    }
    ...
}
```

**Host Based Routing**

```
server {
    listen       80;
    server_name  example1.com;

    location / {
        proxy_pass http://IP:Port;
    }
}

server {
    listen       80;
    server_name  example2.com;

    location / {
        proxy_pass http://IP:Port;
    }
}

server {
    listen       80;
    server_name  example3.com;

    location / {
        proxy_pass http://IP:Port;
    }
}
```


***Start & enable Nginx service***
```
systemctl start nginx; systemctl enable nginx
```



```
Check on your web-browser
```
```
Note: It is suggestable to setup your firewall to allow your ports.
```


Now Enjoy!! you have done.

**Reference URL**
```
https://linuxconfig.org/how-to-setup-nginx-reverse-proxy
```
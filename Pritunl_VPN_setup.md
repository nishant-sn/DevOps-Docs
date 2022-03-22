# Pritunl VPN Setup

**Requirements:**

- Linux machine (Here we are using Ubuntu as base OS)
- Firewall for security (Not in our Agenda)

## Steps to follow:
- Prepare OS first as base machine
- Intall NGINX
- Firewall setup (Not in Our Agenda here)

### Commands to achive your goal.
**Installing Pritunl VPN**
- Use link to [install & start in your machine][identifier]


[identifier]: https://www.howtoforge.com/how-to-setup-a-vpn-server-using-pritunl-on-ubuntu-1804/




#### Pritunl client Configuration settings in ubuntu 18.04
```
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt bionic main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update
sudo apt-get install pritunl-client-electron
```

**Mac & Widnows kindly use below links**
```
https://client.pritunl.com/
```
```
https://cloudcare.freshdesk.com/support/solutions/articles/4000145967-installation-of-pritunl-vpn-client
```
**Reference URL**
```
https://docs.pritunl.com/docs/securing-pritunl
```
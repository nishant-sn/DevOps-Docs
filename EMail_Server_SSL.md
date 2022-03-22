#  SSL Certificate (letsencrypt) in Mail Server 
***Agenda:*** This document will help to SSL Certificate Installation/ Renewal in Craterzone email server (Sendmail server)

**Steps**

- First get SSL Certificate (In our case it is from Letsencrypt)
- Define Cerficate path in Apache2 configuration
- Copy same in Sendmail Certificate path
- Copy same in Webmin / Usermin Certificate path
- restart all services

## Sendmail Certificate
**Run in Terminal**
```
cd /opt/letsencrypt/live/<Site-Name>
cat privkey.pem cert.pem > /etc/pki/tls/certs/sendmail.pem
cat chain.pem > /etc/pki/tls/certs/chain.pem
```

## Webmail Certificate
**Run in Terminal**
```
cat cert.pem > /etc/webmin/miniserv.cert
cat chain.pem > /etc/webmin/miniserv.chain
cat privkey.pem > /etc/webmin/miniserv.pem
cd /etc/webmin/
./restart
```
****Check in browser****
```
https://webmail.craterzone.com:13575/
```

## Usermin Certificate
**Run in Terminal**
```
cd /etc/usermin
cp /etc/webmin/miniserv.pem miniserv.pem
./stop
./start
```
****Check in browser****
```
https://webmail.craterzone.com:23777/
```

## Dovecot Certificate (IMAP & POP3 SSL)

**Define from Webmail administration Dashboard**

```
- Goto https://webmail.craterzone.com:13575/
- Pass the creds to login
- Go to "Servers"
- Select "Dovecot IMAP/POP3 server"
- SSL Configuration
- Define Certificate as below
```
```
SSL certificate file	/opt/letsencrypt/live/<Site-Name>/cert.pem
SSL private key file	/opt/letsencrypt/live/<Site-Name>/privkey.pem
SSL CA certificate file /opt/letsencrypt/live/<Site-Name>/fullchain.pem
- save
- Apply Configuration
```

vim /etc/mail/sendmail.mc
```
TRUST_AUTH_MECH(`LOGIN PLAIN')dnl
dnl #define(`confAUTH_OPTIONS', `A')dnl
define(`confAUTH_OPTIONS', `A')dnl
define(`confAUTH_MECHANISMS', `LOGIN PLAIN')dnl

define(`confCACERT_PATH',`/etc/pki/tls/certs')dnl
define(`confCACERT',`/etc/pki/tls/certs/chain.pem')dnl
define(`confSERVER_CERT',`/etc/pki/tls/certs/sendmail.pem')dnl
define(`confSERVER_KEY',`/etc/pki/tls/certs/sendmail.pem')dnl
DAEMON_OPTIONS(`Name=MTA,Port=smtp')
dnl #DAEMON_OPTIONS(`Name=TLSMTA,Port=smtps')
DAEMON_OPTIONS(`Name=TLSMTA,Port=smtps')

define(`confAUTH_MECHANISMS', `EXTERNAL GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
dnl define(`LUSER_RELAY',`mail.craterzone.com')dnl
define(`LUSER_RELAY',`webmail.craterzone.com')dnl
FEATURE(`preserve_luser_host')dnl
MAILER(`local')dnl
 MAILER(`smtp')dnl

DAEMON_OPTIONS(`Name=MSA,Port=7777')
INPUT_MAIL_FILTER(`opendkim', `S=inet:8891@127.0.0.1')dnl
```

**Add / Change / define Certificate in apahce2 configuration**

```
SSLCertificateFile /opt/letsencrypt/live/<Site-Name>/cert.pem
SSLCertificateKeyFile /opt/letsencrypt/live/<Site-Name>/privkey.pem
SSLCertificateChainFile /opt/letsencrypt/live/<Site-Name>/chain.pem
```

**Restart the services**

```
/etc/init.d/dovecot restart
service saslauthd restart
service sendmail restart
service apache2 restart
```

```
Note: Make Sure SSL Certificate (Fresh / Renew) must be wildcard. i.e. *.craterzone.com
```

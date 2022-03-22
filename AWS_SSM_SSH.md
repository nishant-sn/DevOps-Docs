# AWS SSM SSH

***Agenda:*** SSH Login into private server (without bastion) using AWS Systems Manager Service.

**Requirements:**

- AWS Account 
- IAM Policy
- EC2 Instance
- AWS CLI
- Session Manager Plugin
- BAsic Linux Knowledge

**Steps To Create Pocily**

- Create Policy
- Paste Value in JSON


```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ssm:StartSession",
                "ssm:TerminateSession",
                "ssm:ResumeSession",
                "ssm:DescribeSessions",
                "ssm:GetConnectionStatus"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ]
}
```

- Review Policy
- Define Name of Policy & Description
- Create Policy

```
Note: Policy must be attached to EC2 intance later after successfully Creation.
```

**Install SSM Plugin on your local linux compute system/ machine**

```
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
```

```
sudo dpkg -i session-manager-plugin.deb
```
**Verify Session Manager installation**

```
session-manager-plugin
```
**Install AWSCLI on local**

```
sudo apt install awscli
```

```
aws --version
```
**Configure AWS CLI by defining Access Key, Secret Key, AWS Region**

```
aws configure
```
### Configure ssh config (Optional)

cat .ssh/config
```
Host i-* mi-*
     ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

**Check if you are now able to login to EC2 (Private) without Bastion/ Jump Server**

**Method 1-**
```
ssh <ubuntu@i-xxxxxxxxxxxxxx> -i <server-key.pem>
```

**Method 2-**

```
aws ssm start-session --target "i-xxxxxxxxxxxxxxxx"
```
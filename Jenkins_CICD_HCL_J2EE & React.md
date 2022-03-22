# Jenkins CI/CD for HCL J2EE

***Agenda:*** CI/CD Pipeline (Building & Deploying) using Jenkins in HCL

**Requirements:**
- Jenkins Server URL
- Gitlab Repository for Code
- Kubernetes Infra

***Login to Jenkins Server URL***
http://xx.xx.xx.xx:8080

## Steps for building the code/ docker image:
- Go to mutibranch-pip
- Choose Master/ elasticsearch branch
- Build Now
- Build no. will generated once build success i.e 30

## Steps for deploying the code on kubernetes infra:
- First go to home page
- Go to HCL-DEPLOY-JAR-STAGE/ HCL-DEPLOY-JAR-PRODUCTION
- Choose "Build with Parameters"
- Pass Build No i.e 30 in tag
- Build



# Jenkins CI/CD for HCL React

**Requirements:**
- Jenkins Server URL
- Gitlab Repository for Code
- Kubernetes Infra

***Login to Jenkins Server URL***
http://xx.xx.xx.xx:8080

## Steps for building the code/ docker image:
- Go to mutibranch-pip-hcl-cms
- Choose CICD_Production/ CICD_stage
- Build Now
- Build no. will generated once build success i.e 30

## Steps for deploying the code on kubernetes infra:
- First go to home page
- Go to HCL-DEPLOY-REACT-PRODUCTION/ HCL-DEPLOY-REACT-STAGE
- Choose "Build with Parameters"
- Pass Build No i.e 30 in tag
- Build
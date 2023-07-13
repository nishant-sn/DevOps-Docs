#=========================================================\
This script will apply the terraform commands and the logs\
will be stored in the logs directory inside current directory. \
Input vars -> PROJECT = <project-name>-<env> \
==========================================================

SHELL = /bin/bash -o pipefail

.DEFAULT_GOAL := log

#DATE := $(shell /bin/date +%Y%m%d-%H%M%S)

log: 
	@[ -d logs ] || mkdir logs
	#@[ -d logs/latest ] || mkdir logs/
	
new:
	@echo Creating/Switching to ${PROJECT} workspace of terraform
	@-terraform workspace new ${PROJECT}

ws_select:
	@terraform workspace select ${PROJECT}

init:	log new ws_select 
	@-rm -f logs/${PROJECT}-init.txt
	@echo Initializing terraform providers
	@terraform init 2>&1 | tee -a logs/${PROJECT}-init.txt

plan:	log new ws_select init
	@-rm -f logs/${PROJECT}-plan.txt
	@echo Running terraform plan
	@terraform plan -no-color -var-file=${PROJECT}.tfvars 2>&1 | tee -a logs/${PROJECT}-plan.txt

apply:	log new ws_select init
	@rm -f logs/${PROJECT}-apply.txt
	@echo Running terraform apply
	@terraform apply -no-color -var-file=${PROJECT}.tfvars -auto-approve 2>&1 | tee -a logs/${PROJECT}-apply.txt
	#@cp logs/${PROJECT}-apply-${DATE}.txt logs/latest/${PROJECT}-apply.txt	

destroy: log ws_select
	@rm -f logs/${PROJECT}-destroy.txt
	@echo Running terraform destroy
	@terraform destroy -no-color -var-file=${PROJECT}.tfvars --auto-approve 2>&1 | tee -a logs/${PROJECT}-destroy.txt
	#@cp logs/${PROJECT}-destroy-${DATE}.txt logs/latest/${PROJECT}-destroy.txt
	@terraform workspace select default
	@terraform workspace delete ${PROJECT}
	@rm ${PROJECT}.tfvars

output: log ws_select
	@rm -f logs/${PROJECT}-output.txt
	@echo Displaying terraform output
	@terraform output -no-color 2>&1 | tee -a logs/${PROJECT}-output.txt
	#@cp logs/${PROJECT}-output-${DATE}.txt logs/latest/${PROJECT}-output.txt		

refresh: log ws_select
	@echo Refreshing terraform state
	@terraform refresh -var-file=${PROJECT}.tfvars

list_created_resource: log ws_select
	@terraform state list

resource_detail: log ws_select
	@terraform state show ${ELEMENT}

# J2EE deployment on running docker container using simple ssh (shell)

***Agenda:*** CI/CD pipeline for J2EE (JAR) using GitLab-CI.


**Requirements:**

 - **Variables:**
  	ssh_user, ssh-port, work_dir, server_ip, id_rsa (ssh_key), service_port, log_filename, runner_path, jar_name 

 - **Files:**
        Ensure .gitlab-ci.yml file is available in your desired branch of repo.
    Script File (Restart.sh) in deploy dir.

 - **Runner:**
        - Runner is defined (Single time Administrative Activity per repo):
  	Go to Project first, inside settings choose CI / CD, expand runner.
  	
<!-- Identifiers, in alphabetical order -->
[identifier]: https://docs.gitlab.com/12.10/runner/install
```ruby
Note: Variables are essential to run pipeline. 

```
**Add variables:**
	Go to Project first, inside settings choose CI / CD.
	expand variables, add variable. First define Key (Variable Name) then value and most important defaine Environments for your variables.

**Setup & Register Runner:**
         Follow the link to [Setup & register Runner][identifier].

## Deployment Procedure:

- Go to Repository (If Variables are already defined properly) **>** Projects **>** Search your project **i.e. Hospitality Bot**

- Select your branch (i.e. For Development choose developent, For prod choose master branch)
    Here you need to choose Development branch

- Chase CI / CD for pipelines from left pane bar

- Run Pipeline from the top to run with latest commit

- Choose your desired deployment (i.e Deploy to Development / Deploy to Staging) from manual job of specific commit

- Go to jobs to select your job, Once you select your job you will get your running deployment on terminal.
```
Note: You can check your any deployment (failed / success) logs later as well.

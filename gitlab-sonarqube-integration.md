# GitLab SonarQube (Integration for J2EE) Pipeline

** Requirements**
 - **sonarqube installed on node / server**
 - **sonarqube token**

 - **Variables:**
  	SONAR_HOST_URL, SONAR_SCANNER_CLI_VERSION, SONAR_TOKEN

 - **Files:**
        Ensure .gitlab-ci.yml file is available in your desired branch of repo.

 - **Runner:**
        - Runner is defined (Single time Administrative Activity per repo):
  	Go to Project first, inside settings choose CI / CD, expand runner.
  	
<!-- Identifiers, in alphabetical order -->
[identifier]: https://docs.gitlab.com/12.10/runner/install
```ruby
Note: Variables are essential to run pipeline. 

```

**You will get SonarQube URL and Creds**
http://xx.xx.xx.xx:9000

## Add below mentioned as CI/CD variables in the project repo for sonarqube
```
SONAR_HOST_URL : http://xx.xx.xx.xx:9000/
SONAR_SCANNER_CLI_VERSION : 4.2
SONAR_TOKEN : <Tokan>
```


## Add this .gitlab-ci.yml
``` 
stages:
  - sonarqube_stage
sonarqube_ci_stanza:                                                                # free name
  image: sonarsource/sonar-scanner-cli:${SONAR_SCANNER_CLI_VERSION}
  stage: sonarqube_stage                                                            # free name
  variables:
    SONAR_PROJECT_BASE_DIR: "$CI_PROJECT_DIR"
  before_script:
    - mvn clean install sonar:sonar

  script:
  #  - /usr/bin/entrypoint.sh sonar-scanner -Dsonar.projectKey="$CI_PROJECT_NAME"    # sonar.projectKey defines the name of the project in SonarQube. No need to add this in the script . It compiles more dependencies unnecessarily and give errors.
    - mvn sonar:sonar -Dsonar.host.url="$SONAR_HOST_URL" -Dsonar.login="$SONAR_TOKEN"
```
We have achieved..!!
```
Note: You can check your any deployment (failed / success) logs later as well.
```

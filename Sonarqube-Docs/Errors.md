1. **Error while adding variable** :

While adding variable in the project , Dont forget to unprotect the variables .

2. **Error in Pom.xml** :

Remove the following dependency if exists :-

<dependency>
<groupId>org.springframework.boot</groupId>
<artifactId>spring-boot-starter-test</artifactId>
<scope>test</scope>
<exclusions>
<exclusion>
<groupId>org.junit.vintage</groupId>
<artifactId>junit-vintage-engine</artifactId>
</exclusion>
</exclusions>
</dependency>



3. **Remove the src/test folder in the repo** . 

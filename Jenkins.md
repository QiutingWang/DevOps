# Jenkins Incomplete

## References:

- Jenkins Full Course in 4 Hours.<https://www.youtube.com/watch?v=3a8KsB5wJDE&t=58s>
- Complete Jenkins Pipeline Tutorial. <https://www.youtube.com/watch?v=7KCS70sCoK0&list=PLy7NrYWoggjzSIlwxeBbcgfAdYoxCIrM2&index=3>
- Maven <https://maven.apache.org/>
- How To Set Jenkins Pipeline Environment Variables? <https://www.lambdatest.com/blog/set-jenkins-pipeline-environment-variables-list/>
- Best Jenkins Pipeline Tutorial For Beginners. <https://www.lambdatest.com/blog/jenkins-pipeline-tutorial/#Jenkins>

## 1. Why We Need Jenkins?

- Developers make codes work in parallel. They want to make sure their changes integrate *without errors*.
- Without Jenkins, *manual* integration testing happens *infrequently and time-consuming*.
- To make sure the changes are built and tested in a *standardized environment*.
- Jenkins is used in automating <u>Testing and Deployment</u> processes in software development cycle.
- Other CI/CD tools: GitLab CI, CircleCI, Travis CI, Bamboo, Buildbot

## 2. Install & Configure Jenkins

- Terminal: `brew install jenkins`
- Start Jenkins service: `brew services start jenkins`
- We need a Java environment. Download: <https://www.oracle.com/java/technologies/downloads/#jdk20-mac>
  - check: `java -version`, return:
  ```
  java version "20.0.1" 2023-04-18
  Java(TM) SE Runtime Environment (build 20.0.1+9-29)
  Java HotSpot(TM) 64-Bit Server VM (build 20.0.1+9-29, mixed mode, sharing)
  ```
- Jenkins is running at `localhost:8080` by default.
  - type in the passwords to unlock Jenkins.
  - download the Suggested Plugins
- Familiar with Jenkins GUI
  - Start Items
    - Freestyle Project
    - Pipeline
    - Multi-configuration Project
    - Folder
    - Github Organization
    - Multi-branch Pipeline
  - Manage Jenkins--Configure System
    - number of executors: 
      - the threads working at the same time. 
      - By default, it is set to 2. 
      - If we need to add more executors, correspondingly it requires more computing resources.
  
## 3. Install Maven Plugin on Jenkins

- Why use Maven Plugin?
  - test reporting
  - reduce configuration required for Maven projects
  - parallel and distributed module builds
  - build chaining from module dependencies
  - manage documentation, distribution, releases, and dependencies.

## 4. Jenkinsfile

- Definition: 
  - Scripted pipeline, pipeline as code
  - is created in your repository
- Basic Syntax: 
  - Scripted Pipeline
    - No pre-defined structure, advanced scripting capabilities
    - high flexibility
    - difficult to start
  ```
  node{
    //groovy script
  }
  ```
  - Declarative Pipeline
    - recent addition version 
    - easier to get started, but not powerful
- Required fields of Jenkinsfile
  - `pipeline`: put in the top
    - `agent`: where to execute. We can select from `any`,`label`,`docker`,`dockerfile`
    - `environment`
      - the variables defined here are available for all the stages in the pipeline
      - syntax: `VARIABLENAME=value`, capitalize the variable name
      - we can use Credentials in this felid. `SERVER_CREDENTIALS = credentials('credentialID')`
        - bind the credentials to env variable.
        - with *Credential Binding* plugin
    - `tools`: 
      - type in the name of the tools
      - make the app installs for all stages
    - `parameters`:
      - Types: string/choice/booleanParam(name:'...', defaultValue/choices:[...,...], description:'...')
      - it can be used in when clause by `params.name`
        - `name`: is the same as what we have previously defined in parameters.
      - After scanning, go to *Build with Parameters* page
    - `stages`: where the work happens,start point
      - `stage("name")`
        - `when`: Define *conditionals* for each stage, when to execute
        - `steps`: include some command on the Jenkins server
    - `post`: execute some logic after all stages executed
      - Conditions
        - `always`: this script is always executed whatever if the build failed or succeed.
        - `success`
        - `failure`
      - Build Status or Build Status Changes
- Use Environmental Variables in Jenkinsfile
  - Check variables available in Jenkins: `localhost:8080/env-vars.html`
  - We can define our own variables as well by `environment` attribute
- Access build tools for projects
  - Only 3 build tools available: Maven, Cradle, JDK

## 5. Create Multi-branch Pipelines with Git

- Branch source: project we want to build
- Consider which pipeline we want to build
  - Discover branches: filter by name(with regular expression)
    - `*`: all branches in the original selected project.
    - `^`: start from some character
    - `$`: end character
    - `|`: or
    - eg: `^feature|master|dev.$`
- Build Configurations: mode: by Jenkinsfile
- Credentials
  - Scopes:
    - System
      - only available on Jenkins server
      - not visible for Jenkins jobs
    - Global
      - available everywhere
    - Project
      - Limited to the project
      - only with multi-branch pipeline
      - comes from folder plugin: to organize build jobs in folders
  - Types:
    - Username & Password
    - Secret file
    - Secret text
    - Certificate
    - SSH Username with private key
    - ...New types based on plugins
  - ID: reference for your credentials
- Scan Multi-branch Pipeline Log: 
  ```
  ‘Jenkinsfile’ found
  Processed 5 branches
  [周二 6月 06 16:11:41 CST 2023] Finished branch indexing. Indexing took 8.1 sec
  Finished: SUCCESS
  ```

## 6. Configure Build Tools in Jenkins

- Develop your application. Then Jenkins builds and packages that app. Hence, build tool is needed.
  - Backend: Maven, Gradle (for Java application)
  - Frontend: npm, yarn (for JavaScript application)
- Some build tools are *already installed* in Jenkins, while others we need to *install and configure*.
  - Check: Manage Jenkins→Global Tool Configuration
    - Automatically installed: Gradle, Maven, Ant, Git
  - Install npm/yarn from Plugins and Check the Existence
    - npm: Available plugins → search **NodeJS** → install
    - Global Tools Configuration → type in `yarn@1.13.0` at *Global npm packages to install*
      - General syntax: `packageName@version`
    - Now both npm and yarn are available.
```
  Checking branch master
      ‘Jenkinsfile’ not found
    Does not meet criteria
Processed 5 branches
[周二 6月 06 20:46:32 CST 2023] Finished branch indexing. Indexing took 3.8 sec
Finished: SUCCESS
```

- Use Build Tools in Jenkinsfile
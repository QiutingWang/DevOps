def gv

pipeline {
    agent any
    environment{
      NEW_VERSION = '1.4.0'
      SERVER_CREDENTIALS = credentials('demo-app-git-credentials')
    }
    tools{
      maven 'Maven'
    }
    parameters {
        choice(name: 'VERSION', choices: ['1.1.0', '1.2.0', '1.3.0'], description: '')
        booleanParam(name: 'executeTests', defaultValue: true, description: '')
    }
    stages {
        stage("init") {
            steps {
                script {
                   gv = load "script.groovy" 
                }
            }
        }
        stage("build") {
            // when{
            //   expression{
            //     BRANCH_NAME == 'dev' 
            //   }
            // }
            steps {
                script {
                    gv.buildApp()
                }
                echo "Building version ${NEW_VERSION}" //if we want it to be a string, we need double quotation mark.
                sh "mvn install"
            }
        }
        stage("test") {
            when {
                expression {
                    params.executeTests == true
                }
            }
            steps {
                script {
                    gv.testApp()
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    gv.deployApp()
                }
                // echo "deploying with ${SERVER_CREDENTIALS}"
                // sh "${SERVER_CREDENTIALS}"
                //Another Way: wrapper script
                withCredentials([
                  usernamePassword(credentials: 'demo-app-git-credentials', usernameVariable: USER, passwordVariable: PWD) //pass in an object, Type of Credential we set is `Username with Password` //username and password are stored in variables
                ]){
                  sh "some script ${USER} ${PWD}"
                }
                echo "deploying version ${params.VERSION}"
            }
        }
    }  
}
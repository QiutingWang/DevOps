pipeline{
  agent any
  tools{
    gradle 'Gradle-8.2'
  }
  stages{
    stage("run frontend"){
      steps{
        echo 'executing yarn...'
        nodejs('Node-17.7.2'){
          sh 'yarn install'
          sh 'yarn build'
        }
      }
    }
    stage("run backend"){
      steps{
        echo 'executing gradle...'
        // withGradle(){ //wrapper (Method2)
        //   sh './gradlew -v' //create a version of gradle
        // }
        sh './gradlew -v'
      }
    }
  }
}
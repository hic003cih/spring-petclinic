// Declarative CI pipeline for spring-petclinic.
// Jenkins runs these stages on every change pushed to the fork:
// checkout -> build -> test -> SAST. Later subtasks add DAST and deploy.
pipeline {
    agent any

    triggers {
        // Poll the GitHub fork for new commits about every 5 minutes.
        // Takes effect after the first build, once Jenkins has read this file.
        pollSCM('H/5 * * * *')
    }

    options {
        // Keep only the last 10 builds so the disk does not fill up.
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull source from the SCM configured on this job (the fork).
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Compile and package with the Maven wrapper. Skip tests here;
                // the next stage runs them so build vs test failures are distinct.
                sh './mvnw -B clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                // Unit tests use an embedded H2 database, so no external DB is needed.
                sh './mvnw -B test'
            }
        }

        stage('SAST') {
            steps {
                // withSonarQubeEnv injects the server URL and token from the Jenkins
                // SonarQube config named 'SonarQube', then Maven uploads the analysis.
                withSonarQubeEnv('SonarQube') {
                    sh './mvnw -B sonar:sonar'
                }
            }
        }
    }

    post {
        always {
            // Publish the JUnit report so Jenkins shows pass/fail results.
            junit '**/target/surefire-reports/*.xml'
        }
    }
}

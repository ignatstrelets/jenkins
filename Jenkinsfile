#!/usr/bin/env groovy

pipeline {

    parameters {
    booleanParam(name: "TEST", defaultValue: false)
    string(name: "APP_PORT", defaultValue: '8000')
    }
    
    environment {
	APP_PORT = "${params.APP_PORT}"
        CI = 'true'
    }

    agent {
        docker {
            image 'node'
            args "${env.APP_PORT}:${env.APP_PORT} -u root "
        }
    }
    options {
            timeout(time: 20, unit: 'SECONDS')
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'npm install'
	        echo "Docker container running on ${env.APP_PORT} with CI ${env.CI}"
            }
        }
        stage('Test') {
            steps {
		script {
		    if (params.TEST) {
			sh "APP_PORT=${params.APP_PORT} npm test"
		    }
		}
            }
        }
    }
}

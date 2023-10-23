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
            args '-u root -p $APP_PORT:$APP_PORT'
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
